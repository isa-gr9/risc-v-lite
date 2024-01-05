module MUX21_GENERIC #(parameter bits = 32) (
    input logic [bits-1:0] A,
    input logic [bits-1:0] B,
    input logic S,
    output logic [bits-1:0] Y
);

always_comb begin
    if (S == 1'b1)
        Y = A;
    else
        Y = B;
end

endmodule
