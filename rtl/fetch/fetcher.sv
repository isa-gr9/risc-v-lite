module fetcher #(parameter bits = 32) (
    input logic clk,     // Clock signal
    input logic rst, // Active low reset signal
    input logic [bits-1:0] ADDR_IN, // data received from the fetch stage; in the fetcher, it is the PC that has to be rcvd to memory
    input logic mem_rdy, // flag from memory, it indicates it has received the address and it is elaborating the request
    input logic valid, //flag from memory, it indicates that the operation has terminated
    input logic branch_instr, //flag from Control Unit, it indicates that  it has been fetched a branch instruction and the fetch must stop
    input logic cond, // input from the CU, it indicates wheter the condition of the branch is respected or not
    input logic [bits-1:0] RDATA, // data (instruction in this case) read from memory, valid only if valid is high during its scan
    output logic proc_req, we,    // flag needed by the req/rdy protocolmì, in the fetcher case will be always low (we only have to read from mem)
    output logic [bits-1:0] ADDR_OUT, //  address sent to memory (PC) needed to perform the read instructioin
    output logic [bits-1:0] INSTR_OUT, // data read from the memory, it represents the instruction that has to be fetched and pointed by PC
    output logic PC_en // control bit sent to the PC register in the fetch unit to regulate the fetch operations
);

/* States */
typedef enum logic [2:0] {
    INIT_PHASE     = 3'b000,
    IDLE_PHASE     = 3'b001,
    ADDR_PHASE     = 3'b010,
    RESPONSE_PHASE = 3'b100
} state_t;

integer i, j;
logic [31:0] fifo[0:99];
logic [bits-1:0] addr_tmp;
logic [bits-1:0] response;
state_t cur_state, next_state;

always_ff @(posedge clk, negedge rst) begin
    if (rst == 0) begin 
        cur_state <= INIT_PHASE;
        j <= 0;
    end
    else begin 
        cur_state <= next_state;
        if (cur_state == ADDR_PHASE && mem_rdy) j <= j + 1;
    end
end

always_comb begin : fifo_h
    if(rst==0) i = 0;
    else begin
        fifo[i] = ADDR_IN;
        i = i + 1;
    end
end

assign ADDR_OUT = addr_tmp;
assign INSTR_OUT = response;
assign we = 1'b0;

always@(cur_state, mem_rdy, valid) begin
    case (cur_state)
        INIT_PHASE: begin
            proc_req = 0;
            next_state = IDLE_PHASE;
        end
        IDLE_PHASE: begin
            proc_req = 1;
            if (mem_rdy) next_state = ADDR_PHASE;
        end
        ADDR_PHASE: begin
            if(mem_rdy) begin
                addr_tmp = fifo[j];
                next_state = RESPONSE_PHASE;
            end
        end
        RESPONSE_PHASE: begin
            if (valid) begin
                response = RDATA;
                next_state = ADDR_PHASE;
            end
        end
        default: begin
            next_state = IDLE_PHASE;
        end
    endcase
end
endmodule


