`timescale 1ns/1ps
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

module tb_top;

    //clock
    bit clk;
    always #5 clk = !clk;

    initial begin
        $shm_open("shm_db");
        $shm_probe("ASMTR");
    end

    // Instanciar la interface
    add_sub_main_if #(.WIDTH(`WIDTH)) add_sub_main_if_inst();

    // Instancia del DUT
    add_sub_main #(.WIDTH(`WIDTH)) DUT(
        .a(add_sub_main_if_inst.a),
        .b(add_sub_main_if_inst.b),
        .operation_select(add_sub_main_if_inst.operation_select),
        .result(add_sub_main_if_inst.result),
        .clk(clk)
    );

    bind DUT add_sub_asserts asserts(
        .a(add_sub_main_if_inst.a),
        .b(add_sub_main_if_inst.b),
        .operation_select(add_sub_main_if_inst.operation_select),
        .result(add_sub_main_if_inst.result)
        //.clk(clk)
    );
    
    `CREATE_COVERGROUPS(add_sub_main_if_inst.a, add_sub_main_if_inst.b)
    `SAMPLING_COVERGROUPS

    //1
    `ifdef ADD_POS_AB
        initial begin
            repeat(`CICLES)@(posedge clk) begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a & (`EXP_MASK | `MANT_MASK);
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b & (`EXP_MASK | `MANT_MASK);
            end
            $finish;
        end
    `endif
    //2
    `ifdef ADD_NEG_AB
        initial begin
            repeat (`CICLES)@(posedge clk) begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a | `SIGN_MASK;
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b | `SIGN_MASK;
            end
            $finish;
        end
    `endif
    //5
    `ifdef ADD_INF_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_to_specific_value(`EXP_MASK);
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //6
    `ifdef ADD_INF_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_b_to_specific_value(`EXP_MASK);
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //7 Add when A and B are zeros
    `ifdef ADD_ZERO_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_to_zero();
            end
            $finish;
        end
    `endif
    //8 Add when A is zero and B is random
    `ifdef ADD_ZERO_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //9 Add when B is zero and A is random
    `ifdef ADD_ZERO_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_b_to_zero();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //10 A is maximum positive value and B is random
    `ifdef ADD_MAX_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_max_pos();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //11 Add when A is random and B is maximum positive value
    `ifdef ADD_MAX_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_b_max_pos();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //12 Add A and B with maximum positive value
    `ifdef ADD_MAX_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_max_pos();
                add_sub_main_if_inst.set_input_b_max_pos();
            end
            $finish;
        end
    `endif
    //13 Add when A and B are Nan
    `ifdef ADD_NAN_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_to_nan();
            end
            $finish;
        end
    `endif
    //14 Add when A is NaN and B is random
    `ifdef ADD_NAN_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_a_to_nan();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //15 Add when B is NaN and A is random
    `ifdef ADD_NAN_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `ADD_SEL;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //16
    `ifdef SUB_POS_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                //a_result_verif:assert ($shortrealtobits(expected_result) == add_sub_main_if_inst.result);
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a & (`EXP_MASK | `MANT_MASK);
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b & (`EXP_MASK | `MANT_MASK);
            end
            $finish;
        end
    `endif
    //17
    `ifdef SUB_NEG_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                //a_result_verif:assert ($shortrealtobits(expected_result) == add_sub_main_if_inst.result);
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a | `SIGN_MASK;
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b | `SIGN_MASK;
            end
            $finish;
        end
    `endif
    //20 Substraction when A and B are zeros
    `ifdef SUB_ZERO_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_to_zero();
            end
            $finish;
        end
    `endif
    //21 Substraction when A is zero and B is random
    `ifdef SUB_ZERO_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //22 Substraction when B is zero and A is random
    `ifdef SUB_ZERO_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_b_to_zero();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //23 Substraction when A is maximum negative value and B is random
    `ifdef SUB_MAX_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_a_max_neg();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //24 Substraction when A is random and B is maximum negative value
    `ifdef SUB_MAX_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_b_max_neg();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //25 Substraction when A and B are NaN
    `ifdef SUB_NAN_AB
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_to_nan();
            end
            $finish;
        end
    `endif
    //26 Substraction when A is NaN and B is random
    `ifdef SUB_NAN_A
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_a_to_nan();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //27 Substraction when B is NaN and A is random
    `ifdef SUB_NAN_B
        initial begin
            repeat (`CICLES)@(posedge clk)begin
                add_sub_main_if_inst.operation_select = `SUB_SEL;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif

endmodule
