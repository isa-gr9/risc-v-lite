module SIGN_EXT #(parameter int bits = 16) (
  input logic [bits-1:0] inputt,
  output logic [2*bits-1:0] outputt
);

  always_comb begin
    // Check the MSB of the 16 bit input
    if (inputt[bits-1]) begin
      // If MSB is '1', fill the upper 16 bits of the output with '1's
      outputt = {16'hFFFF, inputt};
    end else begin
      // If MSB is '0', fill the upper 16 bits of the output with '0's
      outputt = {16'h0000, inputt};
    end
  end

endmodule

