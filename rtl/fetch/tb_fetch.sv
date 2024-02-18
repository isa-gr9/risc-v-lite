// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns


module tb_fetch;
    parameter nbits=32;


    logic clk = 1'b0;
    logic rst = 1'b1;
    logic stall, pc_en, mem_rdy, valid, proc_req;

    logic [nbits-1:0] pc, npc, ir, Addr, Rdata; 





// Create a clock generator
always #5 clk = ~clk;

initial begin
    #5 rst = 1'b0;  // After 5 time units, set rst to 0
end


always_comb begin 
    if (stall)
        pc_en = 1'b0;
    else
        pc_en = 1'b1;
end

    ifu #(nbits) 
        FU (
         .clk(clk), 
         .rst(rst),
         .brjmp_ctrl(1'b0),         // Select bit for the next program counter
         .hazard(1'b1),             // Control bit for hazard detection
         .flush(1'b0),              // Control bit for flushing the registers after branch
         .pipe_en(1'b1),            // Control bit for enabling the registers
         .mem_rdy(mem_rdy),            // from IMEM for req/rdy protocol
         .valid(valid),              // from IMEM for req/rdy protocol
         .pc_en(pc_en),              // control bit from CU
         .jpc(32'd0),     // branch/jump pc
         .rdata(Rdata),   // from IMEM for req/rdy protocol
         .proc_req(proc_req),           // to IMEM for req/rdy protocol
         .stall(stall),              // to CU for stalling the pipeline
         .pc(pc),      // to IF/ID 
         .pc2mem(Addr),  // to IMEM for req/rdy protocol
         .npc(npc),     // to IF/ID 
         .ir(ir)       // to decode unit
);




   mem_wrap_fake #(
                   .CONTENT_TYPE( 0 ),
                   .tco( 0 ),
                   .tpd( 0 )
   ) UUT (
      .CLK( clk ),
      .RSTn( rst ),
      .PROC_REQ( proc_req ),
      .MEM_RDY( mem_rdy ),
      .ADDR(Addr),
      .WE( we ),
      .WDATA(32'd0),
      .RDATA( Rdata ),
      .VALID( valid )
   );

endmodule