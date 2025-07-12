
`timescale 1ns / 1ps

module FPU_tb;

  // Entradas
  
	bit clk;
	always #5 clk = !clk;
	
	parameter NUM_TESTS = 1000;

	// Instancia de la interfaz
	FPU_interface intf(clk);	

  // Instancia del DUT
  FPU dut (
    .A(intf.A),
    .B(intf.B),
    .op(intf.op),
    .clk(intf.clk),
    .arst(intf.arst),
    .en(intf.en),
    .flags(intf.flags),
    .Z(intf.Z)
  );

  initial begin
		intf.set_enable_to(1);
    //intf.test_full_random(NUM_TESTS);
    intf.test_add_random(20);
		repeat (50) @(posedge clk);
		$finish;
  end

 	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
  end

endmodule
