j FIRST
addi $t0, $0, 2
FIRST: addi $t0, $0, 1 # t0 = 1
jal SECOND
sw $ra 32($0)
addi $t0, $t0, 3
SECOND: addi $t0, $t0, 2
jr $ra
addi $t0, $t0, 2
