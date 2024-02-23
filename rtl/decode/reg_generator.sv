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
logic [31:0] IMM32;
logic [1:0] S;  // Sign extend bits depending on the instruction
                // S = 00 -> No sign extend
                // S = 01 -> Sign extend 12 bits
                // S = 10 -> Sign extend 20 bits
				// S = 11 -> Sign extension for JAL immediates (they need to be shifted by4)

always_comb begin
    OPCODE = IR_IN[6:0]; // For each kind of instruction the first 7 bits are the opcode

    
    case (OPCODE)
        7'b0000011: begin // LOAD
            RS1 = IR_IN[19:15];
            RS2 = 5'd0;
            RD = IR_IN[11:7];
            IMM12 = IR_IN[31:20];
            S = 2'b01;
        end
        7'b0010011: begin // I-Type
            RS1 = IR_IN[19:15];
            RS2 = 5'd0;
            RD = IR_IN[11:7];
            IMM12 = IR_IN[31:20];
            S = 2'b01;
        end
        7'b0010111: begin // AUIPC
            IMM32 = {IR_IN[31:12], 12'b0};
            RS1 = 5'd0;
            RS2 = 5'd0;
            RD = IR_IN[11:7];
            S = 2'b00;
        end
        7'b0100011: begin // STORE
            RS1 = IR_IN[19:15];
            RS2 = IR_IN[24:20];
            IMM12 = {IR_IN[31:25], IR_IN[11:7]};
            S = 2'b01;
        end
        7'b0110011: begin // R-Type
            RS1 = IR_IN[19:15];
            RS2 = IR_IN[24:20];
            RD = IR_IN[11:7];
            S = 2'b00;
        end
        7'b0110111: begin // LUI
            RS1 = 5'd0;
            RS2 = 5'd0;
            RD = IR_IN[11:7];
            IMM32 = {IR_IN[31:12], 12'b0};
            S = 2'b00;
        end
        7'b1100011: begin // BRANCH
            RS1 = IR_IN[19:15];
            RS2 = IR_IN[24:20];
            IMM12 = {IR_IN[31], IR_IN[7], IR_IN[30:25], IR_IN[11:8]};
            S = 2'b01;
        end
        7'b1101111: begin // JUMP
            RS1 = 5'd0;
            RS2 = 5'd0;
            RD = IR_IN[11:7];
            IMM20 = {IR_IN[31], IR_IN[19:12], IR_IN[20], IR_IN[30:21]};
            S = 2'b10;
        end
        default: begin
            // Handle default case if needed
            S = 2'b00; // Set a default value for J
        end
    endcase

    //IMMEDIATE SIGN EXTEND
    case (S)
        2'b10: begin //20 bits
            if (IMM20[19] == 1'b1) begin
                IMM = {12'hFFF, IMM20};
            end else begin
                IMM = {12'h000, IMM20};
            end
        end
        2'b01: begin //12 bits
            if (IMM12[11] == 1'b1) begin
                IMM = {20'hFFFFF, IMM12};
            end else begin
                IMM = {20'h00000, IMM12};
            end
        end
        // 2'b11: begin // jal case, immediate shifted by 4
        // 	 if (IMM20[19] == 1'b1) begin
        //         IMM = {11'h7FF, IMM20, 1'b0};
        //     end else begin 
        //         IMM = {11'h000, IMM20, 1'b0};
        //     end
        // end
        default: begin
            IMM = IMM32;
        end
    endcase
end
endmodule
