/***************************************************************************
*
* Title        : Instruction Fetch Unit
* Project      : Lab3 ISA risc-v
****************************************************************************
* File         : ifu.sv
* Author       : group9
*
****************************************************************************
* Description  : This file implement the instruction fetch unit.
*                It includes a pc register that has an enable signal
*                as output of an AND logic between hazard detection control
*                signal and pc_en signal from the CU (stall of the pipeline).
*                It contains also a fetcher that as the duty of separating
*                the instruction memory from the pipeline. It is able to stall
*                the pipeline if the memory it's slow. If the memory doesn't
*                respond in time, a nop is sent as instruction register 
*                to the pipeline.
*
******************************************************************************/

module ifu #(parameter bits=32) (
    input  logic clk, rst,
    input  logic brjmp_ctrl,         // Select bit for the next program counter
    input  logic hazard,             // Control bit for hazard detection
    input  logic flush,              // Control bit for flushing the registers after branch
    input  logic pipe_en,            // Control bit for enabling the registers
    input  logic mem_rdy,            // from IMEM for req/rdy protocol
    input  logic valid,              // from IMEM for req/rdy protocol
    input  logic pc_en,              // control bit from CU
    input  logic [bits-1:0] jpc,     // branch/jump pc
    input  logic [bits-1:0] rdata,   // from IMEM for req/rdy protocol
    output logic proc_req,           // to IMEM for req/rdy protocol
    output logic stall,              // to CU for stalling the pipeline
    output logic [bits-1:0] pc,      // to IF/ID 
    output logic [bits-1:0] pc2mem,  // to IMEM for req/rdy protocol
    output logic [bits-1:0] npc,     // to IF/ID 
    output logic [bits-1:0] ir       // to decode unit
);

localparam [31:0] nop = 32'h00000013; // nop instruction
logic [bits-1:0] npc_loc, pc_loc_i, pc_loc_o, ir_loc_i, ir_loc_o;


/* Hazard detection and instruction memory not ready */
assign pc_en_loc = hazard & pc_en;


MUX21_GENERIC #(bits) pc_src(
    .A(jpc),
    .B(npc_loc),
    .S(brjmp_ctrl),
    .Y(pc_loc_i)
);

register_generic #(bits) pc_register(
    .data_in(pc_loc_i),
    .CK(clk),
    .RESET(rst),
    .ENABLE(pc_en_loc),
    .data_out(pc_loc_o)
);

adder #(bits) add(
    .PC(pc_loc_o),
    .NPC(npc_loc)
);

fetcher #(bits) fetcher(
    .clk(clk),
    .rst(rst),
    .mem_rdy(mem_rdy),
    .valid(valid),
    .pc_en(pc_en),
    .addr_in(pc_loc_o),
    .rdata(rdata),
    .addr_out(pc2mem),
    .instr_out(ir_loc_i),
    .stall(stall),
    .proc_req(proc_req)
);

MUX21_GENERIC #(bits) ir_src(
    .A(nop),
    .B(ir_loc_i),
    .S(stall),
    .Y(ir_loc_o)
);

/********************************************
* Pipeline registers
********************************************/

register_generic #(bits) npc(
    .data_in(npc_loc),
    .CK(clk),
    .RESET(rst),
    .ENABLE(pipe_en),
    .data_out(npc)
);

register_generic #(bits) pc(
    .data_in(pc_loc_o),
    .CK(clk),
    .RESET(rst),
    .ENABLE(pipe_en),
    .data_out(pc)
);

register_generic #(bits) nIR(
    .data_in(ir_loc_i),
    .CK(clk),
    .RESET(rst),
    .ENABLE(pipe_en),
    .data_out(ir)
);

endmodule
