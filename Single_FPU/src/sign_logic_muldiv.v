`timescale 1ns / 1ps

/*
	This module handles the sign logic. Since the logic
	for multiplication and division is exactly the s_ame,
	the s_ame module is used for both operations.
*/

module sign_logic_muldiv(
    input s_a, s_b, //Sign of number A and Sign of number B, respectively.
    input clk, arst, en, // clock signal, asynchronous reset and enable signal
    output s_r //Output sign
    );
	
    reg [22:0] buffer;// buffers to synchronize the output signal
    wire s;
    
    assign s = s_a^s_b;//Sign of A XOR Sign of B
    
	// buffers to synchronize the output signal
    always@(posedge clk or posedge arst) begin
        if (arst) begin
            buffer <= 23'b0;
        end else if (en) begin
            buffer <= {s,buffer[22:1]};
        end
    end
    assign s_r = buffer[0];
endmodule