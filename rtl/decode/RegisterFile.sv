module REGISTER_FILE #(parameter NBITS = 32, NREGISTERS = 32) (
  input logic clk,
  input logic rst,
  input logic rd1_en,
  input logic rd2_en,
  input logic wr_en,
  input logic [4:0] add_wr,
  input logic [4:0] add_rd1,
  input logic [4:0] add_rd2,
  input logic [NBITS-1:0] datain,
  output logic [NBITS-1:0] out1,
  output logic [NBITS-1:0] out2
);

  // Define the register array
  logic [NBITS-1:0] registers [0:NREGISTERS-1];




  always_comb begin
    if (rst) begin
      for (int i = 0; i < NREGISTERS; i++) begin
        registers[i] <= 0;
      end
      out1 = 0;
      out2 = 0;
    end else begin
    if (clk || !clk) begin 
        if (rd1_en) begin
          out1 = registers[add_rd1];
        end else begin
          out1 = 0;
        end

        if (rd2_en) begin
          out2 = registers[add_rd2];
        end else begin
          out2 = 0;
        end

        if (wr_en) begin
          registers[add_wr] = datain;
        end
      end
    end
  end

endmodule
