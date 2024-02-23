module datapath #(parameter nbits = 32) (
    input logic clk,
    input logic rst,
    input logic pc_en,
    input logic pipe_en,
    input logic [14:0] cw,				// from control unit
    input logic [3:0] aluOp,            // from contorl unit
    input logic imem_rdy,
    input logic dmem_rdy,
    input logic ivalid,
    input logic dvalid,
    input logic [nbits-1:0] mem_data,   // from data memory
    input logic [nbits-1:0] idata,     // from instruction memory
    output logic [nbits-1:0] pc2mem,			// to instruction memory
    output logic [nbits-1:0] mem_addr,		// to data memory
    output logic [nbits-1:0] ir2cu,
    output logic stall, 						// to CU
    output logic memStall,
    output logic iproc_req,
    output logic dproc_req,
    output logic [nbits-1:0] wdata2mem,
    output logic we_out
);

logic muxsel_jmp; // from write back stage
logic [nbits-1:0] jpc; 		// branch target PC
logic [nbits-1:0] pcFetch, pcDecode; 	// to decode stage
logic [nbits-1:0] npcFetch, npcDecode, npcExe, npcMem; 	// to decode stage
logic [nbits-1:0] irFetch; 	// to decode stage
logic IFID_enable;  //from Hazard Detection unit
logic flush;            //	= Branch taken, from MEM stage
logic [nbits-1:0] datain;		// from data memory to register file
logic hazard;		// from hazard MUX
logic [nbits-1:0] r1,r2; 	// read from register file
logic [4:0] rdestExe, rdestMem, rdestWb; 	// read from register file
logic [nbits-1:0] immDecode, immExe, immMem; 	// immediate from decode stage
logic [nbits-1:0] aluresExe_i, aluresExe, aluresMem; 	// immediate from decode stage
logic pc_selExe;
logic [4:0] rdestDecode;

logic [1:0] fwdA, fwdB;


logic [14:0] cw_tmp;
logic [14:0] nop_cw;
logic [12:0] cw_exe;
logic [3:0] aluop_tmp;
logic [3:0] aluop_exe;
logic [6:0] cw_mem;
logic [2:0] cw_wb;
logic wr_en;            // from WB to RF
logic [nbits-1:0] loadDataWB;
logic [nbits-1:0] wrData;

logic [4:0] add_r1;  //decoded source register address
logic [4:0] add_r2;

logic load;

assign load = cw_mem[2];

assign ir2cu = irFetch;

assign nop_cw = 15'b101100000000001;


always_comb begin : hdu_cw_ctrl
    if(hazard) begin
        cw_tmp = cw;
        aluop_tmp = aluOp;
    end
    else
        cw_tmp = nop_cw;
        aluop_tmp = 4'b0001;
end


ifu #(nbits) FETCH (
    .clk(clk),
    .rst(rst),
    .brjmp_ctrl(pc_selExe),
    .hazard(IFID_enable),
    .flush(!pc_selExe),
    .pipe_en(pipe_en),
    .mem_rdy(imem_rdy),
    .valid(ivalid),
    .pc_en(pc_en),   // the last bit of the control word is the enable of the pc
    .jpc(jpc),
    .rdata(idata),
    .proc_req(iproc_req),
    .stall(stall),
    .pc(pcFetch),
    .pc2mem(pc2mem),
    .npc(npcFetch),
    .ir(irFetch) 
);

decodeUnit #(nbits,nbits) DECODE (
  .clk(clk),
  .rst(rst),
  .cw(cw_tmp),
  .aluop(aluOp),
  .addrWrIn(rdestWb),
  .pipe_en(pipe_en),
  .wr_en(wr_en), // from WB to RF
  .ir_in(irFetch),
  .npc_in(npcFetch),
  .pc_in(pcFetch),
  .datain(datain),
  .flush(!pc_selExe),
  .hazflush(hazard),
  .r1(r1),
  .r2(r2),
  .imm_out(immDecode),
  .npc_out(npcDecode),
  .pc_out(pcDecode),
  .cw_exe(cw_exe),
  .aluop_exe(aluop_exe),
  .Rdestination(rdestDecode),
  .add_r1_out(add_r1), 
  .add_r2_out(add_r2)
);


execute #(nbits) EXE (
    .clk(clk),
    .rst(rst),
    .cwEX(cw_exe),
    .aluOp(aluop_exe),
    .pipe_en(pipe_en),
    .Rdest_in(rdestDecode),
    .NPCin(pcDecode), 
    .NPC4_IN(npcDecode), 
    .NPC4_OUT(npcExe),
    .r1(r1),
    .r2(r2),
    .Imm(immDecode),
    .forwardA(fwdA),            //from forwarding unit
    .forwardB(fwdB),
    .aluRes_fwd(aluresExe_i),    // 
    .muxOut_fwd(datain),
    .jPC(jpc),
    .ALUres(aluresExe),
    .wrData(wrData),
    .ImmOUT(immExe),
    .PC_sel(pc_selExe),
    .cwMEM(cw_mem),
    .Rdest(rdestExe)
);


memory #(nbits) MEM (
    .clk(clk),
    .rst(rst),
    .cwMEM(cw_mem),
    .pipe_en(pipe_en),
    .mem_ready(dmem_rdy),          //from memory
    .valid(dvalid),              //from memory
    .rdata(mem_data),           //from memory
    .wrData_in(wrData),
    .ALUres(aluresExe),
    .NPCin(npcExe),        //PC+4
    .IMMin(immExe),
    .Rdest_in(rdestExe),
    .we_out(we_out),
    .proc_req(dproc_req),
    .addr(mem_addr),
    .wdata(wdata2mem),
    .ALUout(aluresMem),
    .NPCout(npcMem),
    .IMMout(immMem),
    .Rdest_out(rdestMem),
    .cwWB(cw_wb),
    .loadDataWB(loadDataWB),
    .stallMem(memStall)
);


wb #(nbits) WB (
    .cw_wb(cw_wb[2:0]),
    .ALUres(aluresMem),      // from memstage
    .MEMread(loadDataWB),    // Data read from memory
    .NPCin(npcMem),          // from MEM/WB reg
    .regDest_in(rdestMem),   // from MEM/WB Register destination
    .data_out(datain),
    .regDest_out(rdestWb),   // to RF register destination
    .wr_en(wr_en)            // from WB to RF
);


fwu FWDUNIT(
    .src1(add_r1),
    .src2(add_r2),
    .EXMEM_dest(rdestExe),
    .MEMWB_dest(rdestMem),
    .ForwardA(fwdA),
    .ForwardB(fwdB)
);

hdu HZRDUNIT(
    .src1(add_r1),      //source register 1, taken from the output of the reg_generator block (in the DECODE stage)
    .src2(add_r2),      //source register 2, taken from the output of the reg_generator block (in the DECODE stage)
    .IDEXdest(rdestDecode),  //destination register of the previous instruction, to be taken from the destReg ID/EX pipeline registers (register to be added in the repo version. Any updates?)
    .loadIns(cw_exe[4]),         //from the CU, 1 if the instruction is a load
    .IFID_enable(IFID_enable),    //ENABLE signal for IFID pipeline registers and for the PROGRAM COUNTER register (all this registers are in the fetch stage). This has bo be ANDed with the CU signal "fetch_en". It goes to zero if hazard detected, so the regs are not updated
    .muxControl(hazard)     //to select a 0 control word in the multiplexer, to instert a stall 
);




endmodule
