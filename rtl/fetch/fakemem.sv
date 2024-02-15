module fakemem (
    input logic [31:0] ADDR_IN,
    output logic [31:0] RDATA
);
    logic [31:0] datatmp = 32'h00000000;

    logic [31:0] INSTR_LIST [0:5] = '{32'h00000001, 32'h00000002, 32'h00000003, 32'h00000004, 
                                      32'h00000005, 32'h00000006}; // Corrected syntax for array initialization

    assign RDATA = INSTR_LIST[ADDR_IN[5:0]]; // Corrected syntax for array indexing

endmodule