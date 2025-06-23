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

module exception_block #(parameter WIDTH = 32, EXP_BITS = 8, MANT_BITS = 23)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input operation_select,
    output [WIDTH-1:0] out_a,
    output [WIDTH-1:0] out_b,
    output reg a_is_denormal,
    output reg b_is_denormal,
    output reg invalid_operation,
    output reg perform_operation,
    output reg [WIDTH-1:0]result
);


    // Check for invalid operations
    always @(*) begin
        invalid_operation = 1'b0;

        if ( (a[30:23] == 8'h00) && (a[22:0] != 23'h000000) ) begin
            a_is_denormal = 1'b1;
            perform_operation = 1'b0;
        end

        if ( (b[30:23] == 8'h00) && (b[22:0] != 23'h000000) ) begin
            b_is_denormal = 1'b1;
            perform_operation = 1'b0;
        end


        if ((a[30:23] == 8'hFF && a[22:0] == 23'h000000) &&                  // 'a' is infinity
            (b[30:23] == 8'hFF && b[22:0] == 23'h000000))                    // 'b' is infinity
            begin
                if ((operation_select == 1'b1 && a[31] != b[31]) ||          // Addition of +inf and -inf
                    (operation_select == 1'b0 && a[31] == b[31]))            // Subtraction of +inf and +inf or -inf and -inf
                begin
                    invalid_operation = 1'b1;
                    perform_operation = 1'b0;
                end
            end
        
        if ((a[30:23] == 8'hFF && a[22:0] != 23'h000000) ||                  // 'a' is NaN
            (b[30:23] == 8'hFF && b[22:0] != 23'h000000))                    // 'b' is NaN
            begin
                invalid_operation = 1'b1;
                perform_operation = 1'b0;
            end
    end

endmodule