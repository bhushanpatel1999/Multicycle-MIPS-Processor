`timescale 1ns / 1ps
`include "cpu.svh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 12:17:39 PM
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module controller
    (
        input logic rst,
        input logic clk,
        input logic clk_en,
        input logic [5:0] opcode,
        input logic [5:0] funct,
        output logic ALUSrcA,
        output logic ALUSrcB,
        output logic IRWrite,
        output logic PCWrite,
        output logic RegWrite,
        output logic [3:0] ALUControl
    );
    
    logic [3:0] state, next_state;
    
    // FLOW: Synchronous logic (update the state on clock edge)
    always_ff @(posedge clk, posedge rst) begin
        if (rst || state == `S2) begin
            state = `S0;
        end
        else if (clk_en) begin
            state = next_state;
        end
    end

    // FLOW: Combinational logic (determine what the next state is)
    always_comb begin
        case (state)
            `S0: begin
                ALUSrcA = 0;
                ALUSrcB = 1;
                IRWrite = 1;
                PCWrite = 1;
                RegWrite = 0;
                ALUControl = `ALU_ADD;
                next_state = `S1;
            end
            `S1: begin
                ALUSrcA = 1;
                ALUSrcB = 0;
                IRWrite = 0;
                PCWrite = 0;
                case (funct)
                   `F_AND : ALUControl = `ALU_AND;
                   `F_OR : ALUControl = `ALU_OR;
                   `F_NOR : ALUControl = `ALU_NOR;
                   `F_XOR : ALUControl = `ALU_XOR;
                   `F_SLL : ALUControl = `ALU_SLL;
                   `F_SRL : ALUControl = `ALU_SRL;
                   `F_SRA : ALUControl = `ALU_SRA;
                   `F_SLT : ALUControl = `ALU_SLT;
                   `F_ADD : ALUControl = `ALU_ADD;
                   `F_SUB : ALUControl = `ALU_SUB;
                   default : ALUControl = `ALU_AND;
                 endcase
                 next_state = `S2;
            end
            `S2: begin
                RegWrite = 1;
                next_state = `S0;
            end
            default: begin
                ALUSrcA = 0;
                ALUSrcB = 1;
                IRWrite = 1;
                PCWrite = 1;
                RegWrite = 0;
                ALUControl = `ALU_ADD;
                next_state = `S1;
            end
        endcase
    end
endmodule
