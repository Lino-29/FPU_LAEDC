`timescale 1ns / 1ps

/*
	This module handles the exponent logic, 
	where the logic for the multiplier and 
	the divider is unified. In this module, 
	two N-bit numbers are input, and a 10-bit
	output is produced due to the carry from 
	the addition.
*/

module exponent_logic #(
    parameter DELAY = 21
)(
    input [7:0] e_a, e_b, //Exponent of number A and exponent of number B, respectively.
    input clk, arst, en, sel, // clock signal, asynchronous reset, enable signal and operation selector bit
    output [7:0] e //Output exponent
    );

    // Internal variables
    wire [7:0] temp1, temp2; 
    wire [7:0] temp3;
    reg [7:0] buffer1, buffer2;
    reg [7:0] buffer3;

    assign temp1 = ~e_b + 1'b1; // Two's complement of e_b
    assign temp2 = (sel)? temp1 : e_b; // Select between e_b or its two's complement
    assign temp3 = (sel)? 8'h7f : 8'h81; // Bias selection

    always@(posedge clk or posedge arst) begin
        if(arst) begin
            buffer1 <= 8'h00;
            buffer2 <= 8'h00;
            buffer3 <= 8'h00;
        end else if(en) begin
            buffer1 <= temp2;
            buffer2 <= e_a;
            buffer3 <= buffer1 + buffer2;
        end
    end

    wire [7:0] e_now;
    assign e_now = buffer3 + temp3;

    // --- PIPELINE de retardo ---
    reg [7:0] e_pipeline [0:DELAY-1];
    integer i;

    always @(posedge clk or posedge arst) begin
        if (arst) begin
            for (i = 0; i < DELAY; i = i + 1) begin
                e_pipeline[i] <= 8'h00;
            end
        end else begin
            e_pipeline[0] <= e_now;
            for (i = 1; i < DELAY; i = i + 1) begin
                e_pipeline[i] <= e_pipeline[i-1];
            end
        end
    end

    assign e = e_pipeline[DELAY-1];

endmodule