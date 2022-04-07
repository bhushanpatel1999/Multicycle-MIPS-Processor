// register with asynchronous reset and synchronous enable

module reg_en
    #(
        parameter N = 32,
        parameter INIT = 0
    )
    (
        input logic clk, rst,
        input logic en,
        input logic [N-1:0] d,
        output logic [N-1:0] q
    );
    
    always_ff @(posedge clk, posedge rst)
        if (rst)
            q <= INIT;
        else if (en)
            q <= d;
endmodule
