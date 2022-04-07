// instruction addresses start at 0x00400000
`define I_START_ADDRESS 32'h00400000

// ALU op-codes
`define ALU_AND 4'b0000
`define ALU_OR  4'b0001
`define ALU_XOR 4'b0010
`define ALU_NOR 4'b0011
`define ALU_ADD 4'b0101
`define ALU_SUB 4'b0110
`define ALU_SLT 4'b0111
`define ALU_SRL 4'b1000
`define ALU_SLL 4'b1001
`define ALU_SRA 4'b1010

// R-Type funct
`define F_AND 6'b100100 // rd = rs & rt
`define F_OR  6'b100101 // rd = rs | rt
`define F_XOR 6'b100110 // rd = rs ^ rt
`define F_NOR 6'b100111 // rd = ~(rs | rt)
`define F_SLL 6'b000000 // rd = rt << sa
`define F_SRL 6'b000010 // rd = rt >> sa (logical)
`define F_SRA 6'b000011 // rd = rt >> sa
`define F_SLT 6'b101010 // rd = rs < rt
`define F_ADD 6'b100000 // rd = rs + rt
`define F_SUB 6'b100010 // rd = rs - rt
`define F_JR  6'b001000 // pc = rs

// I-Type op-code
`define OP_ANDI 6'b001100 // rt = rs & imm
`define OP_ORI  6'b001101 // rt = rs | imm
`define OP_XORI 6'b001110 // rt = rs ^ imm
`define OP_SLTI 6'b001010 // rt = rs < imm
`define OP_ADDI 6'b001000 // rt = rs + imm
`define OP_BEQ  6'b000100 // if rs == rt then branch to offset
`define OP_BNE  6'b000101 // if rs != rt then branch to offset
`define OP_LW   6'b100011 // rt = mem[rs + offset]
`define OP_SW   6'b101011 // mem[rs + offset] = rt

// J-Type op-code
`define OP_J   6'b000010 // pc = addr
`define OP_JAL 6'b000011 // reg[31] = pc + 8, pc = addr

`define OP_RTYPE 6'b000000 // R-Type instruction
