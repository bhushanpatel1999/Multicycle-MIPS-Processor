# Multicycle-MIPS-Processor
Building a full-scale MIPS-ISA multicycle processor with a datapath, control unit, and memory.

## Description

This is a SystemVerilog-based multicycle processor with registers, coded in Vivado. The processor follows the MIPS ISA (Instruction Set Architecture) found here: https://www.cs.cmu.edu/afs/cs/academic/class/15740-f97/public/doc/mips-isa.pdf. The processor implements the following commands:

| R-types | I-types | J-types |
| :------ | :------ | :------ |
| `and`   | `andi`  | `j`     |
| `or`    | `ori`   | `jal`   |
| `xor`   | `xori`  | `jr`    |
| `nor`   | `slti`  |         |
| `sll`   | `addi`  |         |
| `srl`   | `beq`   |         |
| `sra`   | `bne`   |         |
| `slt`   | `lw`    |         |
| `add`   | `sw`    |         |
| `sub`   |         |         |
| `nop`   |         |         |

The processor is composed of the 3 parts: memory, datapath, and control. The memory is where instructions assembled from a test file are stored. The datapath is the physical connections between the memory, circuit components, the control FSM. The control unit is an FSM that controls the flow of logic along the datapath, which varies with each command. 

## Getting Started

### Dependencies

* Vivado HLS 2019.1 or above

### Installing

* Download all files into a local directory

### Executing program

* Using the terminal, cd into that directory
* Run 
```
./tcl.sh make
```
* Run 
```
./tcl.sh open
```
NOTE: This will take some time as Vivado is opened and the project is loaded.

* Before running the processor, we must provide a list of commands in the MIPS ISA format for the processor to execute. Navigate to /hdl/asm/ and write instructions inside test.asm. An example command using the MIPS register naming convention:
```
nor $t1, $0, $0
```
* After providing commands, we must use an assembler to turn this into hexadecimal code that is machine-readable. In the same directory as test.asm, run
```
./assemble.sh test.asm
```
This will assemble the code into the instr.mem file. 
* Navigate back to the open Vivado screen. On the left sidebar, click "Run Simulation" and wait for the waveform diagram to show up.
* If successful, you should see the result of each instruction in the w_data[31:0] wire under the corresponding clock cycle. 

## Authors
* Bhushan Patel
* Ben Neal

## Acknowledgments
* COMPSCI 141: Computing Hardware staff
