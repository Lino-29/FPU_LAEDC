


interface mul_div_if (input logic clk);
    logic [31:0] a, b;
    logic arst, en, sel;
    logic [31:0] R;
    logic io_flag, dz_flag, of_flag, uf_flag, i_flag;
    
    initial begin
        arst = '1;
        sel = '0;
        a = '0;
        b = '0;
        en = '1;
        #77;
        arst = 0;
    end
    
  parameter [31:0] INF = 32'h7F800000;
  parameter [31:0] ZERO = 32'h00000000;
  parameter [31:0] ONE = 32'h3F800000;


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
    a = {1'b0, temp[30:23] != 8'hFF ? temp[30:23] : 8'hFE, temp[22:0]};
  endfunction

  function automatic randomize_normal_b();
    bit [31:0] temp;
    std::randomize(temp);
    b = {1'b0, temp[30:23] != 8'hFF ? temp[30:23] : 8'hFE, temp[22:0]};
  endfunction
  
  function automatic randomize_normal_a_greater_b(); 
    bit [31:0] temp_a, temp_b;
    real real_a, real_b;
    do begin
      std::randomize(temp_a);
      std::randomize(temp_b);
      a = {1'b0, temp_a[30:23] != 8'hFF ? temp_a[30:23] : 8'hFE, temp_a[22:0]};
      b = {1'b0, temp_b[30:23] != 8'hFF ? temp_b[30:23] : 8'hFE, temp_b[22:0]};
      real_a = $bitstoreal(a);
      real_b = $bitstoreal(b);
    end while (real_a > real_b);
  endfunction

  function automatic randomize_normal_b_greater_a(); 
    bit [31:0] temp_a, temp_b;
    real real_a, real_b;
    do begin
      std::randomize(temp_a);
      std::randomize(temp_b);
      a = {1'b0, temp_a[30:23] != 8'hFF ? temp_a[30:23] : 8'hFE, temp_a[22:0]};
      b = {1'b0, temp_b[30:23] != 8'hFF ? temp_b[30:23] : 8'hFE, temp_b[22:0]};
      real_a = $bitstoreal(a);
      real_b = $bitstoreal(b);
    end while (real_b > real_a);
  endfunction
  
  function automatic void set_a_to(input int value);
    real r; 
    r = $itor(value);
    $cast(a, r);
  endfunction

  function automatic void set_b_to(input int value);
    real r; 
    r = $itor(value);
    $cast(b, r);
  endfunction

  function automatic void set_a_to_infinite();
    a = 32'h7F800000;
  endfunction

  function automatic void set_b_to_infinite();
    b = 32'h7F800000;
  endfunction


  function automatic void set_sel_to(input int value);
    sel = value;
  endfunction

  function automatic sel_random();
  std::randomize(sel);
  endfunction
  
  
  function automatic set_enable_to(input int value);
  en = value;
  endfunction
  
  function automatic randomize_nan_a();
        bit [31:0] temp;
        std::randomize(temp);
        a = {1'b0, 8'hFF, temp[22:0]};
    endfunction

    function automatic randomize_nan_b();
        bit [31:0] temp;
        std::randomize(temp);
        b = {1'b0, 8'hFF, temp[22:0]};
    endfunction
  
////////////////////////////////////////////// TASKS FOR TESTS //////////////////////////////////////////////
  
  
  task automatic test_full_random(input int value);
    repeat (value)@(posedge clk)begin
    sel_random();                                           // sel_random
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

  task automatic test_mul_random(input int value);
    repeat (value)@(posedge clk)begin
    sel = 0;
    randomize_normal_a(); 
    randomize_normal_b(); 
    end
  endtask

  task automatic test_div_random(input int value);
    repeat (value)@(posedge clk)begin
    sel = 1;
    randomize_normal_a(); 
    randomize_normal_b(); 
    end
  endtask
  
  task automatic test_mul_zero(input int value, input bit randomize_a, input bit randomize_b);
    repeat (value)@(posedge clk) begin
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

task automatic test_direct(input int a_value, input int b_value, input bit sel_value);
    begin   
        sel = sel_value;
        set_a_to(a_value);
        set_b_to(b_value);
    end
endtask

  task automatic test_infinity(input int value, input int a_b_both);
    repeat (value)@(posedge clk) begin
        if (a_b_both == 2) begin
            set_a_to(INF);
            set_b_to(INF);
            randomize_normal_b();
        end else if (a_b_both == 1) begin
            set_a_to(INF);
            randomize_normal_b();
        end else begin
            set_b_to(INF);
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