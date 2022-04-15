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
        output logic [1:0] ALUSrcA,
        output logic [1:0] ALUSrcB,
        output logic IRWrite,
        output logic PCWrite,
        output logic RegWrite,
        output logic RegDst,
        output logic [3:0] ALUControl
    );
    
    logic [3:0] state;
    logic [3:0] next_state;
    
    // FLOW: Synchronous logic (update the state on clock edge)
    always_ff @(posedge clk, posedge rst) begin
        if (rst || state == `S3) begin
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
                ALUSrcA = 00;
                ALUSrcB = 01;
                IRWrite = 1;
                PCWrite = 1;
                RegWrite = 0;
                ALUControl = `ALU_ADD;
                next_state = `S1;
            end
            `S1: begin
                IRWrite = 0;
                PCWrite = 0;
                case (opcode)
                   `OP_RTYPE: begin 
                        next_state = `S2;
                    end
                   `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_ADDI: begin 
                        next_state = `S4;
                    end
                   default: begin 
                        ALUControl = `ALU_AND;
                        ALUSrcA = 01;
                        ALUSrcB = 00; 
                    end
                 endcase
            end
            `S2: begin
                IRWrite = 0;
                PCWrite = 0;
                RegDst = 1;
                case (funct)
                   `F_AND: begin 
                        ALUControl = `ALU_AND; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end
                   `F_OR: begin 
                        ALUControl = `ALU_OR; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end 
                   `F_NOR: begin 
                        ALUControl = `ALU_NOR; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end
                   `F_XOR: begin 
                        ALUControl = `ALU_XOR;
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end
                   `F_SLL: begin
                        ALUControl = `ALU_SLL;
                        ALUSrcA = 10;
                        ALUSrcB = 10;
                    end
                   `F_SRL: begin 
                        ALUControl = `ALU_SRL; 
                        ALUSrcA = 10;
                        ALUSrcB = 10;
                    end
                   `F_SRA: begin 
                        ALUControl = `ALU_SRA; 
                        ALUSrcA = 10;
                        ALUSrcB = 10;
                    end
                   `F_SLT: begin 
                        ALUControl = `ALU_SLT; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end
                   `F_ADD: begin 
                        ALUControl = `ALU_ADD; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end
                   `F_SUB: begin 
                        ALUControl = `ALU_SUB; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                    end
                   default: begin 
                        ALUControl = `ALU_AND;
                        ALUSrcA = 01;
                        ALUSrcB = 00; 
                    end
                 endcase
                 next_state = `S3;
            end
            `S3: begin
                RegWrite = 1;
                next_state = `S0;
            end
            `S4: begin
                IRWrite = 0;
                PCWrite = 0;
                RegDst = 0;
                case (opcode)
                   `OP_ADDI: begin 
                        ALUControl = `ALU_ADD; 
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   `OP_ANDI: begin 
                        ALUControl = `ALU_AND; 
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end 
                   `OP_XORI: begin 
                        ALUControl = `ALU_XOR; 
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   `OP_ORI: begin 
                        ALUControl = `ALU_OR;
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   `OP_SLTI: begin
                        ALUControl = `ALU_SLT;
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   default: begin 
                        ALUControl = `ALU_AND;
                        ALUSrcA = 01;
                        ALUSrcB = 00; 
                    end
                 endcase
                 next_state = `S3;
            end
            default: begin
                ALUSrcA = 00;
                ALUSrcB = 01;
                IRWrite = 1;
                PCWrite = 1;
                RegWrite = 0;
                ALUControl = `ALU_ADD;
                next_state = `S1;
            end
        endcase
    end
endmodule
