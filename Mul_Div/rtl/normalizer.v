`timescale 1ns / 1ps

/*
    This module normalizes the mantissa if necessary and adjusts
    the exponent due to the normalization for both multiplication and division.
*/ 

module normalizer(
    input [47:0] mantissa_mul, // mantissa from the multiplier
    input [47:0] mantissa_div, // mantissa from the divisor
    input [7:0] exponent_add,  // exponent coming from exponent logic
    input sel, clk, arst, en,  // operation selector bit, clock signal, asynchronous reset, and enable signal
    output reg [25:0] mantissa_normalize, // output mantissa already normalized
    output reg [7:0] exponent_single // output exponent already adjusted
);

    reg [25:0] temp_mul;
    reg [25:0] temp_div;
    reg [47:0] temp_div_aux;
    reg [4:0] shift_amt;
    integer i;
    reg found; // Variable de control para salir del bucle

    always @(*) begin
        // Inicialización de variables
        temp_mul = 0;
        temp_div = 0;
        shift_amt = 0;
        found = 0;

        // Normalización para multiplicación
        if (mantissa_mul[47]) begin
            temp_mul = mantissa_mul[46:21];
            exponent_single = exponent_add + 1;
        end else begin
            temp_mul = mantissa_mul[45:20];
            exponent_single = exponent_add;
        end

        // Cálculo de ceros a la izquierda para la mantissa de división
        for (i = 24; i >= 0 && !found; i = i - 1) begin
            if (mantissa_div[i]) begin
                shift_amt = 24 - i;
                found = 1; // Sale del bucle en la siguiente iteración
            end
        end
        temp_div_aux = {mantissa_div[23:0],24'h000000};
        temp_div = temp_div_aux[47-shift_amt -: 26];

        // Selección entre multiplicación y división
        if (sel) begin
            mantissa_normalize = temp_div;
            exponent_single = exponent_add - shift_amt;
        end else begin
            mantissa_normalize = temp_mul;
        end
    end

endmodule