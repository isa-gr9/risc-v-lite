module wb #(parameter N = 32) (

    input logic [1:0]    mem2reg,    // from CU
    input logic          regWrite,   // from CU
    input logic [N-1:0]  ALUres,     // from memstage
    input logic [N-1:0]  MEMread,    // Data read from memory
    input logic [N-1:0]  NPCin,      // from MEM/WB reg
    output logic [N-1:0] regDest     // register destination
);


    always_comb begin
        if (regWrite) begin
            casex (mem2reg)
                2'b00:
                    muxOut = ALUres;
                2'b01:
                    muxOut = MEMread ;
                2'b10:
                    muxOut = NPCin;
                default: 
                    muxOut = 2'bxx;
            endcase
        end
    end

endmodule