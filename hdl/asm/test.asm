nor $t1, $0, $0  # t1 = -1
sub $t2, $0, $t1 # t2 = 1
add $t3, $t2, $t2 # t3 = 2
sll $t4, $t3, 4 # t4 = 32
sra $t5, $t4, 2 # t5 = 8
slt $t6, $t5, $t3 # t6 = 0
xor $t7, $t1, $t2 # t7 = -2
or $t0, $t1, $t2 # t0 = -1
and $t7, $t1, $t2 # t7 = 1
srl $t5, $t4, 3 # t5 = 4
addi $t5, $t5, -1 # t6 = 3
andi $t5, $t5, 1 # t5 = 1
xori $t4, $t4, 1 # t4 = 33
ori $t4, $t4, 34 # t4 = 35
slti $t8, $t4, 35 # t8 = 0