module cpu_top
    (
        input logic clk_100M, // 100M clock signal
        input logic [15:0] sw,
        input logic reset_n,
        output logic [0:0] led,
        output logic [7:0] an,
        output logic [7:0] sseg
    );

    logic clk_en, clk_dbg, rst;
    assign rst = ~reset_n;
    assign led[0] = clk_dbg;

    logic [27:0] divide_sw;
    assign divide_sw = sw[5:0] << 20;
    clk_divider clk_div_unit (.clk(clk_100M), 
                              .rst(1'b0),
                              .max(divide_sw),
                              .out_clk(clk_en),
                              .dbg_out(clk_dbg));


    logic wr_en;
    logic [31:0] mem_addr, w_data, r_data;
    logic [31:0] mem_rdbg_data;
    logic [31:0] rf_rdbg_data, instr;
    logic [7:0]  rdbg_addr;
    logic [4:0]  rf_rdbg_addr;
    logic [31:0] mem_rdbg_addr;
    
    // switches 13 down to 6 for debug address
    assign rdbg_addr = sw[13:6];
    assign rf_rdbg_addr = rdbg_addr[4:0]; // lower five for regfile address
    assign mem_rdbg_addr = {22'd0, rdbg_addr << 2}; // word aligned access to first 256 words of data mem
    
    rw_ram ram_unit (.clk_100M(clk_100M),
                     .clk_en(clk_en),
                     .wr_en(wr_en),
                     .addr(mem_addr),
                     .w_data(w_data),
                     .r_data(r_data),
                     .rdbg_addr(mem_rdbg_addr),
                     .rdbg_data(mem_rdbg_data));

    cpu cpu_unit (.clk_100M(clk_100M),
                  .clk_en(clk_en),
                  .rst(rst),
                  .r_data(r_data),
                  .wr_en(wr_en),
                  .mem_addr(mem_addr),
                  .w_data(w_data),
                  .rdbg_addr(rf_rdbg_addr),
                  .rdbg_data(rf_rdbg_data),
                  .instr(instr));


    logic [31:0] disp;
    
    // choose which signal to display on sseg
    always_comb begin
        case (sw[15:14]) inside
            2'b?1: disp = instr;
            2'b00: disp = rf_rdbg_data;
            2'b10: disp = mem_rdbg_data;
        endcase
    end

    disp_hex_mux disp_unit (.clk(clk_100M),
                            .reset(1'b0),
                            .hex7(disp[31:28]), 
                            .hex6(disp[27:24]),
                            .hex5(disp[23:20]), 
                            .hex4(disp[19:16]), 
                            .hex3(disp[15:12]),
                            .hex2(disp[11:8]), 
                            .hex1(disp[7:4]), 
                            .hex0(disp[3:0]),
                            .dp_in(8'b11111111),
                            .an(an),
                            .sseg(sseg));
endmodule