module execute #(parameter N = 32) (
    input logic clk,
    input logic rst,
    input logic regEn,         //fromCU!!
    input logic [N-1:0] NPCin,   
    input logic [N-1:0] A,        
    input logic [N-1:0] B,
    input logic [N-1:0] Imm,
    input logic muxSel,       //from CU
    input logic [3:0] aluControl,     //from CU
    output logic [N-1:0] NPCbranch,
    output logic [N-1:0] ALUres,
    output logic [N-1:0] Bout,
    output logic zero   
);

    logic [N-1 : 0] muxOut;
    logic [N-1 : 0] NPC;
    logic [N-1 : 0] ALUout;
    logic ZEROout;

    //branch target address generation
    always_comb
        begin
            NPC = NPCin + {Imm, 1'b0};
        end 
        
    //ALU operand selection
    always_comb begin
        if (muxSel == 1'b0)
            muxOut = B;
        else
            muxOut = Imm;
    end
    
    //ALU instantiation
    ALU #(N) ALU0(
        .A(A),
        .B(muxOut),
        .Op(aluControl),
        .result(ALUout),
        .zero(ZEROout)
        );

            //pipeline registers
    register_generic #(N) NPCbranch_REG_EXMEM (
        .data_in(NPC),
        .CK(clk),
        .RESET(rst),
        .ENABLE(regEn),
        .data_out(NPCbranch)
    );
    
    register_generic #(N) ALUout_REG_EXMEM (
        .data_in(ALUout),
        .CK(clk),
        .RESET(rst),
        .ENABLE(regEn),
        .data_out(ALUres)
    );
    
    register_generic #(N) B_REG_EXMEM (
        .data_in(B),
        .CK(clk),
        .RESET(rst),
        .ENABLE(regEn),
        .data_out(Bout)
    );

    register_generic #(N) ZERO_REG_EXMEM (
        .data_in(ZEROout),
        .CK(clk),
        .RESET(rst),
        .ENABLE(regEn),
        .data_out(zero)
    );

 endmodule