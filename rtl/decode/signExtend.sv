module SIGN_EXT #(parameter int bits = 32) (
  input logic [bits-1:0] inputt,
  output logic [2*bits-1:0] outputt
);

  always_comb begin
    // Check the MSB of the 32 bit input
    if (inputt[bits-1] == 1'b1) begin
      // If MSB is '1', fill the upper 32 bits of the output with '1's
      outputt = {32'hFFFFFFFF, inputt};
    end else begin
      // If MSB is '0', fill the upper 32 bits of the output with '0's
      outputt = {32'h00000000, inputt};
    end
  end

endmodule

