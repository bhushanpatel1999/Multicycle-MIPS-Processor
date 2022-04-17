addi $t5, $0, -1 # t5 = -1
andi $t5, $t5, 1 # t5 = 1
xori $t5, $t5, 1 # t5 = 1
ori $t5, $t5, 34 # t5 = 35
slti $t5, $t5, 35 # t5 = 0