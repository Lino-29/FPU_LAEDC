interface FPU_interface (input logic clk);
  logic [31:0] A, B;
  logic [1:0] op; 
	logic en; 
  logic [31:0] Z;
  logic [4:0] flags;
	bit arst;  
 
  parameter [31:0] INF_POS = 32'h7F800000;
  parameter [31:0] INF_NEG = 32'hFF800000;
  parameter [31:0] CAN_NAN = 32'h7FC00000; 
  parameter [31:0] ZERO = 32'h00000000;

  parameter SUB = 2'b00; // Subtraction
  parameter ADD = 2'b01; // Addition
  parameter MUL = 2'b10; // Multiplication
  parameter DIV = 2'b11; // Division

//////////////////////////////////////////// BFM //////////////////////////////////////////////

  function automatic set_arst_to(input int value);
  arst = value;
  endfunction
  
  function automatic randomize_arst();
  std::randomize(arst);
  endfunction

  function automatic randomize_normal_a();
    bit [31:0] temp;
    std::randomize(temp);
    A = {1'b0, temp[30:23] != 8'hFF ? temp[30:23] : 8'hFE, temp[22:0]};
  endfunction

  function automatic randomize_normal_b();
    bit [31:0] temp;
    std::randomize(temp);
    B = {1'b0, temp[30:23] != 8'hFF ? temp[30:23] : 8'hFE, temp[22:0]};
  endfunction
/*
  function automatic randomize_normal_a();
    bit [31:0] temp;
    std::randomize(temp);
    A = {1'b0, temp[30:23] >= 8'h80 ? temp[30:23] : 8'h80, temp[22:0]};
  endfunction

  function automatic randomize_normal_b();
    bit [31:0] temp;
    std::randomize(temp);
    B = {1'b0, temp[30:23] >= 8'h80 ? temp[30:23] : 8'h80, temp[22:0]};
  endfunction
*/

  function automatic randomize_normal_a_greater_b(); 
    bit [31:0] temp_a, temp_b;
    real real_a, real_b;
    do begin
      std::randomize(temp_a);
      std::randomize(temp_b);
      A = {1'b0, temp_a[30:23] != 8'hFF ? temp_a[30:23] : 8'hFE, temp_a[22:0]};
      B = {1'b0, temp_b[30:23] != 8'hFF ? temp_b[30:23] : 8'hFE, temp_b[22:0]};
      real_a = $bitstoreal(A);
      real_b = $bitstoreal(B);
    end while (real_a > real_b);
  endfunction

  function automatic randomize_normal_b_greater_a(); 
    bit [31:0] temp_a, temp_b;
    real real_a, real_b;
    do begin
      std::randomize(temp_a);
      std::randomize(temp_b);
      A = {1'b0, temp_a[30:23] != 8'hFF ? temp_a[30:23] : 8'hFE, temp_a[22:0]};
      B = {1'b0, temp_b[30:23] != 8'hFF ? temp_b[30:23] : 8'hFE, temp_b[22:0]};
      real_a = $bitstoreal(A);
      real_b = $bitstoreal(B);
    end while (real_b > real_a);
  endfunction
  
  function automatic void set_a_to(input int value);
    real r; 
    r = $itor(value);
    $cast(A, r);
  endfunction

  function automatic void set_b_to(input int value);
    real r; 
    r = $itor(value);
    $cast(B, r);
  endfunction

  function automatic void set_a_to_infinite();
    A = INF_POS;
  endfunction

  function automatic void set_b_to_infinite();
    B = INF_NEG;
  endfunction


  function automatic void set_op_to(input int value);
    op = value;
  endfunction

  function automatic op_random();
  std::randomize(op);
  endfunction
  
  
  function automatic set_enable_to(input bit value);
  en = value;
  endfunction
  
  function automatic randomize_nan_a();
        bit [31:0] temp;
        std::randomize(temp);
        A = {1'b0, 8'hFF, temp[22:0]};
    endfunction

    function automatic randomize_nan_b();
        bit [31:0] temp;
        std::randomize(temp);
        B = {1'b0, 8'hFF, temp[22:0]};
    endfunction
  
////////////////////////////////////////////// TASKS FOR TESTS //////////////////////////////////////////////
  
  
  task automatic test_full_random(input int value);
    repeat (value)@(posedge clk)begin
    op_random();                                           // op_random
    randomize_normal_a();                                   // a_random
    randomize_normal_b();                                   // b_random
    end
  endtask
  
  task automatic test_a_greater_than_b(input int value);
    repeat (value)@(posedge clk)begin
    randomize_normal_a_greater_b(); 
    end
  endtask
  
  task automatic test_b_greater_than_a(input int value);
    repeat (value)@(posedge clk)begin
    randomize_normal_b_greater_a(); 
    end
  endtask

/////////////////////// RANDOM TESTS FOR EACH OPERATION ///////////////////////

  task automatic test_mul_random(input int value);
    repeat (value)@(posedge clk)begin
    op = MUL;
    randomize_normal_a(); 
    randomize_normal_b(); 
    end
  endtask

  task automatic test_div_random(input int value);
    repeat (value)@(posedge clk)begin
    op = DIV;
    randomize_normal_a(); 
    randomize_normal_b(); 
    end
  endtask
  
  task automatic test_sub_random(input int value);
    repeat (value)@(posedge clk)begin
    op = SUB;
    randomize_normal_a(); 
    randomize_normal_b(); 
    end
  endtask

  task automatic test_add_random(input int value);
    repeat (value)@(posedge clk)begin
    op = ADD;
    randomize_normal_a(); 
    randomize_normal_b(); 
    end
  endtask

//////////////////////// TESTS FOR EACH OPERATION WITH ZERO ///////////////////////

  task automatic test_mul_zero(input int value, input bit randomize_a, input bit randomize_b);
    repeat (value)@(posedge clk) begin
        op = MUL;
        if (randomize_a) begin
            randomize_normal_a();
        end else begin
            set_a_to(0);
        end
        if (randomize_b) begin
            randomize_normal_b();
        end else begin
            set_b_to(0);
        end
    end
  endtask

  task automatic test_div_zero(input int value, input bit randomize_a, input bit randomize_b);
    repeat (value)@(posedge clk) begin
        op = DIV;
        if (randomize_a) begin
            randomize_normal_a();
        end else begin
            set_a_to(0);
        end
        if (randomize_b) begin
            randomize_normal_b();
        end else begin
            set_b_to(0);
        end
    end
  endtask

  task automatic test_add_zero(input int value, input bit randomize_a, input bit randomize_b);
    repeat (value)@(posedge clk) begin
        op = ADD;
        if (randomize_a) begin
            randomize_normal_a();
        end else begin
            set_a_to(0);
        end
        if (randomize_b) begin
            randomize_normal_b();
        end else begin
            set_b_to(0);
        end
    end
  endtask

  task automatic test_sub_zero(input int value, input bit randomize_a, input bit randomize_b);
    repeat (value)@(posedge clk) begin
        op = SUB;
        if (randomize_a) begin
            randomize_normal_a();
        end else begin
            set_a_to(0);
        end
        if (randomize_b) begin
            randomize_normal_b();
        end else begin
            set_b_to(0);
        end
    end
  endtask

  // Task to set A, B and op values directly 

  task automatic test_direct(input int a_value, input int b_value, input logic op_value);
    begin
        op = op_value;
        set_a_to(a_value);
        set_b_to(b_value);
    end
endtask


////////////////////////////////////////// TESTS FOR INFINITE ///////////////////////////////////////
  task automatic test_positive_infinity(input int value, input int a_b_both);
    repeat (value)@(posedge clk) begin
        op_random();
        if (a_b_both == 2) begin
            set_a_to(INF_POS);
            set_b_to(INF_POS);
            randomize_normal_b();
        end else if (a_b_both == 1) begin
            set_a_to(INF_POS);
            randomize_normal_b();
        end else begin
            set_b_to(INF_POS);
            randomize_normal_a();
        end
    end
  endtask

  task automatic test_negative_infinity(input int value, input int a_b_both);
    repeat (value)@(posedge clk) begin
        op_random();
        if (a_b_both == 2) begin
            set_a_to(INF_NEG);
            set_b_to(INF_NEG);
            randomize_normal_b();
        end else if (a_b_both == 1) begin
            set_a_to(INF_NEG);
            randomize_normal_b();
        end else begin
            set_b_to(INF_NEG);
            randomize_normal_a();
        end
    end
  endtask

  task automatic test_nan(input int value, input int a_b_both);
        repeat (value)@(posedge clk) begin
            if (a_b_both == 2) begin
                randomize_nan_a();
                randomize_nan_b();
            end else if (a_b_both == 1) begin
                randomize_nan_a();
                randomize_normal_b();
            end else begin
                randomize_nan_b();
                randomize_normal_a();
            end
        end
  endtask

  task automatic test_reset_random(input int value);
    repeat (value)@(posedge clk)begin
    randomize_normal_a();
    randomize_normal_b();
    repeat(10)@(posedge clk)begin
      randomize_arst();
      end
    end
  endtask

  task automatic test_reset_timed(input int value);
    repeat (value)@(posedge clk)begin
    randomize_normal_a();
    randomize_normal_b();
    repeat(10)@(posedge clk);
    repeat(2)@(posedge clk)begin
      set_arst_to(1);
    end
    set_arst_to(0);
    end
  endtask


endinterface
