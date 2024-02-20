module decodeUnit #(parameter nbits = 32, bits = 32) (
  input logic clk,
  input logic rst,
  input logic [14:0] cw,
  input logic [3:0] aluop,
  input logic [4:0] addrWrIn,
  input logic pipe_en,
  input logic wr_en,
  input logic [nbits-1:0] ir_in,
  input logic [nbits-1:0] npc_in,
  input logic [nbits-1:0] pc_in,
  input logic [nbits-1:0] datain,
  input logic flush,
  input logic hazflush,
  output logic [nbits-1:0] r1,
  output logic [nbits-1:0] r2,
  output logic [nbits-1:0] imm_out,
  output logic [nbits-1:0] npc_out,
  output logic [nbits-1:0] pc_out,
  output logic [12:0] cw_exe,
  output logic [3:0] aluop_exe,
  output logic [4:0] Rdestination
);

  logic rstfls;
  logic [nbits-1:0] RF_out1, RF_out2, signExtOut;

  // flush logic
  assign rst_logic = rst | flush | !hazflush;
  assign rst_cw = rst | flush;

  //control word signals dispatch
  assign rd1_en = cw[14];
  assign rd2_en = cw[13];


//register generator (decoder)
 register_generator #(nbits) generator_inst (
  .IR_IN(ir_in),
  .RS1(add_r1),
  .RS2(add_r2),
  .RD(add_wr),
  .IMM(signExtOut)
 );

//register file
  REGISTER_FILE #(nbits) rf_inst (
    .CLK(clk),
    .RESET(rst),
    .RD1(rd1_en),
    .RD2(rd2_en),
    .WR(wr_en),
    .ADD_RD1(add_r1),
    .ADD_RD2(add_r2),
    .ADD_WR(addrWrIn),
    .DATAIN(data_in),
    .OUT1(RF_out1),
    .OUT2(RF_out2)
  );

/*********************************************
* Pipeline registers
*********************************************/

// CONTROL WORD PIPELINE REGISTER
  register_generic #(13) cw_reg_inst (
    .data_in(cw[12:0]),
    .CK(clk),
    .RESET(rst_cw),
    .ENABLE(pipe_en), //Always enabled
    .data_out(cw_exe)
  );

  register_generic #(4) aluop_reg_inst (
    .data_in(aluop),
    .CK(clk),
    .RESET(rst_cw),
    .ENABLE(pipe_en), //Always enabled
    .data_out(aluop_exe)
  );

  register_generic #(4) register_dest_pipe (
    .data_in(add_wr),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en), //Always enabled
    .data_out(Rdestination)
  );

  register_generic #(nbits) pc_pipe_inst (
    .data_in(pc_in),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en), //Always enabled
    .data_out(pc_out)
  );

  register_generic #(nbits) npc_pipe_inst (
    .data_in(npc_in),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en), //Always enabled
    .data_out(npc_out)
  );

  register_generic #(nbits) imm_pipe_inst (
    .data_in(signExtOut),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en),
    .data_out(Imm_out)
  );


  register_generic #(nbits) reg1_pipe_inst (
    .data_in(RF_out1),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en),
    .data_out(r1)
  );

  register_generic #(nbits) reg2_pipe_inst (
    .data_in(RF_out2),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en),
    .data_out(r2)
  );




endmodule
