module fakemem_tb;

    // Inputs
    logic [31:0] ADDR_IN;
    // Outputs
    logic [31:0] RDATA;

    // Instantiate the module
    fakemem dut (
        .ADDR_IN(ADDR_IN),
        .RDATA(RDATA)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        ADDR_IN = 0;

        // Test case
        repeat (6) begin
            #5; // Wait one time unit
            $display("ADDR_IN = %d, RDATA = %h", ADDR_IN, RDATA);
            assert(RDATA == ADDR_IN + 1) // Check if RDATA is correct
                else $error("Error: Incorrect RDATA value at ADDR_IN = %d", ADDR_IN);
            ADDR_IN = ADDR_IN + 1; // Increment ADDR_IN
        end

        #1; // Wait one more time unit
        $finish; // Finish the simulation
    end

endmodule