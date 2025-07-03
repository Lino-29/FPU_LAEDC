module flags_block(
    input [8:0] exp_raw,       // exponente sin sesgo más posible carry de redondeo
    input guard,
    input round,
    input sticky,
    output reg overflow,
    output reg underflow,
    output reg inexact
);

  always @* begin
    overflow = 1'b0;
    underflow = 1'b0;
    inexact = (guard | round | sticky);

    if (exp_raw >= 9'd255) begin
      overflow = 1'b1;
    end

    else if (exp_raw == 9'd0) begin
      underflow = 1'b1;
    end
  end
endmodule