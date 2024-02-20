// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

module tb_top;
    parameter nbits=32;

    logic clk = 1'b0;
    logic rst = 1'b1;

    logic imem_rdy, dmem_rdy, ivalid, dvalid, idata, ddata, iproc_req, dproc_req, iaddr, daddr, wen;

    // Create a clock generator
    always #5 clk = ~clk;

    initial begin
        #5 rst = 1'b0;  // After 5 time units, set rst to 0
    end

    top #(nbits) top_inst (
        .clk(clk),
        .rst(rst),
        .imem_rdy(imem_rdy),
        .dmem_rdy(dmem_rdy),
        .ivalid(ivalid),
        .dvalid(dvalid),
        .idata(idata),
        .ddata(ddata),
        .iproc_req(iproc_req),
        .dproc_req(dproc_req),
        .iaddr(iaddr),
        .daddr(daddr),
        .op2mem(op2mem),
        .wenMem(wen)
    );


/*      INSTRUCTION MEMORY      */

   mem_wrap_fake #(
                   .CONTENT_TYPE( 0 ),
                   .tco( 0 ),
                   .tpd( 0 )
   ) UUT (
      .CLK( clk ),
      .RSTn( rst ),
      .PROC_REQ( iproc_req ),
      .MEM_RDY( imem_rdy ),
      .ADDR(iaddr),
      .WE( 1'b1 ),    //????? mancante
      .WDATA(32'd0),
      .RDATA( idata ),
      .VALID( ivalid )
   );

/*      DATA MEMORY     */

   mem_wrap_fake #(
                   .CONTENT_TYPE( 1 ),
                   .tco( 0 ),
                   .tpd( 0 )
   ) UUT (
      .CLK( clk ),
      .RSTn( rst ),
      .PROC_REQ( dproc_req ),
      .MEM_RDY( dmem_rdy ),
      .ADDR(daddr),
      .WE( wen ),    //????? mancante
      .WDATA(op2mem),
      .RDATA( ddata ),
      .VALID( dvalid )
   );



endmodule