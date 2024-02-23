module fetcher #(parameter addressSize = 32, dataSize = 32, queueLength = 10) (
    input logic clk,
    input logic rst,                       //for load operations, destination register index to write on the register file                               //from the CU, = 1 if this is a memory operation
    input logic [addressSize-1 : 0] addr_in,       //from the EX/MEM regisrter, output of the ALU, it's the memory address for the operation(loadstore)                             //from the CU, 1 in case of write operations (store), 0 in case of read operations (load)
    input logic mem_rdy,                           //flag from memory, it indicates it has received the address and it is elaborating the request
    input logic valid,                             //flag from memory, it indicates that the operation has terminated
    input logic [dataSize-1:0] rdata,              //data read from memory, valid only if valid is high during its scan
    input logic pc_en,
    input logic brjmp_ctrl,
    output logic proc_req,                     //flag needed by the req/rdy protocol
    output logic [addressSize-1:0] addr_out,           //address sent to memory needed to perform the write/read instructioin
    output logic [dataSize-1:0] wdata,             //data to be written in the memory
    output logic [dataSize-1:0] ir,
    output logic stall
);



    typedef enum logic [1:0] {
    mem_wait = 1'b0,
    valid_wait = 1'b1
    } state_t;

    state_t currentState, nextState;
    logic proc_req_next;

    //sequential logic:
    always @(posedge(clk) or negedge rst) begin
        if(rst == 0) begin
            currentState <= mem_wait;
        end else begin
            currentState <= nextState;
        end 
    end

	//combinational logic
    always_comb
    begin
        case (currentState)
          mem_wait: begin
                //if(pc_en == 1'b1) begin
                proc_req = 1'b1;
                addr_out = addr_in;

                if(mem_rdy == 1'b1) begin
                    nextState = valid_wait;
                    stall = 1'b0;

                end else begin
                    nextState = mem_wait;
                    stall = 1'b1;
                end
            end

            valid_wait: begin
				if(valid == 1'b1) begin
                    ir = rdata;
                    proc_req = 1'b1;
                    addr_out = addr_in;
                    if(mem_rdy == 1'b1) begin
                        nextState = valid_wait;
                        stall = 1'b0;
                    end else begin
                        nextState = mem_wait;
                        stall = 1'b1;
                    end
                end else begin
                    proc_req = 1'b0;
                    stall = 1'b1;
                    nextState = valid_wait;
                end
            end
          endcase
     end
endmodule
