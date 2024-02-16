module fetcher #(parameter bits = 32) (
    input  logic clk,
    input  logic rst,                // Active low reset signal
    input  logic mem_rdy,            // from IMEM
    input  logic valid,              // from IMEM
    input  logic pc_en,              // from PC
    input  logic [bits-1:0] ADDR_IN, // from PC
    input  logic [bits-1:0] RDATA, // data (instruction in this case) read from memory, valid only if valid is high during its scan
    output logic [bits-1:0] ADDR_OUT, //  address sent to memory (PC) needed to perform the read instructioin
    output logic [bits-1:0] INSTR_OUT, // data read from the memory, it represents the instruction that has to be fetched and pointed by PC
    output logic stall,
    output logic proc_req   // flag needed by the req/rdy protocolmì, in the fetcher case will be always low (we only have to read from mem)
);
    logic [31:0] addr_tmp;
    logic proc_req_tmp, falling_edge_detected, prev_mem_ready;


    always_ff @(posedge clk or negedge rst) begin : memred

        //        if (proc_req_tmp) begin
        //    proc_req <= 1'b1;
        //end
        if(!rst) begin
          //  proc_req <= 1'b0;
            stall <= 1'b0;
        end
        else if (mem_rdy && proc_req_tmp && pc_en) begin
            //proc_req <= 1'b1;
            stall <= 1'b0;
        end
        else if(mem_rdy && proc_req_tmp && !pc_en) begin
            //proc_req <= 1'b0;
            stall <= 1'b0;
        end
        else if(!mem_rdy && !valid) begin
            stall <= 1'b1;
        end
    end

    always@ (ADDR_IN) begin : request
        if(!rst) begin
            proc_req_tmp = 1'b0;
            addr_tmp = 32'b0; //??
        end
        else begin
            proc_req_tmp = 1'b1;
            ADDR_OUT = ADDR_IN;
        end
    end

    always_comb begin : response
        if (valid) begin
            INSTR_OUT = RDATA;
        end
    end


    always_ff @(posedge clk or posedge rst) begin
        if (!rst) begin
            prev_mem_ready <= 1'b0; // Initialize to some default value
        end else begin
            prev_mem_ready <= mem_rdy;
        end


        
end

    
    always_comb 
        begin 
        if (!rst) 
            falling_edge_detected <= 1'b0;
        else
        if (prev_mem_ready && !mem_rdy) begin
                falling_edge_detected <= 1'b1;
            end else begin
                falling_edge_detected <= 1'b0;
            end
            
        if (falling_edge_detected && valid) begin
            proc_req <= 1'b0;
        end        
        else if (falling_edge_detected && !valid)
            proc_req  <= 1'b1;
        else
        if (proc_req_tmp) begin
            proc_req <= 1'b1;
        end
        end

endmodule
