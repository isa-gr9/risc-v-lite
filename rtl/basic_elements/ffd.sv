module FD (
    input logic D,
    input logic CK,
    input logic RESET,
    input logic ENABLE,
    output logic Q
);


    always_ff @(posedge CK or negedge RESET or negedge ENABLE)
    begin
        if (!RESET) Q <= 1'b0;
        else begin
            if (ENABLE) Q <= D;
        end
    end

endmodule

