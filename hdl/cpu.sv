`include "cpu.svh"

module cpu
    (
        input logic clk_100M, clk_en, rst,
        input logic [31:0] r_data,
        output logic wr_en,
        output logic [31:0] mem_addr, w_data,
        // debug addr/data and instr are for showing CPU information
        // on the FPGA (only useful in synthesis)
        input logic [4:0] rdbg_addr,
        output logic [31:0] rdbg_data,
        output logic [31:0] instr
    );
    // The CPU interfaces with main memory which is enabled by the
    // inputs and outputs of this module (r_data, wr_en, mem_addr, w_data)
    // You should create the register file, flip flops, and logic implementing
    // a simple datapath so that instructions can be loaded from main memory,
    // executed, and the results can be inspected in the register file, or in
    // main memory (once lw and sw are supported). You should also create a
    // control FSM that controls the behavior of the datapath depending on the
    // instruction that is currently executing. You may want to split the CPU
    // into one or more submodules.
    //
    // We have provided modules for you to use inside the CPU. Please see
    // the following files:
    // reg_file.sv (register file), reg_en.sv (register with enable and reset),
    // reg_reset.sv (register with only reset), alu.sv (ALU)
    // Useful constants and opcodes are provided in cpu.svh, which is included
    // at the top of this file.
    //
    // Place the instruction machine code (generated by your assembler, or the
    // provided assembler) in asm/instr.mem and it will be automatically
    // loaded into main memory starting at address 0x00400000. Make sure the memory
    // file is imported into Vivado first (`./tcl.sh refresh`).
endmodule
