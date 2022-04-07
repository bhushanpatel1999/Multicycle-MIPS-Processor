// 32x32 register file

module reg_file
    #(
        parameter DATA_WIDTH = 32, // bits per reg
                  ADDR_WIDTH = 5   // number of address bits
    )
    (
        input logic clk,
        input logic wr_en,
        input logic [ADDR_WIDTH-1:0] w_addr, r0_addr, r1_addr,
        input logic [DATA_WIDTH-1:0] w_data,
        output logic [DATA_WIDTH-1:0] r0_data, r1_data,
        // debug register read
        input logic [ADDR_WIDTH-1:0] rdbg_addr,
        output logic [DATA_WIDTH-1:0] rdbg_data
    );

    logic [DATA_WIDTH-1:0] regs [0:2**ADDR_WIDTH-1];

    always_ff @(posedge clk)
        if (wr_en)
            regs[w_addr] <= w_data;

    assign r0_data = r0_addr == 0 ? 0 : regs[r0_addr];
    assign r1_data = r1_addr == 0 ? 0 : regs[r1_addr];
    assign rdbg_data = rdbg_addr == 0 ? 0 : regs[rdbg_addr];
endmodule
