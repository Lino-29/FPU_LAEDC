// rounding.v
// Redondeo de una mantisa de 26 bits (mantissa_in) a 23 bits (mantissa_out)
// Método: Round to nearest, ties to even

module rounding (
    input [25:0] mul_normalize,   // [25:3] significand | [2] guard | [1] round | [0] sticky
    output guard_bit, round_bit, sticky_bit,
    output [22:0] mul_single
);

    assign guard_bit   = mul_normalize[2];
    assign round_bit   = mul_normalize[1];
    assign sticky_bit  = mul_normalize[0];
    wire [22:0] significand = mul_normalize[25:3];
    wire round_up;

    wire lsb = significand[0];  // Least significant bit de la mantisa de 23 bits

    // Decidir si se redondea hacia arriba
    wire should_round_up = guard_bit &&
                           (round_bit | sticky_bit | lsb);

    // Resultado del redondeo
    wire [23:0] rounded = {1'b0, significand} + should_round_up;

    assign mul_single = rounded[22:0];
    assign round_up     = rounded[23];  // Acarreo por redondeo

endmodule