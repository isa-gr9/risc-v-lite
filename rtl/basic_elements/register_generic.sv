module register_generic #(parameter integer nbits = 64) (
    input logic [nbits-1:0] data_in,
    input logic CK,
    input logic RESET,
    input logic ENABLE,
    output logic [nbits-1:0] data_out
);

    // Array of FD instances
    FD u_FD [nbits-1:0] (
        .CK(CK),
        .RESET(RESET),
        .D(data_in),
        .ENABLE(ENABLE),
        .Q(data_out)
    );

endmodule
