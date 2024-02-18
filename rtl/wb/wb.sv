module wb #(parameter N = 32) (

    input logic [1:0] mem2reg,       // from CU
    input logic [N-1:0] ALUres,      // from memstage
    input logic [N-1:0] MEMread,     // Data read from memory
    input logic [N-1:0] NPCin,       // from MEM/WB reg
    output logic [N-1:0] regDest     // register destination
);


    always_comb begin
        case (mem2reg) 
            2'b00:
                muxOut = NPCin;
            2'b01: 
                muxOut = ALUres;
            2'b10: 
                muxOut = MEMread;
            default: 
                muxOut = IMMin; 
        endcase;
    end

endmodule