addi $t0, $0, 2 # t0 = 2
addi $t1, $0, 4 # t1 = 4
bne $t0, $t1, FIRST
addi $t0, $t0, 4
FIRST: addi $t0, $t0, 2
beq $t0, $t1, SECOND
addi $t0, $t0, 4
SECOND: addi $t0, $t0, 0