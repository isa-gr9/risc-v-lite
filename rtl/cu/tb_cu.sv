`timescale 1ns / 1ns

module tb_cu;

    // Parameters
    //parameter CLK_PERIOD = 10; // Clock period in ns

    // Inputs
    logic [31:0] instr;
    logic clk;

    // Outputs
    logic [1:0]  mem2reg;
    logic [3:0]  aluOp;
    logic [2:0]  branchContr;
    logic        regWrite;
    logic        aluSrc1;
    logic        aluSrc2;
    logic        memWrite;
    logic        memRead;
    logic        jump;
    logic        lsReq;

    // Instantiate Control Unit
    cu dut (
        .instr(instr),
        .mem2reg(mem2reg),
        .aluOp(aluOp),
        .branchContr(branchContr),
        .regWrite(regWrite),
        .aluSrc1(aluSrc1),
        .aluSrc2(aluSrc2),
        .memWrite(memWrite),
        .memRead(memRead),
        .jump(jump),
        .lsReq(lsReq)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test Stimulus
    initial begin
        // Reset
        instr <= 32'h00000000; // No operation (NOP)
        #10;

        // Test LW instruction
        instr <= 32'h0005a703; // LW instruction (opcode: 0000011)
        #10;

        // Test SW instruction
        instr <= 32'h0116a023; // SW instruction (opcode: 0100011)
        #10;

        // Test R-type instruction (e.g., ADD)
        instr <= 32'h00e78733; // ADD instruction (opcode: 0110011)
        #10;

        // Test I-type instruction (e.g., ADDI)
        instr <= 32'h00f70713; // ADDI instruction (opcode: 0010011)
        #10;

        // Test U-type instruction (e.g., LUI)
        instr <= 32'h100107b7; // LUI instruction (opcode: 0110111)
        #10;

        // Test branch instruction (e.g., BEQ)
        //instr <= 32'h80000063; // BEQ instruction (opcode: 1100011)
        //#10;

        // Test jump instruction (e.g., JAL)
        instr <= 32'h014000ef; // JAL instruction (opcode: 1101111)
        #10;

        // Test JALR instruction
        instr <= 32'h00008067; // JALR instruction (opcode: 1100111)
        #10;

        // Test noop instruction
        instr <= 32'h00000013; // NOOP (opcode: 0000000)
        #10;

        instr <= 32'h00e5e463; // bltu
        #10;

        instr <= 32'h00b75463; // ble
        #10;

        instr <= 32'h40b70733; // sub
        #10;


        $finish;
    end

endmodule
