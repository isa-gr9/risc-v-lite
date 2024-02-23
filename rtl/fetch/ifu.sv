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
    output logic [bits-1:0] ir      // to decode unit
);

localparam [31:0] nop = 32'h00001F13; // nop instruction
logic [bits-1:0] npc_loc, pc_loc_i, pc_loc_o, ir_loc_i, ir_loc_o;
logic rst_logic;
logic prev_valid;

/* Hazard detection and instruction memory not ready */
assign pc_en_loc = brjmp_ctrl | (hazard & pc_en);

assign rst_logic = rst & flush;


MUX21_GENERIC #(bits) pc_src(
    .A(jpc),
    .B(npc_loc),
    .S(brjmp_ctrl),
    .Y(pc_loc_i)
);

// register_generic_pc #(bits) pc_register(
//     .data_in(pc_loc_i),
//     .CK(clk),
//     .RESET(rst),
//     .brjmp(brjmp_ctrl),
//     .ENABLE(pc_en_loc),
//     .data_out(pc_loc_o)
// );

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
    .brjmp_ctrl(brjmp_ctrl),
    .ir(ir_loc_i),
    .stall(stall),
    .proc_req(proc_req)
);

    // always_ff @(posedge clk or negedge rst) begin : prevValid
    //      if (!rst) begin
    //          prev_valid <= 1'b0;  // Initialize to some default value
    //      end else begin
    //          prev_valid <= valid;
    //      end
    //  end

// MUX21_GENERIC #(bits) ir_src(
//     .A(ir_loc_i),
//     .B(nop),
//     .S(prev_valid),
//     .Y(ir_loc_o)
// );

/********************************************
* Pipeline registers
********************************************/

register_generic #(bits) npc_pipereg(
    .data_in(npc_loc),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en),
    .data_out(npc)
);

register_generic #(bits) pc_pipereg(
    .data_in(pc_loc_o),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en),
    .data_out(pc)
);

register_generic #(bits) nIR_pipereg(
    .data_in(ir_loc_i),
    .CK(clk),
    .RESET(rst_logic),
    .ENABLE(pipe_en),
    .data_out(ir)
);


endmodule
