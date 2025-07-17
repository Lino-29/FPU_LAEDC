`timescale 1ns/1ps

module tb_testing;

    // Parámetros
    parameter WIDTH = 32;
    parameter EXP_BITS = 8;
    parameter MANT_BITS = 23;

    // Señales de prueba
    reg [WIDTH-1:0] a, b;
    reg operation_select;
    reg clk;
    reg reset;
    wire [WIDTH-1:0] result;

    initial begin
        $shm_open("shm_db");
        $shm_probe("ASMTR");
    end

    // Instancia del DUT (Device Under Test)
    add_sub_main #(.WIDTH(WIDTH), .EXP_BITS(EXP_BITS), .MANT_BITS(MANT_BITS)) dut (
        .a(a),
        .b(b),
        .operation_select(operation_select),
        .clk(clk),
        .reset(reset),
        .result(result)
    );

    // Generación del reloj (período de 10ns -> 100MHz)
    always #5 clk = ~clk;

    // Proceso de estímulo
    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 1;
        a = 0;
        b = 0;
        operation_select = 0;

        // Aplicar reset
        #10 reset = 0;

        // Prueba 1: Suma de dos números flotantes
        #10 a = 32'h40400000; // 3.0 en IEEE 754
            b = 32'h40800000; // 4.0 en IEEE 754
            operation_select = 0; // Suma

        // Prueba 2: Resta de dos números flotantes
        #20 a = 32'h40A00000; // 5.0 en IEEE 754
            b = 32'h40000000; // 2.0 en IEEE 754
            operation_select = 1; // Resta

        // Prueba 3: Suma de un número positivo con un número negativo
        #20 a = 32'hC0800000; // -4.0 en IEEE 754
            b = 32'h40800000; // 4.0 en IEEE 754
            operation_select = 0; // Suma

        // Prueba 4: Resta con números negativos
        #20 a = 32'hC0A00000; // -5.0 en IEEE 754
            b = 32'hC0000000; // -2.0 en IEEE 754
            operation_select = 1; // Resta

        // Prueba 5: Ceros y reset
        #20 a = 32'h00000000; // 0
            b = 32'h00000000; // 0
            operation_select = 0; // Suma

        // Aplicar reset y repetir la prueba
        #20 reset = 1;
        #10 reset = 0;

        // Finalizar simulación
        #50 $finish;
    end

    // Monitoreo de señales
    initial begin
        $dumpfile("tb_testing.vcd"); // Generar archivo VCD para GTKWave
        $dumpvars(0, tb_testing);
        $monitor("Time: %0t | a: %h | b: %h | op: %b | result: %h",
                 $time, a, b, operation_select, result);
    end

endmodule
