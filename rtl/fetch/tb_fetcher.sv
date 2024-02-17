module tb_fetcher;

    // Parameters
    parameter bits = 32;

    // Inputs
    logic clk = 1;
    logic rst = 1;
    logic [bits-1:0] ADDR_IN;
    logic mem_rdy = 1;
    logic valid = 1;
    logic [bits-1:0] RDATA;
    logic [bits-1:0] RDATAtmp;

    // Outputs
    logic proc_req, we, pc_en, stall;
    logic [bits-1:0] ADDR_OUT, INSTR_OUT;

 

    // Instantiate the module
    fetcher #(bits) dut (
        .clk(clk),
        .rst(rst),
        .mem_rdy(mem_rdy),
        .valid(valid),
        .pc_en(pc_en),
        .addr_in(ADDR_IN),
        .rdata(RDATA),
        .addr_out(ADDR_OUT),
        .ir(INSTR_OUT),
        .stall(stall),
        .proc_req(proc_req)
    );
    

    

    // Clock generation
    always #(5) clk = ~clk; // Clock period is 5 time units

    // Test stimulus
    initial begin
            rst = 1'b0;
            valid = 1'b0;
            #5;
            rst = 1'b1;
            pc_en = 1'b1;
            mem_rdy = 1'b0;
            #5;
            ADDR_IN = 32'hBEEFBEEF;
            pc_en = 1'b0;
            #3;
            mem_rdy = 1'b1;
            #7;
            ADDR_IN = 32'hCACCACAC;
            valid = 1'b1;
            RDATA = 32'HCAFECAFE;
            pc_en = 1'b1;
            #10;
            RDATA = 32'hfafafafa;
            #2;
            mem_rdy = 1'b0;
            #8;
            pc_en = 1'b0;
            valid = 1'b0;
            #10;
            pc_en = 1'b1;
            ADDR_IN = 32'h00000a1;
            #30
            $finish;

    end

endmodule