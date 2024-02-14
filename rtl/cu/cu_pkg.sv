package cu_pkg

    typedef enum 
    {  
        LW          = 7'b0000011,
        SW          = 7'b0100011,
        RTYPE       = 7'b0110011,
        BEQ         = 7'b,
        ADDI        = 7'b0010011,
        AUIPC       = 7'b0010111,
        LUI         = 7'b0110111,
        BRANCH      = 7'b1100011,
        JTYPE       = 7'b1101111,
        RET         = 7'b,
    } op_t;


/*
func3 beq : 000
func3 bne : 001
func3 ble : 101
func3 bltu: 110
func3 bgeu: 111


nobranch: 000
beq: 001
bne: 010
ble: 011
bltu: 100
bgeu: 101

*/
endpackage