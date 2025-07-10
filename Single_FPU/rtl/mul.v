module mul #(parameter N = 23) (
    input [N-1:0] x,
    input [N-1:0] y,
    input clk,
    input rst,
    output [2*N-1:0] z
);

    wire [N-2:0] sx [N-1:0];
    wire [N-2:0] sx_reg [N-1:0];
    wire cx [N-2:0];
    wire cx_reg [N-2:0];
    wire z_out [N-1:0];
    wire y_reg [N-1:0];
    wire [N-1:0] x_reg [N-1:0];
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_step
            if (i == 0) begin
                parallel_shift #(1, N) x_delay0 (
                    .clk(clk),
                    .rst(rst),
                    .in(x),
                    .out(x_reg[0])
                );
                step #(N) h0 (
                    .X(x),
                    .Y(y[0]),
                    .Si(1'b0),
                    .Sx({(N-1){1'b0}}),
                    .So({sx[0], z_out[0]}),
                    .Co(cx[0])
                );
                shift #(1) Cx_delay0 (
                    .clk(clk),
                    .rst(rst),
                    .in(cx[0]),
                    .out(cx_reg[0])
                );
                parallel_shift #(1, N-1) Sx_delay0 (
                    .clk(clk),
                    .rst(rst),
                    .in(sx[0]),
                    .out(sx_reg[0])
                );
                shift #(N-1) S0_delay0 (
                    .clk(clk),
                    .rst(rst),
                    .in(z_out[0]),
                    .out(z[0])
                );

            end else if (i == N-1) begin
                shift #(N-1) y_delay (
                    .clk(clk),
                    .rst(rst),
                    .in(y[N-1]),
                    .out(y_reg[N-2])
                );
                step #(N) h (
                    .X(x_reg[N-2]),
                    .Y(y_reg[N-2]),
                    .Si(cx_reg[i-1]),
                    .Sx(sx_reg[i-1]),
                    .So(z[2*N-2:N-1]),
                    .Co(z[2*N-1])
                );

            end else begin
                parallel_shift #(1, N) x_delay (
                    .clk(clk),
                    .rst(rst),
                    .in(x_reg[i-1]),
                    .out(x_reg[i])
                );
                shift #(i) y_delay (
                    .clk(clk),
                    .rst(rst),
                    .in(y[i]),
                    .out(y_reg[i-1])
                );
                step #(N) h (
                    .X(x_reg[i-1]),
                    .Y(y_reg[i-1]),
                    .Si(cx_reg[i-1]),
                    .Sx(sx_reg[i-1]),
                    .So({sx[i], z_out[i]}),
                    .Co(cx[i])
                );
                shift #(1) Cx_delay (
                    .clk(clk),
                    .rst(rst),
                    .in(cx[i]),
                    .out(cx_reg[i])
                );
                parallel_shift #(1, N-1) Sx_delay (
                    .clk(clk),
                    .rst(rst),
                    .in(sx[i]),
                    .out(sx_reg[i])
                );
                shift #(N-1-i) S0_delay (
                    .clk(clk),
                    .rst(rst),
                    .in(z_out[i]),
                    .out(z[i])
                );
            end
        end
    endgenerate
endmodule