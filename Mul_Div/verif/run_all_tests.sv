module run_all_tests();

    bit clk;
    mul_div_if #() i_f(clk);  // Interface instance


    parameter int NUM_RNDM_TESTS = 100;
    parameter int NUM_SPCFC_TESTS = 50;

    parameter int NEG_MIN_VAL = 32'h80800000;
    parameter int POS_MIN_VAL = 32'h00800000;
    parameter int POS_MAX_VAL = 32'h7F7FFFFF;
    parameter int NEG_MAX_VAL = 32'hFF7FFFFF;
    parameter int POS_INF_VAL = 32'h7F800000;
    parameter int NEG_INF_VAL = 32'hFF800000;

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

  
    initial begin
            // Run all tests

            //TEST_FULL_RANDOM
            i_f.test_full_random(NUM_RNDM_TESTS);
            
            //TEST_A_GREATER_THAN_B
            i_f.set_sel_to(0);
            i_f.test_a_greater_than_b(NUM_RNDM_TESTS);
            i_f.set_sel_to(1);
            i_f.test_a_greater_than_b(NUM_RNDM_TESTS);
            
            //TEST_B_GREATER_THAN_A
            i_f.set_sel_to(0);
            i_f.test_b_greater_than_a(NUM_RNDM_TESTS);
            i_f.set_sel_to(1);
            i_f.test_b_greater_than_a(NUM_RNDM_TESTS);
            
            //TEST_MUL_RANDOM
            i_f.set_sel_to(0);
            i_f.test_mul_random(NUM_RNDM_TESTS);
            
            //TEST_DIV_RANDOM
            i_f.set_sel_to(1);
            i_f.test_div_random(NUM_RNDM_TESTS);
            
            //TEST_ZERO_RANDOM_MUL_DIV
            i_f.set_sel_to(0);
            i_f.test_mul_zero(NUM_SPCFC_TESTS, 0, 1);
            i_f.test_mul_zero(NUM_SPCFC_TESTS, 1, 0);
            //i_f.set_sel_to(1);
            //i_f.test_div_zero(200, 0, 1);
            //i_f.test_div_zero(200, 1, 0);
            
            //TEST_DIRECT
            i_f.test_direct(8'hFF, 8'hFF, 0);
            
            //TEST_MUL_INFINITY
            i_f.set_sel_to(0);
            i_f.test_infinity(NUM_SPCFC_TESTS, 0);
            i_f.test_infinity(NUM_SPCFC_TESTS, 1);
            i_f.test_infinity(NUM_SPCFC_TESTS, 2);
            
            //TEST_DIV_INFINITY
            i_f.set_sel_to(1);
            i_f.test_infinity(NUM_SPCFC_TESTS, 0);
            i_f.test_infinity(NUM_SPCFC_TESTS, 1);
            i_f.test_infinity(NUM_SPCFC_TESTS, 2);
            
            //TEST_MUL_NAN
            i_f.set_sel_to(0);
            i_f.test_nan(NUM_SPCFC_TESTS, 0);
            i_f.test_nan(NUM_SPCFC_TESTS, 1);
            i_f.test_nan(NUM_SPCFC_TESTS, 2);
            
            //TEST_DIV_NAN
            i_f.set_sel_to(1);
            i_f.test_nan(NUM_SPCFC_TESTS, 0);
            i_f.test_nan(NUM_SPCFC_TESTS, 1);
            i_f.test_nan(NUM_SPCFC_TESTS, 2);
            
            //TEST_RESET_RANDOM
            i_f.test_reset_random(NUM_RNDM_TESTS);
            
            //TEST_RESET_TIMED
            i_f.test_reset_timed(NUM_RNDM_TESTS);
            
            //TEST_MAX_MID_MIN_VALUE
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


endmodule