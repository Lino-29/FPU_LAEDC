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

module exception_block #(parameter WIDTH = 32)
(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input [1:0] operation_select_nd,
    input clk,
    input arst,
    output exc_result_en,
    output reg invalid, div_by_zero,
    output reg [WIDTH-1:0]result
);
    
    reg [WIDTH-1:0] A_delay [0:22];
    reg [WIDTH-1:0] B_delay [0:22];
    reg [1:0] operation_select_delay [0:22];
    reg [WIDTH-1:0] A_reg, B_reg;
    reg [1:0] operation_select;
    wire a_sign   = A_reg[31];
    wire b_sign   = B_reg[31];
    wire [7:0] a_exp = A_reg[30:23];
    wire [7:0] b_exp = B_reg[30:23];
    wire [22:0] a_frac = A_reg[22:0];
    wire [22:0] b_frac = B_reg[22:0];
    
    // Detecciones básicas
    wire a_zero = (a_exp==8'b0 && a_frac==0);
    wire b_zero = (b_exp==8'b0 && b_frac==0);
    wire a_inf  = (a_exp==8'hFF && a_frac==0);
    wire b_inf  = (b_exp==8'hFF && b_frac==0);
    wire a_nan  = (a_exp==8'hFF && a_frac!=0);
    wire b_nan  = (b_exp==8'hFF && b_frac!=0);
    
    integer i;
    always @(posedge clk or posedge arst) begin
        if (arst) begin
            for (i = 0; i < 23; i = i + 1) begin
                A_delay[i] <= 0;
                B_delay[i] <= 0;
                //operation_select_delay[i] <= 0;
            end
            A_reg <= 0;
            B_reg <= 0;
            //operation_select <= 0;
        end else begin
            A_delay[0] <= A;
            B_delay[0] <= B;
            //operation_select_delay[0] <= operation_select_nd;
    
            for (i = 1; i < 23; i = i + 1) begin
                A_delay[i] <= A_delay[i-1];
                B_delay[i] <= B_delay[i-1];
              //  operation_select_delay[i] <= operation_select_delay[i-1];
            end
    
            A_reg <= A_delay[22];
            B_reg <= B_delay[22];
           // operation_select <= operation_select_delay[22];
        end
    end
    
    // Patrón NaN quiet Canonical: bit de mantisa MSB=1
    localparam [31:0] CANONICAL_NAN = {1'b0, 8'hFF, 1'b1, 22'b0};

    assign exc_result_en = (a_zero | b_zero | a_inf | b_inf | a_nan | b_nan);
    
    always @* begin
        // Default: pasar raw_result sin excepciones
        result      = 32'h00000000;
        invalid     = 1'b0;
        div_by_zero = 1'b0;
    
        // 1) NaN de entrada ? NaN canónica, invalid
        if (a_nan || b_nan) begin
            result  = CANONICAL_NAN;
            invalid = 1'b1;
        end else begin
            case (operation_select_nd)
                // Resta (00) y Suma (01)
                2'b00, 2'b01: begin
                    // Cualquier Inf con operando finito ? Inf con signo adecuado
                    if (a_inf && !b_inf) begin
                        result = A_reg;
                    end else if (!a_inf && b_inf) begin
                        // resta: op=00 -> a - b = a + (-b): invierte signo en resta
                        if (operation_select_nd==2'b00) result = {~b_sign, 8'hFF, 23'b0};
                        else result = B_reg;
                    end
                    else if (a_zero && b_zero) begin
                        // +0 ± +0 = +0 ; +0 ± -0 = depende del signo
                        result = { (a_sign & b_sign), 8'h00, 23'b0 }; // IEEE permite que el signo de cero dependa
                    end else if (a_zero) begin
                        // 0 ± B
                        if (operation_select_nd == 2'b00)  // Resta: 0 - B
                            result = { ~b_sign, B_reg[30:0] };
                        else                            // Suma: 0 + B
                            result = B_reg;
                    end else if (b_zero) begin
                        // A ± 0 ? resultado es A
                        result = A_reg;
                    end
                    // Inf ± Inf
                    else if (a_inf && b_inf) begin
                        // suma: op=01, signos iguales ? Inf; signos distintos ? NaN
                        // resta: op=00, a_inf - b_inf: signos opuestos equivale a suma de inf con distintos signos
                        if ((operation_select_nd==2'b01 && a_sign==b_sign) || (operation_select_nd==2'b00 && a_sign!=b_sign)) begin
                            result = {a_sign, 8'hFF, 23'b0};
                        end else begin
                            result  = CANONICAL_NAN;
                            invalid = 1'b1;
                        end
                    end
                end
    
                // Multiplicación (10)
                2'b10: begin
                    // Inf * finito o finito * Inf ? Inf (signo xor)
                    if ((a_inf && !b_zero) || (b_inf && !a_zero)) begin
                        result = {a_sign^b_sign, 8'hFF, 23'b0};
                    end
                    // 0 * Inf ? invalid
                    else if ((a_zero && b_inf) || (b_zero && a_inf)) begin
                        result  = CANONICAL_NAN;
                        invalid = 1'b1;
                    end
                    else if (a_zero || b_zero) begin
                        result = {a_sign ^ b_sign, 8'h00, 23'b0};
                    end
                end
    
                // División (11)
                2'b11: begin
                    // División por cero: x/0 ? ±Inf
                    if (b_zero && !a_zero) begin
                        result      = {a_sign^b_sign, 8'hFF, 23'b0};
                        div_by_zero = 1'b1;
                    end
                    // 0/0 e Inf/Inf ? invalid
                    else if ((a_zero && b_zero) || (a_inf && b_inf)) begin
                        result  = CANONICAL_NAN;
                        invalid = 1'b1;
                    end
                    // Inf / finito ? Inf
                    else if (a_inf && !b_inf && !b_zero) begin
                        result = {a_sign^b_sign, 8'hFF, 23'b0};
                    end
                    // finito / Inf ? 0
                    else if (!a_inf && b_inf) begin
                        result = {a_sign^b_sign, 8'b0, 23'b0};
                    end
                end
            endcase
        end
    end
endmodule