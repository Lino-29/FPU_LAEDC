`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cinvestav
// Engineer: Daniel, Lino, Kevin, Emmanuel
// 
// Create Date: 22.01.2025 12:31:55
// Design Name: Floating Point Adder and Subctractor
// Module Name: add_sub
// Project Name: Floating Point Adder and Subctractor
// Target Devices: 
// Tool Versions: 
// Description: Adds and subtracts two inputs and delivers one outup following IEEE 754 format
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mantissa_add_sub #(parameter MANTISSA_WIDTH = 0)(
    input reg [MANTISSA_WIDTH+3:0] man_a, man_b,
    input reg ma_sign, mb_sign, operation_select,
    output reg [MANTISSA_WIDTH+3:0] result,
    output reg carry_out
);
    
    
    // Internal signals
  wire [MANTISSA_WIDTH+3:0] sum;
  wire [MANTISSA_WIDTH+3:0] sub;
    wire op;
    wire [MANTISSA_WIDTH+3:0] operand_a, operand_b; 

    // Apply sign to the mantissas
  assign op = (operation_select ^ (ma_sign ^ mb_sign));

    assign {carry_out, sum} = man_a + man_b;
  	assign sub = man_a + ~man_b + 1;
  assign result = op ? sum : (man_b > man_a) ? ~(sub-1) : sub;
    
endmodule
