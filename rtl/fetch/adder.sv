module adder #(parameter bits=32) (
    input logic [bits-1:0] PC,
    output logic [bits-1:0] NPC
);

always_comb begin
    NPC=PC+4;
end


endmodule
