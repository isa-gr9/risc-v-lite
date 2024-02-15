module fetch_unit #(parameter bits=32) (
    input logic clk, rst,
    input logic j, //select bit for the next program counter
    input logic mem_rdy, valid, // from MEM
    input logic [bits-1:0] Rdata, // from MEM
    input logic [bits-1:0] jPC,
    input logic PC_en, // control bit from the fetcher
    output logic proc_req, we,  // to the MEM
    output logic [bits-1:0] NPC,
    output logic [bits-1:0] PC,
    output logic [bits-1:0] IR
);

logic [bits-1:0] PC_add, PC_in, PC_in2, IR_in;

assign IR_in = Rdata;


MUX21_GENERIC #(bits) mux(
    .A(jPC),
    .B(PC_add),
    .S(j),
    .Y(PC_in)
);

register_generic #(bits) nPC1(
    .data_in(PC_in),
    .CK(clk),
    .RESET(rst),
    .ENABLE(PC_en),
    .data_out(PC_in2)
);


adder #(bits) add(
    .PC(PC_in2),
    .NPC(PC_add)
);



//Pipeline registers
register_generic #(bits) nPC2(
    .data_in(PC_add),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .data_out(NPC)
);

register_generic #(bits) nPC3(
    .data_in(PC_in2),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .data_out(PC)
);

register_generic #(bits) nIR(
    .data_in(IR_in),
    .CK(clk),
    .RESET(rst),
    .ENABLE(1'b1),
    .data_out(IR)
);

endmodule
