module dff #(parameter WIDTH = 1)(
  input wire clk,
  input wire arst_n,
  input wire [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);

  always @(posedge clk or negedge arst_n)
    if(!arst_n)
      q <= {WIDTH{1'b0}};
    else 
      q <= d;

endmodule