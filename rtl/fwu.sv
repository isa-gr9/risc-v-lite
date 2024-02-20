module fwu (
    input logic [4:0] src1,
    input logic [4:0] src2,
    input logic [4:0] EX_MEM_dest,
    input logic [4:0] MEM_WB_dest,
    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

always_comb begin
    if (EX_MEM_dest == src1)
        ForwardA <= 10; //The first ALU op is forwarded from the prior ALU result
    else if (EX_MEM_dest == src2)
        ForwardB <= 10;
    else if (MEM_WB_dest == src1)
        ForwardA <= 01; //The first ALU op is forwarded drom data memory or an earlier ALU result
    else if (MEM_WB_dest == src2)
        ForwardB <= 01;
    else
        ForwardA <= 00;
        ForwardB <= 00;
end

endmodule
