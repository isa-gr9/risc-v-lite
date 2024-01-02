module REGISTER_FILE #(parameter NBITS = 32, NREGISTERS = 32) (
  input logic CLK,
  input logic RESET,
  input logic ENABLE,
  input logic RD1,
  input logic RD2,
  input logic WR,
  input logic [4:0] ADD_WR,
  input logic [4:0] ADD_RD1,
  input logic [4:0] ADD_RD2,
  input logic [NBITS-1:0] DATAIN,
  output logic [NBITS-1:0] OUT1,
  output logic [NBITS-1:0] OUT2
);

  // Define the register array
  logic [NBITS-1:0] REGISTERS [0:NREGISTERS-1];
  logic [NBITS-1:0] tmp_out1;
  logic [NBITS-1:0] tmp_out2;

  always @(posedge CLK) begin
    if (RESET) begin
      for (int i = 0; i < NREGISTERS; i++) begin
        REGISTERS[i] <= 0;
      end
      tmp_out1 = 0;
      tmp_out2 = 0;
    end else begin
      if (ENABLE) begin
        if (RD1) begin
          tmp_out1 = REGISTERS[ADD_RD1];
        end else begin
          tmp_out1 = 0;
        end

        if (RD2) begin
          tmp_out2 = REGISTERS[ADD_RD2];
        end else begin
          tmp_out2 = 0;
        end

        if (WR) begin
          REGISTERS[ADD_WR] = DATAIN;
        end
      end
    end
  end

  assign OUT1 = tmp_out1;
  assign OUT2 = tmp_out2;

endmodule
