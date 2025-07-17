`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 01/27/2025 12:24:12 AM
// Design Name: 
// Module Name: normalize_rounder
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

module normalize_rounder #(parameter WIDTH = 32) (
    input [26:0] result_mant, 
    input op, 
    input [7:0] exp_result,    
    input result_sign,
    input carry_out,
    input clk,
    input reset,
    output reg [31:0] R        
);

    reg [7:0] final_exp = 0;
    reg [22:0] final_mant = 0;

    reg [4:0]shift = 0;
    wire [22:0] mant;
    wire [2:0] GRS;
    wire first_bit;
    wire [26:0] rounded_mant;
    reg lz_error;  // Cambiado de 'bit' a 'reg'

    assign rounded_mant = (carry_out & op) ? ({1'b1,result_mant} >> 1) : result_mant;
    assign {first_bit,mant,GRS} = rounded_mant;

    always @(*) begin
        lz_error = 0;
        if (first_bit == 0) begin
            casex (mant)
                23'b00000000000000000000001: shift=23;
                23'b0000000000000000000001x: shift=22;
                23'b000000000000000000001xx: shift=21;
                23'b00000000000000000001xxx: shift=20;
                23'b0000000000000000001xxxx: shift=19;
                23'b000000000000000001xxxxx: shift=18;
                23'b00000000000000001xxxxxx: shift=17;
                23'b0000000000000001xxxxxxx: shift=16;
                23'b000000000000001xxxxxxxx: shift=15;
                23'b00000000000001xxxxxxxxx: shift=14;
                23'b0000000000001xxxxxxxxxx: shift=13;
                23'b000000000001xxxxxxxxxxx: shift=12;
                23'b00000000001xxxxxxxxxxxx: shift=11;
                23'b0000000001xxxxxxxxxxxxx: shift=10;
                23'b000000001xxxxxxxxxxxxxx: shift=9;
                23'b00000001xxxxxxxxxxxxxxx: shift=8;
                23'b0000001xxxxxxxxxxxxxxxx: shift=7;
                23'b000001xxxxxxxxxxxxxxxxx: shift=6;
                23'b00001xxxxxxxxxxxxxxxxxx: shift=5;
                23'b0001xxxxxxxxxxxxxxxxxxx: shift=4;
                23'b001xxxxxxxxxxxxxxxxxxxx: shift=3;
                23'b01xxxxxxxxxxxxxxxxxxxxx: shift=2;
                23'b1xxxxxxxxxxxxxxxxxxxxx: shift=1;
                default: begin
                    shift=0;
                    lz_error = 1;
                end
            endcase
        end
        else begin
            shift = 0;
        end

        final_mant = mant << shift;
        if (op == 1'b1)
                final_exp = exp_result + carry_out;
            else
                final_exp = exp_result - shift;
        
        R = {result_sign, final_exp, final_mant};
    end

endmodule