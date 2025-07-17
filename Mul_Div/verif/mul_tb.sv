`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2025 02:35:40 PM
// Design Name: 
// Module Name: TestBench
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





module mul_tb();
    
    bit clk;
    mul_div_if #() i_f(clk);                                      // Interface instance

    parameter int NUM_RNDM_TESTS = 1000;
    parameter int NUM_SPCFC_TESTS = 50;


    parameter int NEG_MIN_VAL = 32'h80800000;
    parameter int POS_MIN_VAL = 32'h00800000;
    parameter int POS_MAX_VAL = 32'h7F7FFFFF;
    parameter int NEG_MAX_VAL = 32'hFF7FFFFF;
    parameter int POS_INF_VAL = 32'h7F800000;
    parameter int NEG_INF_VAL = 32'hFF800000;

    //______________________________________________________________ Covergroup definition

    covergroup cg_mul_div_fpu @(posedge clk);

        option.per_instance = 1;
        op_select_cp: coverpoint i_f.sel;
        enable_cp: coverpoint i_f.en;                               //modify
        arst_cp: coverpoint i_f.arst;
        result_sign_cp: coverpoint i_f.R[31];

        overflow_flag_cp: coverpoint i_f.of_flag;
        underflow_flag_cp: coverpoint i_f.uf_flag;
        invalid_op_flag_cp: coverpoint i_f.io_flag;
        divide_by_zero_flag_cp: coverpoint i_f.dz_flag;
        inexact_flag_cp: coverpoint i_f.i_flag;

        exp_a_cp: coverpoint i_f.a[30:23] {bins range[16] = {[0:$]};}
        exp_b_cp: coverpoint i_f.b[30:23] {bins range[16] = {[0:$]};}

        a_positive_infinite_cp: coverpoint i_f.a == POS_INF_VAL;
        a_negative_infinite_cp: coverpoint i_f.a ==  NEG_INF_VAL;
        a_nan_cp: coverpoint i_f.a[30:23] == 8'hFF;
        b_positive_infinite_cp: coverpoint i_f.b == POS_INF_VAL;
        b_negative_infinite_cp: coverpoint i_f.b == NEG_INF_VAL;
        b_nan_cp: coverpoint i_f.b[30:23] == 8'hFF;


        // Cross
        op_select_sign_cross: cross op_select_cp, result_sign_cp;
        exp_cross: cross exp_a_cp, exp_b_cp;

    endgroup

    

    cg_mul_div_fpu fpuCoverGroupInstance = new();

    
    mul_div #() DUT (
        .clk(i_f.clk), 
        .arst(i_f.arst),          
        .a(i_f.a),  
        .b(i_f.b),
        .sel(i_f.sel),
        .en(i_f.en),
        .R(i_f.R),
        .io_flag(i_f.io_flag), 
        .dz_flag(i_f.dz_flag), 
        .of_flag(i_f.of_flag), 
        .uf_flag(i_f.uf_flag),
        .i_flag(i_f.i_flag)
    );
    
    // ASSERTS MODULE CONECTION
    bind  mul_div  assertsmodule  asserts(
        .arst(arst),
        .clk(clk),
        .a(a),
        .b(b), 
        .sel(sel), 
        .en(en), 
        .R(R),
        .io_flag(io_flag), 
        .dz_flag(dz_flag), 
        .of_flag(of_flag), 
        .uf_flag(uf_flag),
        .i_flag(i_flag)
    );

    //run_all_tests run_all_tests_instance();

    initial begin
        $shm_open("shm_db");
        $shm_probe("ASMTR");
    end

    always #1 clk = ~clk;
    


    `ifdef TEST_FULL_RANDOM
    
    initial begin
    i_f.test_full_random(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_A_GREATER_THAN_B
    
    initial begin
    i_f.set_sel_to(0);
    i_f.test_a_greater_than_b(NUM_RNDM_TESTS);
    i_f.set_sel_to(1);
    i_f.test_a_greater_than_b(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_B_GREATER_THAN_A
    
    initial begin
    i_f.set_sel_to(0);
    i_f.test_b_greater_than_a(NUM_RNDM_TESTS);
    i_f.set_sel_to(1);
    i_f.test_b_greater_than_a(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_MUL_RANDOM

    initial begin
    i_f.set_sel_to(0);
    i_f.test_mul_random(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_DIV_RANDOM

    initial begin
    i_f.set_sel_to(1);
    i_f.test_div_random(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_ZERO_RANDOM_MUL_DIV

    initial begin 
    i_f.set_sel_to(0);    
    i_f.test_mul_zero(NUM_SPCFC_TESTS, 0, 1);
    i_f.test_mul_zero(NUM_SPCFC_TESTS, 1, 0);
    //i_f.set_sel_to(1);
    //i_f.test_div_zero(200, 0, 1);
    //i_f.test_div_zero(200, 1, 0);
    $finish;
    end

    `endif

    `ifdef TEST_DIRECT

    initial begin
    i_f.test_direct(8'hFF, 8'hFF, 0);
    $finish;
    end

    `endif

    `ifdef TEST_MUL_INFINITY 
    
    initial begin
    i_f.set_sel_to(0);
    i_f.test_infinity(NUM_SPCFC_TESTS, 0);
    i_f.test_infinity(NUM_SPCFC_TESTS, 1);
    i_f.test_infinity(NUM_SPCFC_TESTS, 2);
    $finish;
    end

    `endif

    `ifdef TEST_DIV_INFINITY 
    
    initial begin
    i_f.set_sel_to(1);
    i_f.test_infinity(NUM_SPCFC_TESTS, 0);
    i_f.test_infinity(NUM_SPCFC_TESTS, 1);
    i_f.test_infinity(NUM_SPCFC_TESTS, 2);
    $finish;
    end

    `endif

    `ifdef TEST_MUL_NAN

    initial begin
    i_f.set_sel_to(0);
    i_f.test_nan(NUM_SPCFC_TESTS, 0);
    i_f.test_nan(NUM_SPCFC_TESTS, 1);
    i_f.test_nan(NUM_SPCFC_TESTS, 2);
    $finish;
    end

    `endif

    `ifdef TEST_DIV_NAN

    initial begin
    i_f.set_sel_to(1);
    i_f.test_nan(NUM_SPCFC_TESTS, 0);
    i_f.test_nan(NUM_SPCFC_TESTS, 1);
    i_f.test_nan(NUM_SPCFC_TESTS, 2);
    $finish;
    end

    `endif

    `ifdef TEST_RESET_RANDOM

    initial begin
    i_f.test_reset_random(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_RESET_TIMED

    initial begin
    i_f.test_reset_timed(NUM_RNDM_TESTS);
    $finish;
    end

    `endif

    `ifdef TEST_MAX_MID_MIN_VALUE

    initial begin

    i_f.test_direct(POS_MAX_VAL, POS_MAX_VAL, 0);
    i_f.test_direct(POS_MAX_VAL, POS_MAX_VAL, 1);
    i_f.test_direct(NEG_MAX_VAL, NEG_MAX_VAL, 0);
    i_f.test_direct(NEG_MAX_VAL, NEG_MAX_VAL, 1);

    i_f.test_direct(POS_MIN_VAL, POS_MIN_VAL, 0);
    i_f.test_direct(POS_MIN_VAL, POS_MIN_VAL, 1);
    i_f.test_direct(NEG_MIN_VAL, NEG_MIN_VAL, 0);
    i_f.test_direct(NEG_MIN_VAL, NEG_MIN_VAL, 1);
    $finish;
    end

    `endif   


endmodule

