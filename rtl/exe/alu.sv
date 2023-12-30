module ALU #(parameter N = 64) (
    input logic [N-1:0] A, B,   // Input operands
    input logic [3:0] Op,        // Operation selector
    output logic [N-1:0] result,   // ALU result
    output logic zero
);

    logic [5:0] shift;
    
    assign shift[5:0] = B[5:0];

    always_comb begin
        case (Op)
            4'b0001:        // Addition
               result = A + B;
            4'b0010:        // Subtraction
              result = A - B;
            4'b0011:        // AND
                result = A & B;
            4'b0100:        // OR
                result = A | B;
            4'b0101:        // XOR
                result = A ^ B;
            4'b0110:        // LLS
                result = A << shift;
            4'b0111: // LRS
                result = A >> shift;
            4'b1000: // ARS
                result = A >>> shift;
            4'b1001: // EQ
                zero = (A == B) ? 1'b1 : 1'b0;
            4'b1010: // NEQ
                zero = (A != B) ? 1'b1 : 1'b0;
            4'b1011: // LEQ
                zero = (A <= B) ? 1'b1 : 1'b0;
            4'b1100: // LT
                zero = (A < B) ? 1'b1 : 1'b0;
            4'b1101: // GEQ
                zero = (A >= B) ? 1'b1 : 1'b0;
            4'b1110: // GT
                zero = (A > B) ? 1'b1 : 1'b0;
            default: // Other cases
                result = 1'b0;
                //zero = 1'b0;
    endcase
end

endmodule
