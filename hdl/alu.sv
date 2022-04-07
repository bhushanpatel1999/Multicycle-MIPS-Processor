`include "cpu.svh"

module alu
    #(parameter N = 32)
    (
        input logic signed [N-1:0] x, y,
        input logic [3:0] op,
        output logic [N-1:0] z,
        output logic zero
    );

    always_comb begin
        z = 0;
        case (op)
            `ALU_AND: z = x & y;
            `ALU_OR: z = x | y;
            `ALU_XOR: z = x ^ y;
            `ALU_NOR: z = ~(x | y);
            `ALU_ADD: z = x + y;
            `ALU_SUB: z = x - y;
            `ALU_SLT: z = x < y;
            `ALU_SRL: z = x >> y;
            `ALU_SLL: z = x << y;
            `ALU_SRA: z = x >>> y;
        endcase
    end

    assign zero = z == 32'd0;
endmodule
