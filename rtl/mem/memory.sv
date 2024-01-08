module memory #(parameter N = 32) (
    input logic clk,
    input logic rst,
    input logic memRegEn,         //fromCU!!
    input logic branch_en,       // from CU!
    
    input logic [N-1:0] ALUres,
    input logic zero,
    input logic [N-1:0] NPCin,        //PC+4
    input logic [N-1:0] IMMin,
    
    output logic PC_sel,              // to fetch unit, to select program counter
    output logic [N-1:0] ALUout,
    output logic [N-1:0] NPCout,
    input logic [N-1:0] IMMout,    
);

    
    //to generate the control bit for the PC selection (MUX in the fetch stage)
    always_comb begin
        PC_sel <= zero & branch_en;
    end
            
    //pipeline registers
    register_generic #(N) ALU_reg_MEMWB (
        .data_in(ALUres),
        .CK(clk),
        .RESET(rst),
        .ENABLE(memRegEn),
        .data_out(ALUout)
    );
    
    register_generic #(N) NPC_reg_MEMWB (
        .data_in(NPCin),
        .CK(clk),
        .RESET(rst),
        .ENABLE(1'b1),
        .data_out(NPCout)
    );
    
    register_generic #(N) Imm_reg_MEMWB (
        .data_in(IMMin),
        .CK(clk),
        .RESET(rst),
        .ENABLE(memRegEn),
        .data_out(IMMout)
    );
    
    register_generic #(N) NPC_reg_MEMWB (
        .data_in(NPCin),
        .CK(clk),
        .RESET(rst),
        .ENABLE(memRegEn),
        .data_out(NPCout)
    );
                
 endmodule
