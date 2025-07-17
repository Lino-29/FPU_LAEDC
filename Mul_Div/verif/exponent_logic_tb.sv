module exponent_Logic_tb;

exponent_Logic_inf exponent_Logic_inf_i();

    bit clk;
    
exponent_logic DUT(
 
    .e_a(exponent_Logic_inf_i.e_a), 
    .e_b(exponent_Logic_inf_i.e_b),
    .clk(exponent_Logic_inf_i.clk), 
    .arst(exponent_Logic_inf_i.arst), 
    .en(exponent_Logic_inf_i.en), 
    .sel(exponent_Logic_inf_i.sel),
    .e(exponent_Logic_inf_i.e) 
);

    always #1 clk = ~clk;    

    //`define TEST1
    `define TEST2    
    //`define TEST3

    `ifdef TEST1
        // Prueba 1 - 
        //////////////////////////////////////////////
        // 1. Generar entradas aleatorias con       //
        // en 1 y sel 0; en = 1, sel = 1            //
        //////////////////////////////////////////////
        initial begin
            repeat(500) begin
                @(posedge clk); 
                exponent_Logic_inf_i.radmon_inputs_enabled_sel_0();          
            end
            repeat(500) begin
                @(posedge clk); 
                exponent_Logic_inf_i.radmon_inputs_enabled_sel_1();          
            end
                #2 $finish;   
        end       
    `endif

    `ifdef TEST2
    // Prueba 1 - 
    //////////////////////////////////////////////
    // 1. Generar entradas ale_atorias           //
    // e incorpora un resteo                    //
    //////////////////////////////////////////////
        initial begin
            repeat(200) begin
                @(posedge clk); 
                exponent_Logic_inf_i.radmon_inputs();          
            end
            exponent_Logic_inf_i.arst = 1;
            #5 exponent_Logic_inf_i.arst = 0;
            repeat(100) begin
                @(posedge clk); 
                exponent_Logic_inf_i.radmon_inputs();          
            end
            exponent_Logic_inf_i.arst = 1;
            #3 exponent_Logic_inf_i.arst = 0;            
            repeat(200) begin
                @(posedge clk); 
                exponent_Logic_inf_i.radmon_inputs();          
            end            
                #2 $finish;   
        end   
    `endif  
    
    
endmodule

interface exponent_Logic_inf ();

    logic [7:0] e_a, e_b;
    logic arst, en, sel; // Deleted clk
    logic [9:0] e;
    bit clk;

    //always #1 clk = ~clk; 
       
    initial begin
    e_a = 0;
    e_b = 0;
    clk = 0;
    e = 0;
    en = 0;
    sel = 0;
    end
    
    function radmon_inputs_enabled_sel_0();
        en=1;
        sel=0;
        std::randomize(e_a);
        std::randomize(e_b);    
    endfunction
 
     function radmon_inputs_enabled_sel_1();
        en=1;
        sel=1;
        std::randomize(e_a);
        std::randomize(e_b);    
    endfunction
       
    function radmon_inputs();
        std::randomize(en);
        std::randomize(sel);
        std::randomize(e_a);
        std::randomize(e_b);    
    endfunction
    
endinterface: exponent_Logic_inf
