module wb #(parameter N = 32) (
    input  logic [2:0]    cw_wb,
    input  logic [N-1:0]  ALUres,       // from memstage
    input  logic [N-1:0]  MEMread,      // Data read from memory
    input  logic [N-1:0]  NPCin,        // from MEM/WB reg
    input  logic [4:0]    regDest_in,   // from MEM/WB Register destination
    output logic [N-1:0]  data_out,
    output logic [4:0]    regDest_out,  // to RF register destination
    output logic          wr_en
);

    assign wr_en = cw_wb[0];
    assign mem2reg = cw_wb[2:1];
    assign regDest_out = regDest_in;

    always_comb begin
        casex (mem2reg)
            2'b00:
                data_out = ALUres;
            2'b01:
                data_out = MEMread ;
            2'b10:
                data_out = NPCin;
            default: 
                data_out = 2'bxx;
        endcase
    end


endmodule
