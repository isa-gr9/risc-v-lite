module fetcher #(parameter bits = 32) (
    input logic clk,     // Clock signal
    input logic rst, // Active low reset signal
    input logic [bits-1:0] ADDR_IN, // data received from the fetch stage; in the fetcher, it is the PC that has to be rcvd to memory
    input logic mem_rdy, // flag from memory, it indicates it has received the address and it is elaborating the request
    input logic valid, //flag from memory, it indicates that the operation has terminated
    //input logic branch_instr, //flag from Control Unit, it indicates that  it has been fetched a branch instruction and the fetch must stop
    //input logic cond, // input from the CU, it indicates wheter the condition of the branch is respected or not
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

    state_t cur_state;


    integer i, j;
    logic [31:0] fifo[0:99];
    logic [bits-1:0] addr_tmp;
    logic [bits-1:0] response;
    logic pending;

    always_comb begin : fifo_h
        if(!rst) i = 0;
        else begin
            fifo[i] = ADDR_IN;
            i = i + 1;
        end
    end


    always_ff @( posedge clk ) begin : blockName
        if (!rst) begin
            j <= 0;
            pending <= 1'b0;
        end

        cur_state <= IDLE_PHASE;
        if(mem_rdy && !pending && rst) begin
            addr_tmp <= fifo[j];
            j <= j + 1;
            pending <= 1'b1;
            cur_state <= ADDR_PHASE;
            proc_req <= 1'b1;
        end

        if(valid && pending && rst) begin
            response <= RDATA;
            pending <= 1'b0;
            cur_state <= RESPONSE_PHASE;
        end
    end

    always_comb begin : instrOut
        if(valid && pending) INSTR_OUT = RDATA;
    end


    assign ADDR_OUT = addr_tmp;
    //assign INSTR_OUT = RDATA;
    assign we = 1'b0;
    assign PC_en = 1'b1;


endmodule


