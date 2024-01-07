// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns


module tb_fetch;
    parameter nbits=32;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic j;
    logic mem_ready;
    logic valid;
    logic [nbits-1:0] Rdata; 
    logic [nbits-1:0] jPC;
    logic proc_req;
    logic [nbits-1:0] Add;
    logic [nbits-1:0] NPC;
    logic [nbits-1:0] PC;
    logic [nbits-1:0] IR;
    
    fetch_unit Du(.clk(clk), .rst(rst), .j(j), .mem_ready(mem_ready), .valid(valid), .Rdata(Rdata), .jPC(jPC), .proc_req(proc_req), .Add(Add), .NPC(NPC), .PC(PC), .IR(IR));

// Create a clock generator
always #5 clk = ~clk;
initial begin
    #5 rst = 1'b0;  // After 5 time units, set rst to 0
end


initial begin

    j=1'b0;
    mem_ready=1'b1;
    jPC=32'h01000101; //INVENTED
    repeat(1) @(posedge clk);
    valid=1'b1;
    Rdata=32'h00e5d463; //INVENTED

    repeat(3) @(posedge clk);
    valid=1'b0;
    j=1'b0;
    mem_ready=1'b0;
    jPC=32'h01000100; //INVENTED
    repeat(2) @(posedge clk);
    mem_ready=1'b1;
    repeat(1) @(posedge clk);
    j=1'b1; // new instruction arrived while the previous is still running
    mem_ready=1'b0;
    jPC=32'h01001100; //INVENTED
    repeat(1) @(posedge clk);
    valid=1'b1;
    Rdata=32'h00e5ef32; //INVENTED
    mem_ready=1'b1;
    repeat(1) @(posedge clk);
    valid=1'b1;
    Rdata=32'h00e5d245; //INVENTED

end
endmodule




