module hdu(
    input logic [4:0] src1,      //source register 1, taken from the output of the reg_generator block (in the DECODE stage)
    input logic [4:0] src2,      //source register 2, taken from the output of the reg_generator block (in the DECODE stage)
    input logic [4:0] IDEXdest,  //destination register of the previous instruction, to be taken from the destReg ID/EX pipeline registers (register to be added in the repo version. Any updates?)
    input logic loadIns,         //from the CU, 1 if the instruction is a load
    output logic IFID_enable,    //ENABLE signal for IFID pipeline registers and for the PROGRAM COUNTER register (all this registers are in the fetch stage). This has bo be ANDed with the CU signal "fetch_en". It goes to zero if hazard detected, so the regs are not updated
    output logic muxControl      //to select a 0 control word in the multiplexer, to instert a stall
);


    always_comb begin
        if (((IDEXdest == src1) || (IDEXdest == src2)) && (loadIns == 1'b1)) begin
                muxControl = 1'b0;     //stall needed, select 0 as a control word for next stages
                IFID_enable = 1'b0;    //IF/ID pipeline registers disabled, they have to keep the current values
        end else begin 
                muxControl = 1'b1;
                IFID_enable = 1'b1;
        end
    end

endmodule
