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
        output logic IorD,
        output logic [1:0] ALUSrcA,
        output logic [1:0] ALUSrcB,
        output logic [1:0] PCSrc,
        output logic IRWrite,
        output logic PCWrite,
        output logic RegWrite,
        output logic MemWrite,
        output logic [1:0] RegDst,
        output logic MemtoReg,
        output logic Branch,
        output logic BranchType,
        output logic [3:0] ALUControl
    );
    
    logic [3:0] state;
    logic [3:0] next_state;
    
    // FLOW: Synchronous logic (update the state on clock edge)
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
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
                IorD = 0;
                ALUSrcA = 00;
                ALUSrcB = 01;
                PCSrc = 00;
                IRWrite = 1;
                PCWrite = 1;
                RegWrite = 0;
                MemWrite = 0;
                Branch = 0;
                ALUControl = `ALU_ADD;
                next_state = `S1;
            end
            `S1: begin
                ALUSrcA = 00;
                ALUSrcB = 11;
                IRWrite = 0;
                PCWrite = 0;
                case (opcode)
                   `OP_RTYPE: begin 
                        next_state = `S2;
                    end
                   `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_ADDI: begin 
                        next_state = `S4;
                    end
                    `OP_SW, `OP_LW: begin 
                        next_state = `S6;
                    end
                    `OP_BEQ, `OP_BNE: begin 
                        next_state = `S10;
                    end
                    `OP_JAL: begin 
                        next_state = `S12;
                    end
                    `OP_J: begin 
                        next_state = `S14;
                    end
                    default: begin 
                        next_state = `S2;
                    end
                 endcase
            end
            `S2: begin
                case (funct)
                   `F_AND: begin 
                        ALUControl = `ALU_AND; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end
                   `F_OR: begin 
                        ALUControl = `ALU_OR; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end 
                   `F_NOR: begin 
                        ALUControl = `ALU_NOR; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end
                   `F_XOR: begin 
                        ALUControl = `ALU_XOR;
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end
                   `F_SLL: begin
                        ALUControl = `ALU_SLL;
                        ALUSrcA = 10;
                        ALUSrcB = 10;
                        next_state = `S3;
                    end
                   `F_SRL: begin 
                        ALUControl = `ALU_SRL; 
                        ALUSrcA = 10;
                        ALUSrcB = 10;
                        next_state = `S3;
                    end
                   `F_SRA: begin 
                        ALUControl = `ALU_SRA; 
                        ALUSrcA = 10;
                        ALUSrcB = 10;
                        next_state = `S3;
                    end
                   `F_SLT: begin 
                        ALUControl = `ALU_SLT; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end
                   `F_ADD: begin 
                        ALUControl = `ALU_ADD; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end
                   `F_SUB: begin 
                        ALUControl = `ALU_SUB; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S3;
                    end
                    `F_JR: begin 
                        ALUControl = `ALU_ADD; 
                        ALUSrcA = 01;
                        ALUSrcB = 00;
                        next_state = `S11;
                    end
                    default: begin 
                        ALUControl = `ALU_AND;
                        ALUSrcA = 01;
                        ALUSrcB = 00; 
                        next_state = `S3;
                    end
                 endcase
            end
            `S3: begin
                RegDst = 01;
                MemtoReg = 0;
                RegWrite = 1;
                next_state = `S0;
            end
            `S4: begin
                RegDst = 00;
                case (opcode)
                   `OP_ANDI: begin 
                        ALUControl = `ALU_AND; 
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   `OP_ORI: begin 
                        ALUControl = `ALU_OR; 
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end 
                   `OP_XORI: begin 
                        ALUControl = `ALU_XOR; 
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   `OP_SLTI: begin 
                        ALUControl = `ALU_SLT;
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                   `OP_ADDI: begin
                        ALUControl = `ALU_ADD;
                        ALUSrcA = 01;
                        ALUSrcB = 11;
                    end
                    default: begin 
                        ALUControl = `ALU_AND;
                        ALUSrcA = 01;
                        ALUSrcB = 11; 
                    end
                 endcase
                 next_state = `S5;
            end
            `S5: begin
                RegDst = 00;
                MemtoReg = 0;
                RegWrite = 1;
                next_state = `S0;
            end
            `S6: begin
                ALUSrcA = 01;
                ALUSrcB = 10;
                ALUControl = `ALU_ADD;
                case (opcode)
                    `OP_SW: begin 
                        next_state = `S7;
                    end
                    `OP_LW: begin 
                        next_state = `S8;
                    end
                    default: begin 
                        next_state = `S7;
                    end
                endcase
            end
            `S7: begin
                IorD = 1;
                MemWrite = 1;
                next_state = `S0;
            end
            `S8: begin
                IorD = 1;
                next_state = `S9;
            end
            `S9: begin
                RegDst = 00;
                MemtoReg = 1;
                RegWrite = 1;
                next_state = `S0;
            end
            `S10: begin
                ALUSrcA = 01;
                ALUSrcB = 00;
                PCSrc = 01;
                Branch = 1;
                ALUControl = `ALU_ADD;
                case (opcode)
                    `OP_BEQ: begin 
                        BranchType = 1;
                    end
                    `OP_BNE: begin 
                        BranchType = 0;
                    end
                    default: begin 
                        BranchType = 1;
                    end
                endcase
                next_state = `S0;
            end
            `S11: begin
                PCSrc = 11;
                PCWrite = 1;
                next_state = `S0;
            end
            `S12: begin
                ALUSrcA = 00;
                ALUSrcB = 01;
                ALUControl = `ALU_ADD;
                next_state = `S13;
            end
            `S13: begin
                RegDst = 10;
                MemtoReg = 0;
                RegWrite = 1;
                next_state = `S14;
            end
            `S14: begin
                PCSrc = 10;
                PCWrite = 1;
                RegWrite = 0;
                next_state = `S0;
            end
            default: begin
                IorD = 0;
                ALUSrcA = 00;
                ALUSrcB = 01;
                PCSrc = 00;
                IRWrite = 1;
                PCWrite = 1;
                RegWrite = 0;
                MemWrite = 0;
                Branch = 0;
                ALUControl = `ALU_ADD;
                next_state = `S1;
            end
        endcase
    end
endmodule
