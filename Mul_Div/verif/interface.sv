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
            exponent = {`ONE_BIT, 5'b00000, exp_rand};
            
            mant_rand = $urandom_range(0, 7);
            mantissa = {mant_rand, 20'b0};
            
            fp_num = {`ZERO_BIT, exponent, mantissa};
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
            a = `MID_VAl;
            b = `MID_VAl;
        end
    endtask
    
    
    ///BFM///
    
    //1 Function to set the value of the input "A" to zero
    function set_input_a_to_zero();
        a = `ZERO;
    endfunction
    
    //2 Function to set the value of the input "B" to zero
    function set_input_b_to_zero();
        b = `ZERO;
    endfunction    

    //3 Function to set the value of the input "A" and "B" to zero
    function set_input_a_and_b_zero();
        a = `ZERO;
        b = `ZERO;
    endfunction

    //4 Function to set the value of operation_select to a random value
    function set_operation_select_rdm();
        void'(std::randomize(operation_select));
    endfunction

    //5 Function to set the value of the input "A" to a random value
    function set_input_a_rdm();
        void'(std::randomize(a));
    endfunction

    //6 Function to set the value of the input "B" to a random value
    function set_input_b_rdm();
        void'(std::randomize(b));
    endfunction

    //7 Function to set the value of the input "A" to a random value and "B" to zero
    function set_input_a_rdm_and_b_zero();
        void'(std::randomize(a));
        b = `ZERO;
    endfunction

    //8 Function to set the value of the input "A" to zero and "B" to a random value
    function set_input_b_rdm_and_a_zero();
        a = `ZERO;
        void'(std::randomize(b));
    endfunction

    //9 Function to set the value of the input "A" and "B" to a random value
    function set_input_a_and_b_rdm();
        void'(std::randomize(a));
        void'(std::randomize(b));
    endfunction

    //10 Function to setthe value of the input "A" to Nan
    function set_input_a_to_nan();
        a = `NAN;
    endfunction

    //11 Function to set the value of the input "B" to Nan
    function set_input_b_to_nan();
        b = `NAN;
    endfunction

    //12 Function to set the value of the input "A" to positive inf
    function set_input_a_to_inf();
        a = `INF;
    endfunction

    //13 Function to set the value of the input "B" to positive inf
    function set_input_b_to_inf();
        b = `INF;
    endfunction

    //14 Function to set the value of the input "A" to negative inf
    function set_input_a_to_neg_inf();
        a = `NEG_INF;
    endfunction

    //15 Function to set the value of the input "B" to negative inf
    function set_input_b_to_neg_inf();
        b = `NEG_INF;
    endfunction

    //16 Function to set the input "A" to maximum positive value
    function set_input_a_max_pos();
        a = `MAX_POS;
    endfunction

    //17 Function to set the input "A" to maximum negative value
    function set_input_a_max_neg();
        a = `MAX_NEG;
    endfunction

    //18 Function to set the input "A" to minimum positive value "Normalized"
    function set_input_a_min_pos();
        a = `MIN_POS;
    endfunction

    //19 Function to set the input "A" to minimum positive value "Denormalized"
    function set_input_a_min_pos_denorm();
        a = `MIN_POS_DENORM;
    endfunction

    //20 Function to set the input "A" to minimum negative value "Normalized"
    function set_input_a_min_neg();
        a = `MIN_NEG;
    endfunction

    //21 Function to set the input "A" to minimum negative value "Denormalized"
    function set_input_a_min_neg_denorm();
        a = `MIN_NEG_DENORM;
    endfunction

    //22 Function to set the input "B" to maximum positive value
    function set_input_b_max_pos();
        b = `MAX_POS;
    endfunction

    //23 Function to set the input "B" to maximum negative value
    function set_input_b_max_neg();
        b = `MAX_NEG;
    endfunction

    //24 Function to set the input "B" to minimum positive value "Normalized"
    function set_input_b_min_pos();
        b = `MIN_POS;
    endfunction

    //25 Function to set the input "B" to minimum positive value "Denormalized"
    function set_input_b_min_pos_denorm();
        b = `MIN_POS_DENORM;
    endfunction

    //26 Function to set the input "B" to minimum negative value "Normalized"
    function set_input_b_min_neg();
        b = `MIN_NEG;
    endfunction

    //27 Function to set the input "B" to minimum negative value "Denormalized"
    function set_input_b_min_neg_denorm();
        b = `MIN_NEG_DENORM;
    endfunction

    //28 Function used to randomize both inputs (A,B) where A is greater than B.
    function randomize_inputs_a_greater_than_b();
        void'(std::randomize(a, b) with {a > b;});
    endfunction

    //29 Function used to randomize both inputs (A,B) where A is less than B.
    function randomize_inputs_a_less_than_b();
        void'(std::randomize(a, b) with {a < b;});
    endfunction

    //30 Function used to set the value of input A to a specific value.
    function set_input_a_to_specific_value(bit [WIDTH-1:0] value);
        a = value;
    endfunction

    //31 Function used to set the value of input B to a specific value.
    function set_input_b_to_specific_value(bit [WIDTH-1:0] value);
        b = value;
    endfunction

endinterface 
