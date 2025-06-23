module mantissa_divider #(
    parameter WIDTH = 24,
    parameter FRAC_BITS = 24,
    parameter DELAY = 23 // número de ciclos de retardo
) (
    input clk,
    input arst,
    input  [WIDTH-1:0] numerator,
    input  [WIDTH-1:0] denominator,
    output [WIDTH-1:0] quotient,
    output [FRAC_BITS-1:0] fractional,
    output [2*WIDTH-1:0] z
);

    reg [WIDTH-1:0] remainder;
    reg [FRAC_BITS-1:0] fractional_reg;
    reg [WIDTH + FRAC_BITS : 0] temp_rem;
    integer i;

    wire [WIDTH-1:0] quotient_now;
    wire [FRAC_BITS-1:0] fractional_now;
    wire [2*WIDTH-1:0] z_now;

    assign quotient_now = numerator / denominator;

    always @(*) begin
        remainder = numerator % denominator;
        fractional_reg = 0;
        temp_rem = {1'b0, remainder, {FRAC_BITS{1'b0}}};

        for (i = 0; i < FRAC_BITS; i = i + 1) begin
            temp_rem = temp_rem << 1;
            if (temp_rem[WIDTH+FRAC_BITS -: (WIDTH+1)] >= {1'b0, denominator}) begin
                temp_rem[WIDTH+FRAC_BITS -: (WIDTH+1)] = temp_rem[WIDTH+FRAC_BITS -: (WIDTH+1)] - {1'b0, denominator};
                fractional_reg[FRAC_BITS-1-i] = 1'b1;
            end
        end
    end

    assign fractional_now = fractional_reg;
    assign z_now = {quotient_now, fractional_now};

    // --- PIPELINE de retardo ---
    reg [WIDTH-1:0] quotient_pipeline [0:DELAY-1];
    reg [FRAC_BITS-1:0] fractional_pipeline [0:DELAY-1];
    reg [2*WIDTH-1:0] z_pipeline [0:DELAY-1];

    integer j;

    always @(posedge clk or posedge arst) begin
        if (arst) begin
            for (j = 0; j < DELAY; j = j + 1) begin
                quotient_pipeline[j] <= 0;
                fractional_pipeline[j] <= 0;
                z_pipeline[j] <= 0;
            end
        end else begin
            quotient_pipeline[0] <= quotient_now;
            fractional_pipeline[0] <= fractional_now;
            z_pipeline[0] <= z_now;

            for (j = 1; j < DELAY; j = j + 1) begin
                quotient_pipeline[j] <= quotient_pipeline[j-1];
                fractional_pipeline[j] <= fractional_pipeline[j-1];
                z_pipeline[j] <= z_pipeline[j-1];
            end
        end
    end

    assign quotient = quotient_pipeline[DELAY-1];
    assign fractional = fractional_pipeline[DELAY-1];
    assign z = z_pipeline[DELAY-1];

endmodule