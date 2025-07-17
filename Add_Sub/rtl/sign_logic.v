module sign_logic #(parameter WIDTH = 32)(
    input bit sign_a, sign_b,
    input [22:0] mantissa_a, mantissa_b,
    input [7:0] exp_a, exp_b,
    input operation_select,
    //input bit clk,
    output reg result,
    output sign_r
    );
    
    wire def1_1;
    wire sign_x, sign_y;
    
    assign sign_x = sign_a;
    assign sign_y = sign_b;

    assign sign = operation_select ? sign_y : ~sign_y;
    
    assign def1_1 = (mantissa_a > mantissa_b) ? sign_x : (mantissa_a < mantissa_b) ? sign : (sign_x ~^ sign);
    assign sign_r = (exp_a > exp_b) ? sign_x : (exp_a < exp_b) ? sign : def1_1;

endmodule
