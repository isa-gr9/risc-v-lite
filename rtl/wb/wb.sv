module wb #(parameter N = 32) (

    input logic [1:0] WBmuxSel,       // from CU!

    input logic [N-1:0] ALUres,
    input logic [N-1:0] MEMread,        //data read from memory
    input logic [N-1:0] NPCin,
    input logic [N-1:0] IMMin,

    output logic [N-1:0] muxOut
);


    always_comb begin
        case (WBmuxSel) 
            2'b00: 
                assign muxOut = NPCin;
            2'b01: 
                assign muxOut = ALUres;
            2'b10: 
                assign muxOut = MEMread;
            default: 
                assign muxOut = IMMin; 
        endcase;

endmodule;