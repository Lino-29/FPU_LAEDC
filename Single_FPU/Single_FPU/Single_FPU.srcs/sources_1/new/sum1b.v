module sum1b (a,b,ci,so,co);
	input 			   a,b,ci;
	output			   so,co;

	wire			  			x0,x1,x2;

	assign x0=a^b;
	assign x1=x0&ci;
	assign x2=a&b;
	assign so=x0^ci;
	assign co=x1|x2;

endmodule