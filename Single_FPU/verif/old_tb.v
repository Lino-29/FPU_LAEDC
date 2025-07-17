`timescale 1ns / 1ps

module FPU_tb;

  // Entradas
  reg [31:0] A, B;
  reg [1:0] op;
  reg clk;
  reg arst;
  reg en;

  // Salidas
  wire [4:0] flags;
  wire [31:0] Z;

  // Instancia del DUT
  FPU dut (
    .A(A),
    .B(B),
    .op(op),
    .clk(clk),
    .arst(arst),
    .en(en),
    .flags(flags),
    .Z(Z)
  );

  // Reloj
  initial clk = 0;
  always #5 clk = ~clk;

  // Procedimiento de pruebas
  initial begin
    $display("Inicio del testbench para FPU");

    // Reset
    arst = 1; en = 0; A = 0; B = 0;
    #1; @(posedge clk); arst = 0; en = 1;

    ///////////////////////
    // CASOS DE SUMA
    ///////////////////////
    op = 2'b01;

    // Suma normal
    //A = 32'h41200000;  // 10.0
    //B = 32'h40a00000;  // 5.0
    //#100;
		
		A = 32'hff000001;  // 10.0
    B = 32'h7f000001;  // 5.0
    #100;
		

    // Suma con +?
    A = 32'h7f800000;
    B = 32'h41200000;
    #100;

    // Suma con -?
    A = 32'hff800000;
    B = 32'hc1200000;  // -10.0
    #100;

    // Suma +? + -? = NaN
    A = 32'h7f800000;
    B = 32'hff800000;
    #100;

    // Suma con NaN
    A = 32'h7fc00000;
    B = 32'h41200000;
    #100;

    // Suma con +0
    A = 32'h00000000;
    B = 32'h41200000;
    #100;

    // Suma -0 + -5
    A = 32'h80000000;
    B = 32'hc0a00000;
    #100;

    ///////////////////////
    // CASOS DE RESTA
    ///////////////////////
    op = 2'b00;

    // Resta normal
    A = 32'h41600000;  // 14.0
    B = 32'h40a00000;  // 5.0
    #100;

    // Resta con +? - finito = +?
    A = 32'h7f800000;
    B = 32'h41200000;
    #100;

    // Resta con -? - finito = -?
    A = 32'hff800000;
    B = 32'h41200000;
    #100;

    // Resta +? - +? = NaN
    A = 32'h7f800000;
    B = 32'h7f800000;
    #100;

    // Resta con NaN
    A = 32'h41200000;
    B = 32'h7fc00000;
    #100;

    // Resta +0 - 10
    A = 32'h00000000;
    B = 32'h41200000;
    #100;

    // Resta -0 - (-10)
    A = 32'h80000000;
    B = 32'hc1200000;
    #100;

    ///////////////////////
    // CASOS DE MULTIPLICACIÓN
    ///////////////////////
    op = 2'b10;

    // Multiplicación normal
    A = 32'h40a00000;  // 5.0
    B = 32'h41200000;  // 10.0
    #100;

    // Multiplicación con 0
    A = 32'h00000000;
    B = 32'h41200000;
    #100;

    // Multiplicación con infinito
    A = 32'h7f800000;
    B = 32'h41200000;
    #100;

    // Multiplicación ? * 0 = NaN
    A = 32'h7f800000;
    B = 32'h00000000;
    #100;

    // Multiplicación -? * finito
    A = 32'hff800000;
    B = 32'hc1200000;
    #100;

    // Multiplicación con NaN
    A = 32'h7fc00000;
    B = 32'h41200000;
    #100;

    ///////////////////////
    // CASOS DE DIVISIÓN
    ///////////////////////
    op = 2'b11;

    // División normal
    A = 32'h41c33333;  // ~24.4
    B = 32'h41200000;  // 10.0
    #100;

    // División entre 0 (finito / 0)
    A = 32'h41c33333;
    B = 32'h00000000;
    #100;

    // División 0 / finito
    A = 32'h00000000;
    B = 32'h41c33333;
    #100;

    // División 0 / 0 = NaN
    A = 32'h00000000;
    B = 32'h00000000;
    #100;

    // División ? / finito
    A = 32'h7f800000;
    B = 32'h41200000;
    #100;

    // División finito / ?
    A = 32'h41200000;
    B = 32'h7f800000;
    #100;

    // División ? / ? = NaN
    A = 32'h7f800000;
    B = 32'h7f800000;
    #100;

    // División ? / 0 = NaN
    A = 32'h7f800000;
    B = 32'h00000000;
    #100;

    // División 0 / ? = 0
    A = 32'h00000000;
    B = 32'h7f800000;
    #100;

    // División con NaN
    A = 32'h41200000;
    B = 32'h7fc00000;
    #100;

    A = 32'h7fc00000;
    B = 32'h41200000;
    #100;

    #200;
    $display("Fin del testbench.");
    $finish;
  end

 	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
  end

endmodule
