module register_generic #(parameter integer nbits = 32) (
    input logic [nbits-1:0] data_in,
    input logic CK,
    input logic RESET,
    input logic ENABLE,
    output logic [nbits-1:0] data_out
);

    logic [nbits -1 : 0] register;

    always_ff @( posedge CK or negedge RESET) begin
        if (!RESET)
            register <= '0;
        else if (ENABLE) register <= data_in;
    end

    assign data_out = register;

endmodule
