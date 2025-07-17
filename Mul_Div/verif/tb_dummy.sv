`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 11:08:08 AM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb;
		//Test nuevo
    parameter N = 10;
    bit [N-1:0] x;
    bit [N-1:0] y;
    bit clk;
    bit sel;
    logic [2*N-1:0] z;
    logic io_flag, dz_flag, of_flag, uf_flag, i_flag;

    initial begin
        $shm_open("shm_db");
        $shm_probe("ASMTR");
    end

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        //$dumpfile("dump.vcd"); 
        //$dumpvars;

        repeat (1000) begin
            std::randomize(x);
            std::randomize(y);
            std::randomize(sel);
            #20;
            $display("x = %d", x);
            $display("y = %d", y);
            //#10;
            //$display("z = %d", z);
            $finish;
        end
    end
    mul_div mul_div_i ( .a(x),
                        .b(y),
                        .clk(clk),
                        .arst(0),
                        .en(1),
                        .sel(sel),
                        .R(z),
                        .io_flag(io_flag),
                        .dz_flag(dz_flag),
                        .of_flag(of_flag),
                        .uf_flag(uf_flag),
                        .i_flag(i_flag));
endmodule
