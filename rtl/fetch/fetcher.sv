module Fetcher #(parameter bits = 32) (
    input logic clk,     // Clock signal
    input logic reset_n, // Active low reset signal
    input logic [bits-1:0] PC,
    input logic mem_ready,
    input logic valid,
    input logic [bits-1:0] Rdata,
    output logic proc_req,
    output logic [bits-1:0] Add,
    output logic [bits-1:0] Data
);

// Reset logic
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        proc_req <= 1'b0;
    else
        proc_req <= 1'b1;
end

// Capture the PC and set proc_req high when a new PC is received
always_ff @(posedge clk) begin
    if (proc_req) begin // Only update when proc_req is high
        Add <= PC;
    end
end

// Capture Rdata when both mem_ready and valid are high
always_ff @(posedge clk) begin
    if (mem_ready && valid) begin
        Data <= Rdata;
    end
end

endmodule
