// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns


module tb_exe;
    parameter N=64;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic regENABLE = 1'b1;
    logic [N-1 : 0] PCin;
    logic [N-1 : 0] A;
    logic [N-1 : 0] B;
    logic [N-1 : 0] Imm;
    logic MUXsel;
    logic [3:0] AluCTR;
    logic [N-1 : 0] NPCb;
    logic [N-1 : 0] ALUresult;
    logic [N-1 : 0] Bout;
    logic zero;
    
    execute exe(.clk(clk), .rst(rst), .regEn(regENABLE), .NPCin(PCin), .A(A), .B(B), .Imm(Imm), .muxSel(MUXsel), .aluControl(AluCTR), .NPCbranch(NPCb), .ALUres(ALUresult), .Bout(Bout));

// Create a clock generator
always #5 clk = ~clk;
initial begin
    #5 rst = 1'b0;  // After 3 time units, set rst to 0
end


initial begin

    PCin = 64'h400004;  //addi gp,gp,16
    A = 64'h1fc18;
    B = 64'h00000000;
    Imm = 64'h00000010; //16
    MUXsel = 1'b1; //Select Imm
    AluCTR = 4'b0001; //addition

    repeat(3) @(posedge clk);

    PCin = 64'h400088;  //sub	a1,a1,a4
    A = 64'h21d; //541
    B = 64'h266; //614
    Imm = 64'h00000010; //16
    MUXsel = 1'b0; //Select B
    AluCTR = 4'b0010; //subtraction

    repeat(3) @(posedge clk);

    PCin = 64'h4000b4;  //ble	a1,a4,4000bc
    A = 64'h21d; //541
    B = 64'h266; //614
    Imm = 64'h8;
    MUXsel = 1'b0; //Select B
    AluCTR = 4'b1011; //LEQ

    repeat(3) @(posedge clk);

    PCin = 64'h4000b4;  //ble	a1,a4,4000bc
    A = 64'h266; //614 
    B = 64'h21d; //541
    Imm = 64'h8; 
    MUXsel = 1'b0; //Select B
    AluCTR = 4'b1011; //LEQ
    
end
endmodule




