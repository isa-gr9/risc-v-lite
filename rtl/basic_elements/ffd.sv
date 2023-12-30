module FD (
    input logic D,
    input logic CK,
    input logic RESET,
    input logic ENABLE,
    output logic Q
);

    always_ff @(posedge CK or posedge RESET)
    begin
        if (ENABLE) begin
            if (RESET) begin
                Q <= 1'b0;
            end else begin
                Q <= D;
            end
        end
    end

endmodule

