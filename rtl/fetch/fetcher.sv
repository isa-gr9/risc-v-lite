/***************************************************************************
*
* Title        : Fetcher module
* Project      : Lab3 ISA risc-v
****************************************************************************
* File         : ifu.sv
* Author       : group9
*
****************************************************************************
* Description  : This file implements the req/rdy protocol and has the goal 
*                of separating the pipeline from the instruction memory. 
*                It is able to stall the pipeline if the memory is slow
*
******************************************************************************/

module fetcher #(parameter bits = 32) (
    input  logic clk,
    input  logic rst,                  // Active low reset signal
    input  logic mem_rdy,              // from IMEM
    input  logic valid,                // from IMEM
    input  logic pc_en,                // from PC
    input  logic [bits-1:0] addr_in,   // from PC
    input  logic [bits-1:0] rdata,     // Read Data
    output logic [bits-1:0] addr_out,  // to IMEM
    output logic [bits-1:0] ir,        // from IMEM
    output logic stall,                // disable PC
    output logic proc_req              // to IMEM
);
    logic [31:0] addr_tmp;
    logic prev_proc_req, prev_mem_ready;

    always_ff @( posedge clk or negedge rst ) begin : pcenable
        if(!rst) stall <= 1'b0;
        else begin
            if( (prev_proc_req && !prev_mem_ready && !mem_rdy) || //Request sent, mem not ready
                (prev_proc_req && prev_mem_ready && !valid)    || //Request accepted, data not valid
                (!prev_proc_req && !valid)                     || //Request accepted more clock cycle before, signal not valid yet
                (prev_proc_req && mem_rdy && !valid))             //Request sent, mem ready now, signal not valid
                stall <= 1'b1;
            else stall <= 1'b0;
        end
    end


    always_ff @( posedge clk or negedge rst ) begin : addrout
        if(!rst) addr_out <= 32'h00000000;
        else begin
            if(proc_req) begin
                addr_out <= addr_in;    //Address sent together with the request
            end
        end
    end


    always_ff @( posedge clk or negedge rst ) begin : procreq
        if(!rst) proc_req <= 1'b1;
        else begin
            if(pc_en) begin
                proc_req <= 1'b1;           //If pc enable, a request is sent
            end
            else if(prev_proc_req && prev_mem_ready) proc_req <= 1'b0;  //mem ready an proc high for one clock cycle
        end
    end


    always_comb begin : response
        if (valid) begin
            ir = rdata;     //whenever is valid, is out
        end
    end


    always_ff @(posedge clk or posedge rst) begin :prevRequest
         if (!rst) begin
             prev_mem_ready <= 1'b0;  // Initialize to some default value
         end else begin
             prev_mem_ready <= mem_rdy;
         end
     end


    always_ff @(posedge clk or posedge rst) begin : prevMem
         if (!rst) begin
             prev_proc_req <= 1'b0;  // Initialize to some default value
         end else begin
             prev_proc_req <= proc_req;
         end
     end
endmodule
