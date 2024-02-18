module memory #(parameter N = 32) (
    input logic clk,
    input logic rst,
    input logic[6:0] cwMEM,
    input logic pipe_en,
    input logic mem_ready,          //from memory
    input logic valid,              //from memory
    input logic[N-1:0] rdata,       //from memory
    input logic[6:0] cwMEM,
    input logic[N-1:0] wrData_in,       
    input logic [N-1:0] ALUres,
    input logic [N-1:0] NPCin,        //PC+4
    input logic [N-1:0] IMMin,
    input logic [4:0] Rdest_in,
    output logic we_out,
    output logic proc_req,
    output logic[31:0] addr,
    output logic[N-1:0] wdata,
    output logic [N-1:0] ALUout,
    output logic [N-1:0] NPCout,
    output logic [N-1:0] IMMout,
    output logic [4:0] Rdest_out,
    output logic [2:0] cwWB,
    output logic stallMem
);

    logic we_in;
    logic req;

    logic[N-1:0] loadData;
    logic[4:0] loadDest;
    
    assign memWrite = cwMEM[6];
    assign memRead = cwMEM[5];
    assign loadReq = cwMEM[4];
    assign storeReq = cwMEM[3];

    always_comb
    begin
        we_in = memWrite | (!memRead);
        req = loadReq | storeReq;
    end



    loadStore #(32, N) Load_Store_unit (
        .clk(clk),
        .rst(rst),
        .wrAddr(Rdest_in),       //load R dest
        .req(req),
        .ADDR_IN(ALUres),
        .we_in(we_in),
        .WRITE_DATA(wrData_in),
        .mem_rdy(mem_ready),         
        .valid(valid),
        .rdata(rdata),
        .proc_req(proc_req),
        .we(we_out),
        .addr(addr),
        .wdata(wdata),
        .loadData(loadData),
        .loadDest(loadDest),
       .stall(stallMem)
    );
    
    
    //pipeline registers
    register_generic #(N) ALU_reg_MEMWB (
        .data_in(ALUres),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(ALUout)
    );
    
    register_generic #(N) NPC_reg_MEMWB (
        .data_in(NPCin),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(NPCout)
    );
    
    register_generic #(N) Imm_reg_MEMWB (
        .data_in(IMMin),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(IMMout)
    );


    register_generic #(5) Dest_reg_MEMWB (
        .data_in(Rdest_in),
        .CK(clk),
        .RESET(rst),
        .ENABLE(pipe_en),
        .data_out(Rdest_out)    
    );
                
 endmodule
