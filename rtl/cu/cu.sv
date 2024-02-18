module cu (
    input  logic [31:0] instr,
    input  logic        stall,
    output logic        pc_en,
    output logic [15:0] cw,
    output logic [3:0]  aluOp
);
    logic [1:0]  mem2reg;
    logic [2:0]  branchContr;
    logic        regWrite;
    logic        aluSrc1;
    logic        aluSrc2;
    logic        memWrite;
    logic        memRead;
    logic        jump;
    logic        loadReq;
    logic        storeReq;
    logic [6:0]  opcode;
    logic [2:0]  func3;
    logic [6:0]  func7bit5;
    logic [14:0] cw_tmp;
    logic [1:0]  aluopTmp;
    logic        branch;
    logic        rd1_en, rd2_en;

    assign opcode     = instr[6:0];
    assign func3      = instr[14:12];
    assign func7bit5  = instr[30];

    assign {rd1_en, rd2_en, regWrite, aluSrc1, aluSrc2, memWrite, memRead,
            mem2reg, branch, jump, aluopTmp, loadReq, storeReq} = cw_tmp;

    assign cw = {rd1_en, rd2_en, aluSrc1, aluSrc2, branchContr, jump,
                 memWrite, memRead, loadReq, storeReq, mem2reg, regWrite};


    /* stall: 101100000000001 
       alu op :  0001 */

    always_comb begin : controlWord
        begin
            casez (opcode)
                7'b0000011: cw_tmp = 15'b1_0_1_1_1_0_1_01_0_0_00_1_0;  //LW
                7'b0100011: cw_tmp = 15'b1_1_0_1_1_1_0_xx_0_0_00_0_1;  //SW
                7'b0110011: cw_tmp = 15'b1_1_1_0_1_0_0_00_0_0_10_0_0;  //RTYPE
                7'b0010011: cw_tmp = 15'b1_0_1_1_1_0_0_00_0_0_00_0_0;  //ADDI
                7'b0010111: cw_tmp = 15'b0_0_1_1_0_0_0_00_0_0_00_0_0;  //AUIPC
                7'b0110111: cw_tmp = 15'b0_0_1_1_x_0_0_00_0_0_00_0_0;  //LUI
                7'b1100011: cw_tmp = 15'b1_1_0_0_0_0_0_00_1_0_00_0_0;  //BRANCH
                7'b1101111: cw_tmp = 15'b1_0_1_1_0_0_0_10_0_1_00_0_0;  //JTYPE
                7'b1100111: cw_tmp = 15'b1_0_1_1_1_0_0_10_0_1_00_0_0;  //RET- jalr
                default:    cw_tmp = 15'bxxxxxxxxxxxxxxx;           //unknown
            endcase
        end
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


    always_comb begin : stallFromFetcher
        if (stall) pc_en = 1'b0;
        else pc_en = 1'b1;
    end


endmodule
