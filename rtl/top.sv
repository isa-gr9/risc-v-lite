module top #(
    parameter NBITS = 32
) (
    input logic clk,
    input logic rst,
    input logic imem_rdy,
    input logic dmem_rdy,
    input logic ivalid,
    input logic dvalid,
    input logic [NBITS-1:0] idata,
    input logic [NBITS-1:0] ddata,
    output logic iproc_req,
    output logic dproc_req,
    output logic [NBITS-1:0] iaddr,
    output logic [NBITS-1:0] daddr
);

    logic pc_en, stall, cw, aluOp, ir;

    datapath #(NBITS) datap_inst (
        .clk(clk),
        .rst(rst),
        .pc_en(pc_en),
        .cw(cw),                // from control unit
        .aluOp(aluOp),        // from contorl unit
        .mem_data(ddata),       // from data memory
        //.IFID_enable(),       //from hazard detection unit
        //.muxControl(),        //from hazard detection unit
        .pc2mem(iaddr),			// to instruction memory
        .mem_addr(daddr),       // to data memory
        .ir2cu(ir),
        .stall(stall)           // to CU
    );


    cu cu_inst (
        .instr(ir),
        .stall(stall),
        .pc_en(pc_en),
        .cw(cw),
        .aluOp(aluOp)
    );

endmodule
