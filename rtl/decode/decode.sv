
module decodeUnit #(parameter nbits = 32, bits = 32) (
  input logic clk,
  input logic rst,
  input logic RegA_LATCH_EN,            //?? from CU
  input logic RegB_LATCH_EN,            //?? from CU
  input logic RegIMM_LATCH_EN,          //?? from CU
  input logic RF_WE,                    // from CU
  input logic [nbits-1:0] DATAIN,       // from WB
  input logic flush,
  input logic hazflush,
  output logic [nbits-1:0] RD1,         //?? 
  output logic [nbits-1:0] RD2,         //??
  output logic [nbits-1:0] Imm_out,      //??
  input logic [nbits-1:0] IR_IN,        // from fetcher to Reg_gen
  input logic [nbits-1:0] NPC4_IN,
  output logic [nbits-1:0] NPC4_OUT,
  input logic [nbits-1:0] PC_IN,
  output logic [nbits-1:0] PC_OUT
);

  logic [nbits-1:0] RF_out1, RF_out2, signExtOut;
  logic [4:0] RS1, RS2, WR_ADDR;

  // Register components declaration
  register_generic #(nbits) NPC2 (
    .data_in(PC_IN),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1), //Always enabled
    .data_out(PC_OUT)
  );

  register_generic #(nbits) NPC4 (
    .data_in(NPC4_IN),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1), //Always enabled
    .data_out(NPC4_OUT)
  );

  register_generic #(nbits) Imm (
    .data_in(signExtOut),
    .CK(clk),
    .RESET(rst),
    .ENABLE(RegIMM_LATCH_EN),
    .data_out(Imm_out)
  );

 register_generator #(nbits) RG (
  .IR_IN(IR_IN),
  .RS1(RS1),
  .RS2(RS2),
  .RD(WR_ADDR),
  .IMM(signExtOut)
 );

  REGISTER_FILE #(nbits) RF (
    .CLK(clk),
    .RESET(rst),
    .ENABLE(1'b1), //Always enabled
    .RD1(1'b1), //Always enabled
    .RD2(1'b1), //Always enabled
    .WR(RF_WE),
    .ADD_RD1(RS1),
    .ADD_RD2(RS2),
    .ADD_WR(WR_ADDR),
    .DATAIN(DATAIN),
    .OUT1(RF_out1),
    .OUT2(RF_out2)
  );

   register_generic #(nbits) IR2 (
    .data_in(RF_out1),
    .CK(clk),
    .RESET(rst),
    .ENABLE(RegA_LATCH_EN),
    .data_out(RD1)
  );

   register_generic #(nbits) IR3 (
    .data_in(RF_out2),
    .CK(clk),
    .RESET(rst),
    .ENABLE(RegB_LATCH_EN),
    .data_out(RD2)
  );

  assign rstfls = rst | flush | hazflush;

endmodule
