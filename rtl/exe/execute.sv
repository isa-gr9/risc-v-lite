module execute #(parameter N = 32) (
    input logic clk,
    input logic rst,
    input logic[12:0] cwEX,
    input logic[3:0] aluOp,
    input logic pipe_en,
    input logic[N-1:0] Rdest_in,
    input logic [N-1:0] NPCin,
    input logic [N-1:0] NPC4_IN,
    output logic [N-1:0] NPC4_OUT,
    input logic [N-1:0] r1,
    input logic [N-1:0] r2,
    input logic [N-1:0] Imm,
    input logic [1:0] forwardA,       //from forwarding unit
    input logic [1:0] forwardB,
    input logic [N-1:0] MEMWBRdest,
    input logic [N-1:0] EXMEMRdest,
    output logic [N-1:0] jPC,
    output logic [N-1:0] ALUres,
    output logic [N-1:0] Bout,
    output logic [N-1:0] ImmOUT,
    output logic PC_sel,
    output logic [6:0] cwMEM,
    output logic [N-1:0] Rdest
);

    logic [N-1 : 0] muxOutA;
    logic [N-1 : 0] muxOutB;
    logic [N-1 : 0] operand1;
    logic [N-1 : 0] operand2;
    logic [N-1 : 0] NPC;
    logic [N-1 : 0] ALUout;
    logic PC_sel_i;
    logic[8:0] cwMEM_i;
    logic BRANCH_OUTCOME, ZEROout;

    assign muxSelA = cwEX[12];
    assign muxSelB = cwEX[11];
    assign branch = cwEX[10:8];
    assign jmp_en = cwEX[7];

    //branch target address generation
    always_comb                                   //NOTA: NON HO AGGIUNTO IL REGISTRO DI PIPELINE CON jPC PROPAGATO PERCHE' iL JPC PUO ESSERE PRESO DA ALU_RES SE GLI OPERANDI SONO SETTATI CORRETTAMENTE
        begin
            jPC = NPCin + {Imm, 1'b0};
            PC_sel_i <= jmp_en || BRANCH_OUTCOME;
        end 

    always_comb begin
        case (branch)
            3'b000:
                BRANCH_OUTCOME = 0;
            3'b001:                                //BEQ
                if(r1 == r2)
                    BRANCH_OUTCOME = 1;
                else
                    BRANCH_OUTCOME = 0;
            3'b010:                                //BNEQ
                if(r1 != r2)
                    BRANCH_OUTCOME = 1;
                else
                    BRANCH_OUTCOME = 0;
            3'b011:                                //BLEQ
                if(r1 <= r2)
                    BRANCH_OUTCOME = 1;
                else
                    BRANCH_OUTCOME = 0;
            3'b100:                                //BLT
                if(r1 < r2)
                    BRANCH_OUTCOME = 1;
                else
                    BRANCH_OUTCOME = 0;
            3'b101:                                //BGEQ
                if(r1 >= r2)
                    BRANCH_OUTCOME = 1;
                else
                    BRANCH_OUTCOME = 0;
            default: BRANCH_OUTCOME = 0;
        endcase
    end


    //ALU operand selection muxes
    always_comb begin
        if (muxSelA == 1'b0)
            muxOutA = NPCin;
        else
            muxOutA = r1;        //are we sure? 
    end

    always_comb begin
        if (muxSelB == 1'b0)
            muxOutB = r2;
        else
            muxOutB = Imm;
    end

    always_comb begin         //forwording A mux
        casex (forwardA)
            2'b00: operand1 = muxOutA;
            2'b01: operand1 = MEMWBRdest;
            2'b10: operand1 = EXMEMRdest;
            default: operand1 = 'x;
        endcase
    end

    always_comb begin         //forwording B mux
        casex (forwardB)
            2'b00: operand2 = muxOutB;
            2'b01: operand2 = MEMWBRdest;
            2'b10: operand2 = EXMEMRdest;
            default: operand2 = 'x;
        endcase
    end

    //ALU instantiation
    ALU #(N) ALU0(
        .A(operand1),
        .B(operand2),
        .Op(aluOp),
        .result(ALUout),
        .zero(ZEROout)
        );


    register_generic #(N) ALUout_REG_EXMEM (
        .data_in(ALUout),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(ALUres)
    );

    register_generic #(N) B_REG_EXMEM (
        .data_in(operand2),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(Bout)
    );

    register_generic #(N) NPC4_REG_EXMEM (
        .data_in(NPC4_IN),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(NPC4_OUT)
    );

    register_generic #(N) IMM_REG_EXMEM (
        .data_in(Imm),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(ImmOUT)
    );

    register_generic #(7) CW_REG_EXMEM (
        .data_in(cwMEM_i),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(cwMEM)
    );

    register_generic #(1) PC_SEL_EXMEM (
        .data_in(PC_sel_i),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(PC_sel)
    );

    register_generic #(N) RDEST_REG_EXMEM (
        .data_in(Rdest_in),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(Rdest)
    );

 endmodule
