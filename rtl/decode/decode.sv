module decodeUnit #(parameter nbits = 32, bits = 16) (
  input logic clk,
  input logic rst,
  input logic RegA_LATCH_EN,
  input logic RegB_LATCH_EN,
  input logic RegIMM_LATCH_EN,
  input logic RF_WE,
  input logic [nbits-1:0] DATAIN,
  input logic [nbits-1:0] IR_OUT,
  output logic [nbits-1:0] A_out,
  output logic [nbits-1:0] B_out,
  output logic [nbits-1:0] Imm_out,
  input logic [nbits-1:0] IR_IN2,
  output logic [nbits-1:0] IR_OUT2,
  input logic [nbits-1:0] NPC_IN,
  output logic [nbits-1:0] NPC2_OUT
);

  logic [nbits-1:0] RegisterAout, RegisterBout, RegisterImmOut;
  logic [bits-1:0] signExtIn;
  logic [nbits-1:0] signExtOut, RF_out1, RF_out2;
  logic [4:0] RS1, RS2, WR_ADDR;
  logic [nbits-1:0] datainRF, IR_OUTs, IR_IN2s, IR_OUT2s, NPC_INs, NPC2_OUTs;

  // Register components declaration
  register_generic #(nbits) NPC2 (
    .data_in(NPC_INs),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .data_out(NPC2_OUTs)
  );

  register_generic #(nbits) Imm (
    .data_in(signExtOut),
    .CK(clk),
    .RESET(rst),
    .ENABLE(RegIMM_LATCH_EN),
    .data_out(RegisterImmOut)
  );

  register_generic #(nbits) IR2 (
    .data_in(IR_OUTs),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .data_out(IR_OUT2s)
  );

  SIGN_EXT #(bits) Signext (
    .inputt(signExtIn),
    .outputt(signExtOut)
  );

  REGISTER_FILE #(nbits) RF (
    .CLK(clk),
    .RESET(rst),
    .ENABLE(1'b1), 
    .RD1(1'b1), 
    .RD2(1'b1), 
    .WR(RF_WE),
    .ADD_RD1(RS1),
    .ADD_RD2(RS2),
    .ADD_WR(WR_ADDR),
    .DATAIN(datainRF),
    .OUT1(RF_out1),
    .OUT2(RF_out2)
  );

  // Signal assignments
  assign RS1 = IR_OUT[25:21];
  assign RS2 = IR_OUT[20:16];
  assign WR_ADDR = (IR_IN2[31:26] == 6'b0) ? IR_IN2[15:11] : IR_IN2[20:16];
  assign IR_OUTs = IR_OUT;
  assign IR_OUT2 = IR_OUT2s;
  assign IR_IN2s = IR_IN2;
  assign signExtIn = IR_OUT[15:0];
  assign A_out = RF_out1;
  assign B_out = RF_out2;
  assign Imm_out = RegisterImmOut;
  assign datainRF = DATAIN;
  assign NPC_INs = NPC_IN;
  assign NPC2_OUT = NPC2_OUTs;

endmodule

module register_generic #(parameter nbits = 32) (
  input logic [nbits-1:0] data_in,
  input logic CK,
  input logic RESET,
  input logic ENABLE,
  output logic [nbits-1:0] data_out
);

  always @(posedge CK or negedge RESET) begin
    if (!RESET) begin
      data_out <= 0;
    end else if (ENABLE) begin
      data_out <= data_in;
    end
  end

endmodule
