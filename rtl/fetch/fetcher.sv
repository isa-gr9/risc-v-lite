module fetcher #(parameter bits = 32) (
    input logic clk,     // Clock signal
    input logic rst, // Active low reset signal
    input logic [bits-1:0] ADDR_IN, // data received from the fetch stage; in the fetcher, it is the PC that has to be rcvd to memory
    input logic mem_rdy, // flag from memory, it indicates it has received the address and it is elaborating the request
    input logic valid, //flag from memory, it indicates that the operation has terminated
    input logic enable,
    input logic [bits-1:0] RDATA, // data (instruction in this case) read from memory, valid only if valid is high during its scan
    output logic freeze,
    output logic proc_req, we,    // flag needed by the req/rdy protocolmì, in the fetcher case will be always low (we only have to read from mem)
    output logic [bits-1:0] ADDR_OUT, //  address sent to memory (PC) needed to perform the read instructioin
    output logic [bits-1:0] INSTR_OUT // data read from the memory, it represents the instruction that has to be fetched and pointed by PC
  //  output logic PC_en // control bit sent to the PC register in the fetch unit to regulate the fetch operations
);
    logic [31:0] addr_tmp;
    logic proc_req_tmp;


    always_ff @( posedge clk or negedge rst ) begin : memred
        if(!rst) begin
            ADDR_OUT <= 32'h00000000;
        end
        else if (mem_rdy && proc_req_tmp && enable) begin
            ADDR_OUT <= addr_tmp;
            proc_req <= 1'b1;
            freeze <= 1'b0;
        end
        else if(mem_rdy && proc_req_tmp && !enable) begin
            ADDR_OUT <= addr_tmp;
            proc_req <= 1'b0;
            freeze <= 1'b0;
        end
        else if(!mem_rdy) begin
            freeze <= 1'b1;
        end
    end

    always_comb begin : request
        if(!rst) begin
            proc_req_tmp = 1'b0;
            addr_tmp = 32'b0; //??
        end
        else begin
            proc_req_tmp = 1'b1;
            addr_tmp = ADDR_IN;
        end
    end

    always_comb begin
        if (valid) begin
            INSTR_OUT = RDATA;
        end
        else INSTR_OUT = 32'hCAFECAFE;
    end
endmodule
