module memory #(parameter N = 32) (
    input logic clk,
    input logic rst,
    input logic memRegEn,         //fromCU!!
    input logic [N-1:0] ALUres,
    input logic [N-1:0] NPCin,        //PC+4
    input logic [N-1:0] IMMin,
    output logic [N-1:0] ALUout,
    output logic [N-1:0] NPCout,
    output logic [N-1:0] IMMout
);

    

            
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

                
 endmodule
