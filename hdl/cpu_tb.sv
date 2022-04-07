// For this project the SystemVerilog testbench is
// provided, you do not need to modify it.
//
// You will have to write one or multiple MIPS programs
// that test the functionality of your CPU, and assemble
// them using your assembler from project 4, or the provided
// assembler. Then you can run this testbench and observe
// the results in the waveform viewer.
//
// Please place the machine code output of the assembler in
// the `asm/instr.mem` file, and make sure to import that
// file into your vivado project (`./tcl.sh refresh`). The
// RAM module that we provide will automatically load it
// into the memory space starting at 0x400000. Any hex data
// in asm/data.mem will also be automatically loaded into RAM
// starting at address 0.
module cpu_tb();
    logic clk_100M, clk_en, rst;

    logic wr_en;
    logic [31:0] mem_addr, w_data, r_data;
    logic [31:0] dbg_addr, mem_rdbg_data;
    logic [31:0] instr;
    logic [31:0] rdbg_addr;
    logic [31:0] rdbg_data;

    rw_ram ram_unit (.clk_100M(clk_100M),
                     .clk_en(clk_en),
                     .wr_en(wr_en),
                     .addr(mem_addr),
                     .w_data(w_data),
                     .r_data(r_data),
                     .rdbg_addr(rdbg_addr),
                     .rdbg_data(mem_rdbg_data));
   
    cpu cpu_unit (.clk_100M(clk_100M),
                  .clk_en(clk_en),
                  .rst(rst),
                  .r_data(r_data),
                  .wr_en(wr_en),
                  .mem_addr(mem_addr),
                  .w_data(w_data),
                  .rdbg_addr(rdbg_addr),
                  .rdbg_data(rdbg_data),
                  .instr(instr));

    initial begin
        rst <= 1;
        # 22;
        rst <= 0;
    end

    always begin
        // clock does not need to be
        // divided for simulation
        clk_en <= 1;
        clk_100M <= 1;
        #5;
        clk_en <= 0;
        clk_100M <= 0;
        #5;
    end
endmodule
