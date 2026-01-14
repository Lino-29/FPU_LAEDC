`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2025 22:30:29
// Design Name: 
// Module Name: FPU
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


module FPU(
    input [31:0] A,
    input [31:0] B,
    input [1:0] op,
    input clk,
    input arst,
    input en,
    output [4:0] flags,
    output [31:0] Z
    );
    
    wire [31:0] Z_AS;
    wire [31:0] Z_MD;
    wire [31:0] Z_EB;
    wire [31:0] Z_OP;
    wire [8:0] exp_raw_ck, e_raw_AS, e_raw_MD;
    wire [2:0] GRS_ck, GRS_AS, GRS_MD;
    reg [1:0] op_delay [0:22]; // 24 ciclos de retardo
    reg [1:0] op_delayed;
    wire exc_result_en;
    
    integer i;

    always @(posedge clk or posedge arst) begin
        if (arst) begin
            for (i = 0; i < 23; i = i + 1)
                op_delay[i] <= 2'b00;
            op_delayed <= 2'b00;
        end else if (en) begin
            op_delay[0] <= op;
            for (i = 1; i < 23; i = i + 1)
                op_delay[i] <= op_delay[i-1];
            op_delayed <= op_delay[22];
        end
    end
    
    assign Z = exc_result_en ? Z_EB : Z_OP;
    assign Z_OP = op_delayed[1] ? Z_MD : Z_AS;
    assign exp_raw_ck = op_delayed[1] ? e_raw_MD : e_raw_AS;
    assign GRS_ck = op_delayed[1] ? GRS_MD : GRS_AS;
    
    add_sub_main #(.WIDTH(32), .EXP_BITS(8), .MANT_BITS(23)) add_sub_ins  ( 
        .a(A),
        .b(B),
        .operation_select(op[0]),
        .clk(clk),
        .reset(arst),
        .GRS(GRS_AS),
        .e_raw(e_raw_AS),
        .result(Z_AS)
    );
    
    mul_div mul_div_ins (
        .a(A),
        .b(B),
        .clk(clk),
        .arst(arst),
        .en(en),
        .sel(op[0]),
        .GRS(GRS_MD),
        .e_raw(e_raw_MD),
        .R(Z_MD)
    );
    
    exception_block #(.WIDTH(32)) exception_ins  ( 
        .A(A),
        .B(B),
        .operation_select_nd(op_delayed),
        .clk(clk),
        .arst(arst),
        .exc_result_en(exc_result_en),
        .invalid(flags[0]),
        .div_by_zero(flags[1]),
        .result(Z_EB)
    );
    
    flags_block flags_ins (
        .exp_raw(exp_raw_ck),
        .guard(GRS_ck[2]),
        .round(GRS_ck[1]),
        .sticky(GRS_ck[0]),
        .overflow(flags[2]),
        .underflow(flags[3]),
        .inexact(flags[4])
    );
    
endmodule
