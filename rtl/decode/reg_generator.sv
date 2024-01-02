module register_generator #(parameter int nbits=32) (
    input logic [nbits-1:0] IR_IN,
    output logic [4:0] RS1,
    output logic [4:0] RS2,
    output logic [4:0] RD, 
    output logic [nbits-1:0] IMM
);

logic [6:0] OPCODE;
logic [11:0] IMM12;
logic [19:0] IMM20;
logic J;

always_comb begin
    OPCODE = IR_IN[6:0]; // For each kind of instruction the first 7 bits are the opcode

    
    case (OPCODE)
        7'b11: begin // LOAD
            RS1 = IR_IN[19:15];
            RD = IR_IN[11:7];
            IMM12 = IR_IN[31:20];
            J = 1'b0;
        end
        7'b10011: begin // I-Type
            RS1 = IR_IN[19:15];
            RD = IR_IN[11:7];
            IMM12 = IR_IN[31:20];
        end
        7'b10111: begin // AUIPC
            IMM = {IR_IN[31:12], 12'b0};
        end
        7'b100011: begin // STORE
            RS1 = IR_IN[19:15];
            RS2 = IR_IN[24:20];
            IMM12 = {IR_IN[31:25], IR_IN[11:7]};
            J = 1'b0;
        end
        7'b110011: begin // R-Type
            RS1 = IR_IN[19:15];
            RS2 = IR_IN[24:20];
            RD = IR_IN[11:7];
        end
        7'b110111: begin // LUI
            RD = IR_IN[11:7];
            IMM = {IR_IN[31:12], 12'b0};
        end
        7'b1100011: begin // BRANCH
            RS1 = IR_IN[19:15];
            RS2 = IR_IN[24:20];
            IMM12 = {IR_IN[31], IR_IN[7], IR_IN[30:25], IR_IN[11:8]};
            J = 1'b0;
        end
        7'b1101111: begin // JUMP
            RD = IR_IN[11:7];
            IMM20 = {IR_IN[31], IR_IN[19:12], IR_IN[20], IR_IN[30:21]};
            J = 1'b1;
        end
        default: begin
            // Handle default case if needed
            J = 1'b0; // Set a default value for J
        end
    endcase

    //IMMEDIATE SIGN EXTEND
    if (J == 1) begin //20 bits
      if (IMM20[19] == 1'b1) begin
        IMM = {12'hFFF, IMM20};
      end else begin
        IMM = {12'h000, IMM20};
      end
    end else begin //12 bits
        if (IMM12[11] == 1'b1) begin
        IMM = {20'hFFFFF, IMM12};
      end else begin
        IMM = {20'h00000, IMM12};
      end
  end

end
endmodule
