module clk_divider
    #(parameter N = 28)
    (
        input logic clk, rst,
        input logic [N-1:0] max,
        output logic out_clk,
        // for debugging
        output logic dbg_out
    );

    logic [N-1:0] r_reg;
    logic [N-1:0] r_next;
    
    always_ff @(posedge clk, posedge rst)
        if (rst)
            r_reg <= 0;
        else
            r_reg <= r_next;
    
    always_ff @(posedge clk, posedge rst)
        if (rst) begin
            out_clk <= 0;
            dbg_out <= 0;
        end
        else if (r_reg == max / 2)
            dbg_out <= 0;   // half duty-cycle clock (visible for debug)
        else if (r_reg == max) begin
            out_clk <= 1;
            dbg_out <= 1;
        end
        else
            out_clk <= 0;
    assign r_next = (r_reg >= max) ? 0 : r_reg + 1;
endmodule