module fwu (
    input logic [4:0] src1,
    input logic [4:0] src2,
    input logic [4:0] EXMEM_dest,
    input logic [4:0] MEMWB_dest,
    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

    always_comb begin
        if (EXMEM_dest == src1)
            ForwardA = 2'b10; //The first ALU op is forwarded from the prior ALU result
        else if (EXMEM_dest == src2)
            ForwardB = 2'b10;
        else if (MEMWB_dest == src1)
            ForwardA = 2'b01; //The first ALU op is forwarded drom data memory or an earlier ALU result
        else if (MEMWB_dest == src2)
            ForwardB = 2'b01;
        else
            ForwardA = 2'b00;
            ForwardB = 2'b00;
    end

endmodule
