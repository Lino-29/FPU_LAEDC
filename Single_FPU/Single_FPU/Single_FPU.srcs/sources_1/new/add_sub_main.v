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
//
//////////////////////////////////////////////////////////////////////////////////
module add_sub_main #(parameter WIDTH = 32, EXP_BITS = 8, MANT_BITS = 23)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input operation_select,
    input clk,
    input reset,
    output [2:0] GRS,
    output [8:0] e_raw,
    output [WIDTH-1:0] result
);

    //reg a_greater;
    wire carry_out;
    wire [4:0] shift_spaces;
    wire [MANT_BITS+3:0] mantissa_a_shifted; 
    wire [MANT_BITS+3:0] mantissa_b_shifted; 
    wire [MANT_BITS+3:0] mantissa_result_shifted;
    wire [MANT_BITS-1:0] mantissa_result;
    wire [EXP_BITS-1:0] exp_result;
    wire [1:0] exp_disc;
    wire sign_result;
    wire [31:0] result_nd;
    wire [8:0] e_raw_nd;
    wire [2:0] GRS_nd;

    wire sign_a;
    assign sign_a = a[31];          // asignación bit de signo a

    wire sign_b;
    assign sign_b = b[31];          // asignación bit de signo b

    wire [MANT_BITS-1:0] mantissa_a;
    assign mantissa_a = a[22:0];    // asignación de mantisa a

    wire [MANT_BITS-1:0] mantissa_b;
    assign mantissa_b = b[22:0];    // asignación de mantisa b

    wire [EXP_BITS-1:0] exp_a; 
    assign exp_a = a[30:23];        // asignación de exponente a

    wire [EXP_BITS-1:0] exp_b;
    assign exp_b = b[30:23];        // asignación de exponente b

    reg [WIDTH-1:0] result_delay [0:21];
    reg [8:0]       e_raw_delay   [0:21];
    reg [2:0]       GRS_delay     [0:21];
    
    reg [WIDTH-1:0] result_out;
    reg [8:0]       e_raw_out;
    reg [2:0]       GRS_out;
    
    assign result = result_out;
    assign e_raw  = e_raw_out;
    assign GRS    = GRS_out;

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 22; i = i + 1) begin
                result_delay[i] <= 0;
                e_raw_delay[i] <= 0;
                GRS_delay[i] <= 0;
            end
            result_out <= 0;
            e_raw_out <= 0;
            GRS_out <= 0;
        end else begin
            result_delay[0] <= result_nd;
            e_raw_delay[0] <= e_raw_nd;
            GRS_delay[0] <= GRS_nd;
    
            for (i = 1; i < 22; i = i + 1) begin
                result_delay[i] <= result_delay[i-1];
                e_raw_delay[i] <= e_raw_delay[i-1];
                GRS_delay[i] <= GRS_delay[i-1];
            end
    
            result_out <= result_delay[21];
            e_raw_out <= e_raw_delay[21];
            GRS_out <= GRS_delay[21];
        end
    end



    sign_logic #(WIDTH) sign_ins ( 
        .sign_a(sign_a),
        .sign_b(sign_b),
        .mantissa_a(mantissa_a),
        .mantissa_b(mantissa_b),
        .exp_a(exp_a),
        .exp_b(exp_b),
        .operation_select(operation_select),
        .sign_r(sign_result)
    );


    // TODO add exception_block instance here


    exponent_sub_upd #(.EXP_WIDTH(EXP_BITS)) exp_ins  ( 
        .exp_a(exp_a),
        .exp_b(exp_b),
        .exp_disc(exp_disc),
        .sign_a(sign_a),
        .sign_b(sign_b),
        .exp_value(exp_result),
        .shift_spaces(shift_spaces),
        .operation_select(operation_select)
    );

    mantissa_shifter #(.MANTISSA_WIDTH(MANT_BITS)) mantissa_shifter_ins ( 
        .ma(mantissa_a),
        .mb(mantissa_b),
        .shift_spaces(shift_spaces),
        .exp_magnitude(exp_disc),
        .mantissa_a_out(mantissa_a_shifted),
        .mantissa_b_out(mantissa_b_shifted)
    );

    mantissa_add_sub #(.MANTISSA_WIDTH(MANT_BITS)) mantissa_add_sub_ins ( 
        .man_a(mantissa_a_shifted),
        .man_b(mantissa_b_shifted),
        .ma_sign(sign_a),
        .mb_sign(sign_b),
        .operation_select(operation_select),
        .result(mantissa_result_shifted),
        .carry_out(carry_out)
    );

    normalize_rounder #(.WIDTH(WIDTH)) normalize_rounder_inst ( 
        .result_mant(mantissa_result_shifted),
        .op(operation_select),
        .exp_result(exp_result),
        .result_sign(sign_result),
        .carry_out(carry_out),
        .e_raw(e_raw_nd),
        .R(result_nd),
        .clk(clk),
        .ma_sign(sign_a),
        .mb_sign(sign_b),
        .GRS(GRS_nd),
        .reset(reset)
    );
    
endmodule