// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns


module tb_decode;
    parameter nbits=32;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic RegA_LATCH_EN = 1'b1;
    logic RegB_LATCH_EN = 1'b1;
    logic RegIMM_LATCH_EN = 1'b1;
    logic RF_WE;
    logic [nbits-1:0] DATAIN; // from WB
    logic [nbits-1:0] RD1;
    logic [nbits-1:0] RD2;
    logic [nbits-1:0] Imm_out;
    logic [nbits-1:0] IR_IN;
    logic [nbits-1:0] NPC_IN;
    logic [nbits-1:0] NPC_OUT;
    
    decodeUnit Du(.clk(clk), .rst(rst), .RegA_LATCH_EN(RegA_LATCH_EN), .RegB_LATCH_EN(RegB_LATCH_EN), .RegIMM_LATCH_EN(RegIMM_LATCH_EN), .RF_WE(RF_WE), .DATAIN(DATAIN), .RD1(RD1), .RD2(RD2), .Imm_out(Imm_out), .IR_IN(IR_IN), .NPC_IN(NPC_IN), .NPC_OUT(NPC_OUT));

// Create a clock generator
always #5 clk = ~clk;
initial begin
    #5 rst = 1'b0;  // After 3 time units, set rst to 0
end


initial begin
    IR_IN = 32'hff010113; //addi	sp,sp,-16
    NPC_IN = 32'h400038;
    RF_WE = 1'b1;
    DATAIN = 32'h00000010; //INVENTED

    repeat(3) @(posedge clk);

    IR_IN = 32'h100107b7; //lui	a5,0x10010
    NPC_IN = 32'h400024;
    RF_WE = 1'b1;
    DATAIN = 32'h10010000;
    repeat(3) @(posedge clk);
    
    IR_IN = 32'h00e5d463; //ble	a4,a1,400088
    NPC_IN = 32'h400080;
    RF_WE = 1'b0;

    repeat(3) @(posedge clk);

    IR_IN = 32'h0106a423 ; //sw	a6,8(a3)
    NPC_IN = 32'h400100;
    RF_WE = 1'b0;
    DATAIN = 32'h01000100; //INVENTED
    
end
endmodule




