module decodeUnit #(parameter nbits = 64, bits = 32) (
  input logic clk,
  input logic rst,
  input logic RegA_LATCH_EN, // from CU
  input logic RegB_LATCH_EN, // from CU
  input logic RegIMM_LATCH_EN, // from CU
  input logic RF_WE, // from CU
  input logic [nbits-1:0] DATAIN, // from WB
  output logic [nbits-1:0] RD1,
  output logic [nbits-1:0] RD2,
  output logic [nbits-1:0] Imm_out,
  input logic [nbits-1:0] IR_IN,
  input logic [nbits-1:0] NPC_IN,
  output logic [nbits-1:0] NPC_OUT
);

  logic [nbits-1:0] RegisterAout, RegisterBout;
  logic [bits-1:0] signExtIn;
  logic [nbits-1:0] RF_out1, RF_out2;
  logic [4:0] RS1, RS2, WR_ADDR;

  // Register components declaration
  register_generic #(nbits) NPC2 (
    .data_in(NPC_IN),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1), //Always enabled
    .data_out(NPC_OUT)
  );

  register_generic #(nbits) Imm (
    .data_in(signExtOut),
    .CK(clk),
    .RESET(rst),
    .ENABLE(RegIMM_LATCH_EN),
    .data_out(Imm_out)
  );

  SIGN_EXT #(bits) Signext (
    .inputt(signExtIn),
    .outputt(signExtOut)
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

   register_generic #(nbits) IR2 (
    .data_in(RF_out2),
    .CK(clk),
    .RESET(rst),
    .ENABLE(RegB_LATCH_EN),
    .data_out(RD2)
  );

  // Signal assignments TO CHANGE WHEN WE DO THE CU
  assign RS1 = IR_IN[25:21];
  assign RS2 = IR_IN[20:16];
  assign WR_ADDR = (IR_IN[31:26] == 6'b0) ? IR_IN[15:11] : IR_IN[20:16];
  assign signExtIn = IR_IN[15:0];

endmodule
