/*

MAGAGNA:

- FLUSH DELLA PIPELINE DA DOVE ARRIVA?

*/







module datapath #(parameter nbits = 32) (
	input logic clk,
	input logic rst,
	input logic pc_en,
    input logic pipe_en,
	input logic [14:0] cw,				// from control unit
	input logic [3:0] aluOp,			// from contorl unit
	input logic [nbits-1:0] mem_data,   // from data memory
    input logic [nbits-1:0] i_data,     // from instruction memory
  	output logic [nbits-1:0] pc2mem,			// to instruction memory
	output logic [nbits-1:0] mem_addr,		// to data memory
    output logic [nbits-1:0] ir2cu,
	output logic stall, 						// to CU
    output logic memStall,
    output logic [nbits-1:0] op2mem,
    output logic we_out
);

logic muxsel_jmp; // from write back stage
logic Imem_rdy, Ivalid, Iproc_req; // from/to instr mem
//logic pc_en;
logic [nbits-1:0] jpc; 		// branch target PC
logic [nbits-1:0] pcFetch, pcDecode; 	// to decode stage
logic [nbits-1:0] npcFetch, npcDecode, npcExe, npcMem; 	// to decode stage
logic [nbits-1:0] irFetch; 	// to decode stage
//logic [nbits-1:0] pc2mem; 	// to instruction memory
logic IFID_enable;		//	from Hazard Detection unit
logic flush;		//	= Branch taken, from MEM stage
logic datain;		// from data memory to register file
logic hazard;		// from hazard MUX
logic [nbits-1:0] r1,r2; 	// read from register file
logic [nbits-1:0] rdestExe, rdestMem, rdestWb; 	// read from register file
logic [nbits-1:0] immDecode, immExe, immMem; 	// immediate from decode stage
logic [nbits-1:0] aluresExe, aluresMem; 	// immediate from decode stage
logic pc_selExe;


logic [1:0] fwdA, fwdB;


logic [14:0] cw_tmp;
logic [14:0] nop_cw;
logic [12:0] cw_exe;
logic [3:0] aluop_tmp;
logic [3:0] aluop_exe;
logic [6:0] cw_mem;
logic [2:0] cw_wb;


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
    .flush(pc_selExe),
    .pipe_en(pipe_en),            
    .mem_rdy(Imem_rdy),            
    .valid(Ivalid),              
    .pc_en(pc_en),   // the last bit of the control word is the enable of the pc              
    .jpc(jpc),     
    .rdata(i_data),   
    .proc_req(Iproc_req),           
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
  .addWrIn(rdestWb),
  .pipe_en(pipe_en),
  .wr_en(cw_wb),
  .ir_in(irFetch),
  .npc_in(npcFetch),
  .pc_in(pcFetch),
  .datain(datain),
  .flush(pc_selExe),
  .hazflush(hazard),
  .r1(r1),
  .r2(r2),
  .imm_out(immDecode),
  .npc_out(npcDecode),
  .pc_out(pcDecode),
  .cw_exe(cw_exe),
  .aluop_exe(aluop_exe),
  .Rdestination(rdestDecode)
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
    .forwardA(fwdA),       //from forwarding unit
    .forwardB(fwdB),
    .aluRes_fwd(aluresExe_i),    // 
    .muxOut_fwd(datain),
    .jPC(jpc),
    .ALUres(aluresExe),
    .Bout(op2mem),
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
    .mem_ready(Dmem_ready),          //from memory
    .valid(Dvalid),              //from memory
    .rdata(Data),       //from memory
    .wrData_in(op2mem),       
    .ALUres(aluresExe),
    .NPCin(npcExe),        //PC+4
    .IMMin(immExe),
    .Rdest_in(rdestExe),
    .we_out(we_out),
    .proc_req(Dproc_req),
    .addr(alures),
    .wdata(op2mem),
    .ALUout(aluresMem),
    .NPCout(npcMem),
    .IMMout(immMem),
    .Rdest_out(rdestMem),
    .cwWB(cw_wb),
    .stallMem(memStall)
);


wb #(nbits) WB (
    .mem2reg(cw_wb[2:1]),      // from CU
    .regWrite(cw_wb[0]),     // from CU
    .ALUres(aluresMem),       // from memstage
    .MEMread(dataMem),      // Data read from memory
    .NPCin(npcMem),        // from MEM/WB reg
    .regDest_in(rdestMem),   // from MEM/WB Register destination
    .data_out(datain),
    .regDest_out(rdestWb)  // to RF register destination
);


fwu FWDUNIT(
    .src1(r1),
    .src2(r2),
    .EXMEM_dest(rdestExe),
    .MEMWB_dest(rdestMem),
    .ForwardA(fwdA),
    .ForwardB(fwdB)
);

hdu HZRDUNIT(
    .src1(r1),      //source register 1, taken from the output of the reg_generator block (in the DECODE stage)
    .src2(r2),      //source register 2, taken from the output of the reg_generator block (in the DECODE stage)
    .IDEXdest(rdestDecode),  //destination register of the previous instruction, to be taken from the destReg ID/EX pipeline registers (register to be added in the repo version. Any updates?)
    .loadIns(cw_exe[4]),         //from the CU, 1 if the instruction is a load
    .IFID_enable(IFID_enable),    //ENABLE signal for IFID pipeline registers and for the PROGRAM COUNTER register (all this registers are in the fetch stage). This has bo be ANDed with the CU signal "fetch_en". It goes to zero if hazard detected, so the regs are not updated
    .muxControl(hazard)     //to select a 0 control word in the multiplexer, to instert a stall 
);




endmodule