// register with asynchronous reset

module reg_reset
    #(
        parameter N = 32
    )
    (
        input logic clk, rst,
        input logic [N-1:0] d,
        output logic [N-1:0] q
    );
    
    always_ff @(posedge clk, posedge rst)
        if (rst)
            q <= 0;
        else
            q <= d;
endmodule
