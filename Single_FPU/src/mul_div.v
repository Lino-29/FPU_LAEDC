`timescale 1ns / 1ps

module mul_div(
    input [31:0] a, b,
    input clk, arst, en, sel,
    output [2:0] GRS,
    output [8:0] e_raw,
    output [31:0] R
    );
    
    wire [9:0] temp1;
    wire [47:0] temp2, temp3 , temp4;
    wire [25:0] temp5;
    wire [8:0] e_raw_nd;
    
    reg [8:0] e_raw_delay [0:22];  // 23 etapas
    reg [8:0] e_raw_out;
    
    
    assign e_raw = e_raw_out;
    
    integer i;
    always @(posedge clk or posedge arst) begin
        if (arst) begin
            for (i = 0; i < 23; i = i + 1)
                e_raw_delay[i] <= 9'd0;
            e_raw_out <= 9'd0;
        end else if (en) begin
            e_raw_delay[0] <= e_raw_nd;
    
            for (i = 1; i < 23; i = i + 1)
                e_raw_delay[i] <= e_raw_delay[i-1];
    
            e_raw_out <= e_raw_delay[22];
        end
    end

    sign_logic_muldiv sign_logic_muldiv_i(
        .s_a(a[31]),
        .s_b(b[31]),
        .clk(clk),
        .arst(arst), 
        .en(en),
        .s_r(R[31])
    );
    
    exponent_logic exponent_logic_i(
        .e_a(a[30:23]), 
        .e_b(b[30:23]),
        .clk(clk),
        .arst(arst),
        .en(en),
        .sel(sel),
        .temp4(e_raw_nd),
        .e(temp1)
    );
    
    mul #(.N(24)) mul_i (
        .x({1'b1,a[22:0]}),
        .y({1'b1,b[22:0]}),
        .clk(clk),
        .rst(arst),
        .z(temp2)
    );

    mantissa_divider #(24,24) mantissa_divider_i(
        .clk(clk),
        .arst(arst),
        .numerator({1'b1,a[22:0]}),
        .denominator({1'b1,b[22:0]}),
        .quotient(q_div),
        .fractional(f_div),
        .z(temp3)
    );
    
    /*
    divisor_clk #(24, 48) divisor_clk_i(
        .clk(clk),
        .arst(arst),
        .start(clk),
        .a({1'b1,a[22:0]}),
        .b({1'b1,b[22:0]}),
        .done(done_div),
        .div_by_zero(dz_flag),
        .q(q_div),
        .f(f_div),
        .z(temp3)
    );
    */

    normalizer normalizer_i(
        .mantissa_mul(temp2),
        .mantissa_div(temp3),
        .exponent_add(temp1),
        .sel(sel),
        .clk(clk),
        .arst(arst),
        .en(en),
        .mantissa_normalize(temp5),
        .exponent_single(R[30:23])
    );
    
    rounding rounding_i(
        .mul_normalize(temp5),
        .guard_bit(GRS[0]),
        .round_bit(GRS[1]),
        .sticky_bit(GRS[2]),
        .mul_single(R[22:0])
    );
       
endmodule