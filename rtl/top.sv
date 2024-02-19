module top #(
    parameter NBITS = 32
) (
    logic input 
);
    
    datapath #(NBITS) datap_inst (
        .clk(),
        .rst(),
        .pc_en(),
        .cw(),				 // from control unit
        .aluOp(),			 // from contorl unit
        .mem_data(),         // from data memory
        .IFID_enable(),      //from hazard detection unit
        .muxControl(),       //from hazard detection unit
        .instr(),			 // to instruction memory
        .mem_addr(),		 // to data memory
        .stall() 			 // to CU
    );


    cu cu_inst (
        .instr(),
        .stall(),
        .pc_en(),
        .cw(),
        .aluOp()
    );

endmodule