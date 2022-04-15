`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 06:19:01 PM
// Design Name: 
// Module Name: mux_2
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


module mux_2
    (
        input logic [31:0] a,
        input logic [31:0] b,
        input logic sel,
        output logic [31:0] f
    );
    
    always_comb begin
        if (sel)
            f = b;
        else
            f = a;
    end
endmodule

module mux_4_5bit
    (
        input logic [4:0] a,
        input logic [4:0] b,
        input logic [4:0] c,
        input logic sel,
        output logic [4:0] f
    );
    
    always_comb begin
        if (sel == 00)
            f = a;
        else if (sel == 01)
            f = b;
        else if (sel == 10)
            f = c;
    end
endmodule

module mux_4
    (
        input logic [31:0] a,
        input logic [31:0] b,
        input logic [31:0] c,
        input logic [31:0] d,
        input logic [1:0] sel,
        output logic [31:0] f
    );
    
    always_comb begin
        if (sel == 2'b00)
            f = a;
        else if (sel == 2'b01)
            f = b;
        else if (sel == 2'b10)
            f = c;
        else if (sel == 2'b11)
            f = d;
    end
endmodule

module mux_8
    (
        input logic [31:0] a,
        input logic [31:0] b,
        input logic [31:0] c,
        input logic [31:0] d,
        input logic [31:0] e,
        input logic [2:0] sel,
        output logic [31:0] f
    );
    
    always_comb begin
        if (sel == 2'b000)
            f = a;
        else if (sel == 2'b001)
            f = b;
        else if (sel == 2'b010)
            f = c;
        else if (sel == 2'b011)
            f = d;
        else if (sel == 2'b100)
            f = e;
    end
endmodule
