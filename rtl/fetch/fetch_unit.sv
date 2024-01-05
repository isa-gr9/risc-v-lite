module fetch_unit #(parameter bits=32) (
    input logic clk, rst,
    input logic j; //select bit for the next program counter
    input logic mem_ready, valid; // from MEM
    input logic [bits-1:0] Rdata, // from MEM
    input logic [bits-1:0] jPC,
    output logic proc_req, // to the MEM
    output logic [bits-1:0] Add, // to the MEM
    output logic [bits-1:0] NPC,
    output logic [bits-1:0] PC,
    output logic [bits-1:0] IR
);

logic [bits-1] PC_add, PC_in, PC_in2, IR_in;

MUX21_GENERIC #(bits) mux(
    .A(PC_add),
    .B(jPC),
    .S(j),
    .Y(PC_in)
);

register_generic #(bits) nPC(
    .data_in(PC_in),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .Q(PC_in2)
);

adder #(bits) add(
    .PC(PC_in2),
    .NPC(PC_add)
);

fetcher #(bits) fetcher(
    .clk(clk),
    .reset_n(rst),
    .PC(PC_in2),
    .mem_ready(mem_ready),
    .valid(valid),
    .Rdata(Rdata),
    .proc_req(proq_req),
    .Add(Add),
    .Data(IR_in)
);

//Pipeline registers
register_generic #(bits) nPC(
    .data_in(PC_add),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .Q(NPC)
);

register_generic #(bits) nPC(
    .data_in(PC_in2),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .Q(PC)
);

register_generic #(bits) nPC(
    .data_in(IR_in),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .Q(IR)
);

endmodule