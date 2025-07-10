`timescale 1ns / 1ps

// División de 24 bits para usar en una FPU
module fpu_divider #(parameter WIDTH = 24) (
    input clk,
    input rst,
    input start,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] quotient,
    output reg done,
    output reg div_by_zero
);

    reg [1:0] state;
    localparam IDLE = 2'b00,
               DIVIDE = 2'b01,
               DONE = 2'b10;

    reg [WIDTH*2-1:0] dividend;
    reg [WIDTH-1:0] divisor;
    reg [WIDTH-1:0] result;
    reg [5:0] bit_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 0;
            done <= 0;
            div_by_zero <= 0;
            dividend <= 0;
            divisor <= 0;
            result <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        if (b == 0) begin
                            div_by_zero <= 1;
                            quotient <= 0;
                            done <= 1;
                            state <= DONE;
                        end else begin
                            div_by_zero <= 0;
                            dividend <= {a, {WIDTH{1'b0}}};
                            divisor <= b;
                            result <= 0;
                            bit_counter <= WIDTH;
                            state <= DIVIDE;
                        end
                    end
                end
                DIVIDE: begin
                    if (bit_counter != 0) begin
                        dividend = dividend << 1;
                        if (dividend[WIDTH*2-1:WIDTH] >= divisor) begin
                            dividend[WIDTH*2-1:WIDTH] = dividend[WIDTH*2-1:WIDTH] - divisor;
                            result = (result << 1) | 1'b1;
                        end else begin
                            result = result << 1;
                        end
                        bit_counter = bit_counter - 1;
                    end else begin
                        quotient <= result;
                        done <= 1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (!start) state <= IDLE;
                end
            endcase
        end
    end
endmodule