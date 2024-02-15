module tb_fetcher;

    // Parameters
    parameter bits = 32;

    // Inputs
    logic clk = 0;
    logic rst = 0;
    logic [bits-1:0] ADDR_IN;
    logic mem_rdy = 1;
    logic valid = 1;
    logic [bits-1:0] RDATA;
    logic [bits-1:0] RDATAtmp;

    // Outputs
    logic proc_req, we, PC_en;
    logic [bits-1:0] ADDR_OUT, INSTR_OUT;

    fakemem dut1 (
        .ADDR_IN(ADDR_OUT),
        .RDATA(RDATAtmp)
    );


    // Instantiate the module
    fetcherfsm #(bits) dut (
        .clk(clk),
        .rst(rst),
        .ADDR_IN(ADDR_IN),
        .mem_rdy(mem_rdy),
        .valid(valid),
        .RDATA(RDATAtmp),
        .proc_req(proc_req),
        .we(we),
        .ADDR_OUT(ADDR_OUT),
        .INSTR_OUT(INSTR_OUT),
        .PC_en(PC_en)
    );

    // Clock generation
    always #(5) clk = ~clk; // Clock period is 5 time units

    // Test stimulus
    initial begin
        // Reset
        rst = 1;
        ADDR_IN = 0;
        //RDATA = 32'h1fc18197;
        #10;
        rst = 0;
        #10;
        rst = 1;
        #5;
        ADDR_IN = 1;
        //RDATA = 32'h00000001;
        #10;
        ADDR_IN = 2;
        //RDATA = 32'h00000002;
        #10;
        ADDR_IN = 3;
        //RDATA = 32'h70000003;
        #10;
        ADDR_IN = 4;
        //RDATA = 32'h00000004;
        #10;
        ADDR_IN = 5;
        //RDATA = 32'h00000005;
        //#10;
        //ADDR_IN = 20;
        ////RDATA = 32'h00000006;
        //#10;
        //ADDR_IN = 24;
        ////RDATA = 32'h00000007;
        //#10;

        #100; // Allow some time for the simulation to finish
        $finish;
    end

endmodule