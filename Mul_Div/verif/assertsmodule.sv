module assertsmodule #(parameter R_DLY = 23) (
    logic clk,
    logic [31:0] a, b,
    logic arst, en, sel,
    logic [31:0] R,
    logic io_flag, dz_flag, of_flag, uf_flag, i_flag
    );

    logic [22:0] expected_mantissa;
    logic is_subnormal_result;

    /****************************** special operators **************************************/

    property check_div_b_0;
        @(posedge clk) disable iff (arst) 
        ((b[30:0] == 31'b0) && (sel == 1)) |-> ##R_DLY (dz_flag == 1);
    endproperty
    assert property (check_div_b_0) 
    else begin
        $error("The division zero flag should have been 1");
    end

    property check_div_a_0;
        @(posedge clk) disable iff (arst)
        ((a[30:0] == 31'b0) && (sel == 1)) |-> ##R_DLY (R == 31'h0);
    endproperty
    assert property (check_div_a_0) 
    else begin
        $error("The division result should have been 0");
    end

    property check_div_b_1;
        @(posedge clk) disable iff (arst)
        ((b == 32'hF800000 && sel == 1)) |-> ##R_DLY (R == a);
    endproperty
    assert property (check_div_b_1) 
    else begin
        $error("The division result should have been a");
    end

    property check_div_a_eq_b;
        @(posedge clk) disable iff (arst)
        ((a == b) && (sel == 1)) |-> ##R_DLY (R == 32'h3f800000);
    endproperty
    assert property (check_div_a_eq_b) 
    else begin
        $error("The division result should have been 1");
    end

    property check_invalid_operation;
        @(posedge clk) disable iff (arst)
        ((a[31:0] > 31'h7f7fffff) || (b[31:0] > 31'h7f7fffff) || (a[31:0] < 31'h80000000) || (b[31:0] < 31'h80000000)) 
            |-> ##R_DLY (io_flag == 1);
    endproperty
    assert property (check_invalid_operation) 
    else begin
        $error("The flag doesn't arise when a Nan or Infinite number appears on the inputs");
    end

    /************************Over/underflow flags **************************************/

    property check_overflow_flag;
        @(posedge clk) disable iff (arst)
        ((R[30:23] == 8'd255) && R[22:0] != 23'h7fffff) |-> ##R_DLY (of_flag == 1);
    endproperty
    assert property (check_overflow_flag) 
    else begin
        $error("The flag doesn't arise when overflow happens");
    end

    property check_underflow_flag;
        @(posedge clk) disable iff (arst)
        ((R[30:23] == 8'd0) && R[22:0] != 23'h0) |-> ##R_DLY (uf_flag == 1);
    endproperty
    assert property (check_underflow_flag) 
    else begin
        $error("The flag doesn't arise when underflow happens");
    end

    /************************Exponent Block**************************************/

    property check_exponent_infinite;
        @(posedge clk) disable iff (arst)
        ((a[30:22] + b[30:22] > 9'd381) && (sel == 0)) |-> ##R_DLY (R == 32'h7f800000);
    endproperty
    assert property (check_exponent_infinite) 
    else begin
        $error("The result should be infinite");
    end

    property check_exponent_result_mult;
        @(posedge clk) disable iff (arst)
        ((a[30:22] + b[30:22] < 9'd382) && (sel == 0)) 
            |-> ##R_DLY (R[30:22] == (a[30:22] + b[30:22] - 8'd127));
    endproperty
    assert property (check_exponent_result_mult) 
    else begin
        $error("The exponent result is wrong"); 
    end

    property check_exponent_result_div;
        @(posedge clk) disable iff (arst)
        ((b[30:0] != 31'b0) && (sel == 1)) 
            |-> ##R_DLY (R[30:22] == a[30:22] - b[30:22] + 8'd127);
    endproperty
    assert property (check_exponent_result_div) 
    else begin
        $error("The exponent result is wrong");
    end

    property check_exponent_negative_infinite;
        @(posedge clk) disable iff (arst)
        ((a[30:22] - b[30:22] == 9'd0) && (R[22:0] < 23'h7ffffa)) |-> ##R_DLY (uf_flag == 1);
    endproperty
    assert property (check_exponent_negative_infinite) 
    else begin
        $error("Result should be zero");
    end
    /************************Mantissa Block**************************************/

    property p_mantissa_zero;
        @(posedge clk) disable iff (arst)
        (a[22:0] == 0 || b[22:0] == 0) |=> (R[22:0] == 0);
    endproperty
    assert property (p_mantissa_zero) 
    else $error("Error: Product must be zero when one input is zero");

    property p_mantissa_overflow;
        @(posedge clk) disable iff (arst)
        (a[22:0] != 0 && b[22:0] != 0) |=> (R[22:0] > 22'h0 && R[22:0] <= 22'h7FFFFF);
    endproperty
    assert property (p_mantissa_overflow) 
    else $error("Error: Mantissa overflow detected");

    property p_mantissa_normalization;
        @(posedge clk) disable iff (arst)
        (R[22] == 1) |=> ((R >> 1) == expected_mantissa);
    endproperty
    assert property (p_mantissa_normalization) 
    else $error("Error: Mantissa's incorrect normalization");

    property p_mantissa_denormal;
        @(posedge clk) disable iff (arst)
        (R < 22'h800000 && R > 0) |=> is_subnormal_result;
    endproperty
    assert property (p_mantissa_denormal) 
    else $error("Error: Product must be denormalized");

    property p_sign_correctness;
        @(posedge clk) disable iff (arst)
        (R[31] == (a[31] ^ b[31]));
    endproperty
    assert property (p_sign_correctness) 
    else $error("Error: Incorrect result sign");

    property check_div_result;
        @(posedge clk)(sel == 1) |-> (shortreal'(a) / shortreal'(b) == shortreal'(R));
    endproperty
    assert property (check_div_result)
    else begin
        $error("check_div_result: The divide operation is not correct. The result of the module is %0f and the expected result was %0f.", shortreal'(R), shortreal'(a) / shortreal'(b));
    end

endmodule
