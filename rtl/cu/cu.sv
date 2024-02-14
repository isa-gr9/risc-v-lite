module cu (
    input  logic [31:0] instr,
    output logic [1:0]  mem2reg,
    output logic [3:0]  aluOp,
    output logic [2:0]  branchContr,
    output logic        regWrite,
    output logic        aluSrc1,
    output logic        aluSrc2,
    output logic        memWrite,
    output logic        memRead,
    output logic        jump,
    output logic        lsReq
);

    logic [6:0]  opcode;
    logic [2:0]  func3;
    logic [6:0]  func7bit5;
    logic [17:0] cw;
    logic [1:0]  aluopTmp;
    logic        branch;


    assign opcode     = instr[6:0];
    assign func3      = instr[14:12];
    assign func7bit5  = instr[30];


    assign {regWrite, aluSrc1, aluSrc2, memWrite, memRead,
            mem2reg, branch, jump, aluopTmp, lsReq} = cw;

    always_comb begin : controlWord
        casez (opcode)
            7'b0000011: cw = 12'b1_1_1_0_1_01_0_0_00_1;  //LW
            7'b0100011: cw = 12'b0_1_1_1_0_xx_0_0_00_1;  //SW
            7'b0110011: cw = 12'b1_0_1_0_0_00_0_0_10_0;  //RTYPE
            7'b0010011: cw = 12'b1_1_1_0_0_00_0_0_00_0;  //ADDI
            7'b0010111: cw = 12'b1_1_0_0_0_00_0_0_00_0;  //AUIPC
            7'b0110111: cw = 12'b1_1_x_0_0_00_0_0_00_0;  //LUI
            7'b1100011: cw = 12'b0_0_0_0_0_00_1_0_00_0;  //BRANCH
            7'b1101111: cw = 12'b1_1_0_0_0_10_0_1_00_0;  //JTYPE
            7'b1100111: cw = 12'b1_1_1_0_0_10_0_1_00_0;  //RET- jalr
            default:    cw = 12'bxxxxxxxxxxxx;           //unknown
        endcase
    end

    always_comb begin : aluControlLogic
        casex (aluopTmp)
            2'b00: aluOp = 4'b0001;  //add
            2'b01: aluOp = 4'b0010;  //sub
            default: casex ({func7bit5, func3})
                4'b0000: aluOp = 4'b0001;  //add
                4'b1000: aluOp = 4'b0010;  //sub
                4'b0001: aluOp = 4'b0110;  //sll
                4'b0101: aluOp = 4'b0111;  //srl
                4'b1101: aluOp = 4'b1000;  //sra
                4'b0100: aluOp = 4'b0101;  //xor
                4'b0111: aluOp = 4'b0011;  //and
                4'b0110: aluOp = 4'b0100;  //or
                default: aluOp = 4'bxxxx;  //unknown
            endcase
        endcase
    end

    always_comb begin : branchLogic
        if(branch) begin
            case (func3)
                3'b000: branchContr  = 3'b001; //beq
                3'b001: branchContr  = 3'b010; //bne
                3'b101: branchContr  = 3'b011; //ble
                3'b110: branchContr  = 3'b100; //bltu
                3'b111: branchContr  = 3'b101; //bgeu
                default: branchContr = 3'bxxx; //unknown
            endcase
        end
        else branchContr = 3'b000; //nobranch
    end
endmodule