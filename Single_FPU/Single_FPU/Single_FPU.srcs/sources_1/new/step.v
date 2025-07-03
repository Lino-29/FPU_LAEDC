module step #(parameter N = 23) (
        input [N-1:0] X,
        input [N-2:0] Sx,
        input Y, Si,
        output [N-1:0] So,
        output Co
    );
	// Internal wires
	wire [N-2:0] Cx;

	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin : mul1b_gen
			if (i == 0) begin
				mul1b n0 (.si(Sx[0]), .x(X[0]), .y(Y), .ci(1'b0), .so(So[0]), .co(Cx[0]));
			end else if (i == N-1) begin
				mul1b n_last (.si(Si), .x(X[i]), .y(Y), .ci(Cx[i-1]), .so(So[i]), .co(Co));
			end else begin
				mul1b n (.si(Sx[i]), .x(X[i]), .y(Y), .ci(Cx[i-1]), .so(So[i]), .co(Cx[i]));
			end
		end
	endgenerate

endmodule