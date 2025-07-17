interface add_sub_main_if #(parameter WIDTH = 32, EXP_BITS = 8, MANT_BITS = 23);
    bit  [WIDTH-1:0] a,b;
    bit operation_select;
    bit clk;
    logic [WIDTH-1:0] result;
    logic sign_a, sign_b, sign_result;
    logic [MANT_BITS-1:0] mantissa_a, mantissa_b, mantissa_result;
    logic [EXP_BITS-1:0] exp_a, exp_b, exp_result;
    
    task automatic generate_custom_fp(output bit [31:0] fp_num);
        bit [7:0] exponent;
        bit [22:0] mantissa;
        bit [1:0] exp_rand;
        bit [2:0] mant_rand;
        begin
            exp_rand = $urandom_range(0, 3);
            exponent = {1'b1, 5'b00000, exp_rand};
            
            mant_rand = $urandom_range(0, 7);
            mantissa = {mant_rand, 20'b0};
            
            fp_num = {1'b0, exponent, mantissa};
        end
    endtask

    task task_generate_random_stimul();
        bit [31:0] temp;
        begin
            generate_custom_fp(temp);
            a = temp;
            generate_custom_fp(temp);
            b = temp;
        end
    endtask
    
    task task_generate_fixed_stimul();
        begin
            a = 32'h3f800000;
            b = 32'h3f800000;
        end
    endtask
    
    
    ///BFM///

    // Function to set the value of the input "A" to zero
    function set_input_A_to_zero();
        a = 0;
    endfunction
    
    // Function to set the value of the input "B" to zero
    function set_input_B_to_zero();
        b = 0;
    endfunction    

    // Function to set the value of the input "A" and "B" to zero
    function set_input_a_and_b_zero();
        a = 0;
        b = 0;
    endfunction

    //Function to set the value of operation_select to a random value
    function set_operation_select_rdm();
        std::randomize(operation_select);
    endfunction

    //Function to set the value of the input "A" to a random value
    function set_input_a_rdm();
        std::randomize(a);
    endfunction

    //Function to set the value of the input "B" to a random value
    function set_input_b_rdm();
        std::randomize(b);
    endfunction

    // Function to set the value of the input "A" to a random value and "B" to zero
    function set_input_a_rdm_and_b_zero();
        std::randomize(a);
        b = 0;
    endfunction

    // Function to set the value of the input "A" to zero and "B" to a random value
    function set_input_b_rdm_and_a_zero();
        a = 0;
        std::randomize(b);
    endfunction

    // Function to set the value of the input "A" and "B" to a random value
    function set_input_a_and_b_rdm();
        std::randomize(a);
        std::randomize(b);
    endfunction

    //Function to set the input "A" to maximum positive value
    function set_input_a_max_pos();
        a[31] = 0;
        a[30:23] = 254;
        a[22:0] = '1;
    endfunction

    //Function to set the input "A" to minimum positive value
    /*
    function set_input_a_min_pos();
        a[31] = 0;
        a[30:23] = 1';
        a[22:0] = '0';
    endfunction
*/
    //Function to set the input "A" to maximum negative value
    function set_input_a_max_neg();
        a[31] = 1;
        a[30:23] = 254;
        a[22:0] = '1;
    endfunction

    //Function to set the input "A" to minimum negative value "Normalized"
    function set_input_a_min_neg();
        a[31] = 1;
        a[30:23] = 1;
        a[22:0] = '0;
    endfunction

    //Function to set the input "A" to minimum negative value "Denormalized"
    function set_input_a_min_neg_denorm();
        a[31] = 1;
        a[30:23] = '0;
        a[22:0] = 1;
    endfunction

    //Function to set the input "B" to maximum positive value   
    function set_input_b_max_pos();
        b[31] = 0;
        b[30:23] = 254;
        b[22:0] = '1;
    endfunction

    //Function to set the input "B" to minimum positive value "Normalized"
    function set_input_b_min_pos();
        b[31] = 0;
        b[30:23] = 1;
        b[22:0] = '0;
    endfunction

    //Function to set the input "B" to minimum positive value "Denormalized"
    function set_input_b_min_pos_denorm();
        b[31] = 0;
        b[30:23] = '0;
        b[22:0] = 1;
    endfunction

    //Function to set the input "B" to maximum negative value
    function set_input_b_max_neg();
        b[31] = 1;
        b[30:23] = 254;
        b[22:0] = '1;
    endfunction

    //Function to set the input "B" to minimum negative value "Normalized"
    function set_input_b_min_neg();
        b[31] = 1;
        b[30:23] = 1;
        b[22:0] = '0;    
    endfunction

    //Function to set the input "A" and "B" to maximum positive value
    function set_input_a_and_b_max_pos();
        a[31] = 0;
        a[30:23] = 254;
        a[22:0] = '1;
        b[31] = 0;
        b[30:23] = 254;
        b[22:0] = '1;
    endfunction

    //Function to set the input "A" and "B" to minimum positive value "Normalized"
    function set_input_a_and_b_min_pos();
        a[31] = 0;
        a[30:23] = 1;
        a[22:0] = '0;
        b[31] = 0;
        b[30:23] = 1;
        b[22:0] = '0;
    endfunction

    //Function to set the input "A" and "B" to minimum positive value "Denormalized"
    function set_input_a_and_b_min_pos_denorm();
        a[31] = 0;
        a[30:23] = '0;
        a[22:0] = 1;
        b[31] = 0;
        b[30:23] = '0;
        b[22:0] = 1;
    endfunction

    //Function to set the input "A" and "B" to maximum negative value
    function set_input_a_and_b_max_neg();
        a[31] = 1;
        a[30:23] = 254;
        a[22:0] = '1;
        b[31] = 1;
        b[30:23] = 254;
        b[22:0] = '1;
    endfunction

    //Function to set the input "A" and "B" to minimum negative value "Normalized"
    function set_input_a_and_b_min_neg();
        a[31] = 1;
        a[30:23] = 1;
        a[22:0] = '0;
        b[31] = 1;
        b[30:23] = 1;
        b[22:0] = '0;
    endfunction

    //Function to set the input "A" and "B" to minimum negative value "Denormalized"
    function set_input_a_and_b_min_neg_denorm();
        a[31] = 1;
        a[30:23] = '0;
        a[22:0] = 1;
        b[31] = 1;
        b[30:23] = '0;
        b[22:0] = 1;
    endfunction
/*
    // Function to randomize input B with values > MIDDLE_VALUE and randomize input A with values > B
    function randomize_inputs_a_and_b_overflow();
        std::randomize(a, b) with {b > MID_VAl; a > b;};
    endfunction

    // Function to randomize input A with values > MIDDLE_VALUE and randomize input B with values > B
    function randomize_inputs_b_and_a_overflow();
        std::randomize(a, b) with {a > MID_VAl; b > a;};
    endfunction
*/
    //Function used to randomize both inputs (A,B) where A is greater than B.
    function randomize_inputs_a_greater_than_b();
        std::randomize(a, b) with {a > b;};
    endfunction

    //Function used to randomize both inputs (A,B) where A is less than B.
    function randomize_inputs_a_less_than_b();
        std::randomize(a, b) with {a < b;};
    endfunction

    //Function used to set the value of input A to a specific value.
    function set_input_a_to_specific_value(bit [WIDTH-1:0] value);
        a = value;
    endfunction

    //Function used to set the value of input B to a specific value.
    function set_input_b_to_specific_value(bit [WIDTH-1:0] value);
        b = value;
    endfunction



endinterface 
