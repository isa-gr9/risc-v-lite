module fwu (
    input logic [4:0] src1,
    input logic [4:0] src2,
    input logic [4:0] EX/MEM_dest,
    input logic [4:0] MEM/WB_dest,
    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

always_comb begin
    if (EX/MEM_dest == src1)
        ForwardA <= 2b'10; //The first ALU op is forwarded from the prior ALU result
    else if (EX/MEM_dest == src2)
        ForwardB <= 2b'10;
    else if (MEM/WB_dest == src1)
        ForwardA <= 2b'01; //The first ALU op is forwarded drom data memory or an earlier ALU result
    else if (MEM/WB_dest == src2)
        ForwardB <= 2b'01;
    else
        ForwardA <= 2b'00;
        ForwardB <= 2b'00;
end

endmodule
