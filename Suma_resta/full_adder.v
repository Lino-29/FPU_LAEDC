module full_adder(
  input wire a, b, cin,
  output wire cout, sum
);

  wire t;
    
  assign t = a ^ b;
  assign cout = (cin & t) | (a & b);
  assign sum = t ^ cin;
    
endmodule