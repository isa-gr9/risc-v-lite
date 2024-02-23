module loadStore #(parameter addressSize = 32, dataSize = 32) (
    input logic clk,
    input logic rst,
    input logic[4:0] wrAddr,                       //for load operations, destination register index to write on the register file
    input logic req,                               //from the CU, = 1 if this is a memory operation
    input logic [addressSize-1 : 0] ADDR_IN,       //from the EX/MEM regisrter, output of the ALU, it's the memory address for the operation(loadstore)
    input logic we_in,                             //from the CU, 1 in case of write operations (store), 0 in case of read operations (load)
    input logic [dataSize-1 : 0] WRITE_DATA,       //data to be written to memory. Sent together with proc req
    input logic mem_rdy,                           //flag from memory, it indicates it has received the address and it is elaborating the request
    input logic valid,                             //flag from memory, it indicates that the operation has terminated
    input logic [dataSize-1:0] rdata,              //data read from memory, valid only if valid is high during its scan
    output logic proc_req, we,                     //flag needed by the req/rdy protocol
    output logic [addressSize-1:0] addr,           //address sent to memory needed to perform the write/read instructioin
    output logic [dataSize-1:0] wdata,             //data to be written in the memory
    output logic [dataSize-1:0] loadData,          //data coming from the memory, to be written back in the register file
    output logic [4 : 0] loadDest,
    output logic stall
);

    logic prev_proc_req, prev_mem_ready, prev_valid;
    logic memOpOn;


    always_comb begin
        if(!rst) stall = 1'b0;
        else begin
            if(memOpOn) begin
                if((!mem_rdy) || (!proc_req && !valid))
                    stall = 1'b1;
            end else
                stall = 1'b0;
        end
    end


    always_comb begin // @( posedge clk or negedge rst ) begin : addrout
            if(proc_req) begin
                addr = ADDR_IN;    //Address sent together with the request
                wdata = WRITE_DATA;
                we = we_in;
            end
    end

    always_comb
    begin
        if(req == 1'b1)                               //when req goes high, begin of a memory operation
            memOpOn = 1'b1;
        if((prev_valid != valid)&&(valid == 1'b1))    //falling edge of valid, end of a memory operation
            memOpOn = 1'b0;
    end

    always_comb begin
        if(!rst) proc_req = 1'b0;
        else begin
            if(req) begin
                proc_req = 1'b1;
            end
            else if(prev_proc_req && prev_mem_ready) proc_req = 1'b0;  //mem ready an proc high for one clock cycle
        end
    end


    always_comb begin : response
        if (valid && !we) begin
            loadData = rdata;
            loadDest = wrAddr;
        end
    end


    always_ff @(posedge clk or negedge rst) begin :prevRequest
         if (!rst) begin
            prev_mem_ready <= 1'b0;  // Initialize to some default value
            prev_proc_req <= 1'b0;
            prev_valid <= 1'b0;
            end else begin
            prev_mem_ready <= mem_rdy;
            prev_proc_req <= proc_req;
            prev_valid <= valid;
         end
     end


endmodule
