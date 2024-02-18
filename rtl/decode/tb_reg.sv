module tb_reg;

  // Parameters
  localparam int NBITS = 32;
  localparam int NREGISTERS = 32;

  // Inputs
  logic clk;
  logic rst;
  logic enable;
  logic rd1;
  logic rd2;
  logic wr;
  logic [4:0] add_wr;
  logic [4:0] add_rd1;
  logic [4:0] add_rd2;
  logic [NBITS-1:0] datain;

  // Outputs
  logic [NBITS-1:0] out1;
  logic [NBITS-1:0] out2;

  // Instantiate the module under test
  REGISTER_FILE #(
    .nbits(NBITS),
    .nregisters(NREGISTERS)
  ) dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .rd1(rd1),
    .rd2(rd2),
    .wr(wr),
    .add_wr(add_wr),
    .add_rd1(add_rd1),
    .add_rd2(add_rd2),
    .datain(datain),
    .out1(out1),
    .out2(out2)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle the clock every 5 time units
  end

  // Test sequence
  initial begin
    // Initialize inputs
    rst = 0;
    enable = 1'b1;
    rd1 = 1'b0;
    rd2 = 1'b0;
    wr = 1'b0;
    add_wr = 5'b00000;
    add_rd1 = 5'b00000;
    add_rd2 = 5'b00000;
    datain = 32'h00000000;

    // Apply values to the first two registers
    #10;
    wr = 1'b1;
    add_wr = 5'b00000;
    datain = 32'h12345678; // Value for the first register
    #10;
    wr = 1'b1;
    add_wr = 5'b00001;
    datain = 32'h87654321; // Value for the second register

    // Apply reset
    #10;
    rst = 1'b1;
    #10;
    rst = 1'b0;

    // Add delay for observation
    #50;

    // End simulation
    $finish;
  end

endmodule