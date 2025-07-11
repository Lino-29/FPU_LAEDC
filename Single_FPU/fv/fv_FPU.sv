module fv_FPU(
 	input logic A,
  input logic B,
	input logic [1:0] op,
  input logic clk,
  input logic arst,
  input logic en,
  input logic [4:0] flags,
  input logic [31:0] Z
);

	`define AST(block=fifo, name=no_name, precond=1'b1 |->, consq=1'b0) \
	``block``_ast_``name``: assert property (@(posedge clk) disable iff(!arst_n) ``precond`` ``consq``);
	
	`define ASM(block=fifo, name=no_name, precond=1'b1 |->, consq=1'b0) \
	``block``_asm_``name``: assume property (@(posedge clk) disable iff(!arst_n) ``precond`` ``consq``);

	`define COV(block=fifo, name=no_name, precond=1'b1 |->, consq=1'b0) \
	``block``_cov_``name``: cover property (@(posedge clk) disable iff(!arst_n) ``precond`` ``consq``);   

endmodule
