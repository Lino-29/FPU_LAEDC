`define CREATE_COVERGROUPS(in_a, in_b) \
    covergroup cg_a; \
    option.per_instance = 1; \
        cp_a_sign : coverpoint in_a[31] { \
            bins range[] = {[0:1]}; \
        } \
        cp_a_exp : coverpoint in_a[30:23] { \
            bins range[] = {[0:$]}; \
        } \
        cp_a_man : coverpoint in_a[22:0] { \
            bins range[] = {[0:$]}; \
        } \
        cross cp_a_sign, cp_a_exp, cp_a_man; \
    endgroup \
    covergroup cg_b; \
    option.per_instance = 1; \
        cp_b_sign : coverpoint in_b[31] { \
            bins range[] = {[0:1]}; \
        } \
        cp_b_exp : coverpoint in_b[30:23] { \
            bins range[] = {[0:$]}; \
        } \
        cp_b_man : coverpoint in_b[22:0] { \
            bins range[] = {[0:$]}; \
        } \
        cross cp_b_sign, cp_b_exp, cp_b_man; \
    endgroup \

`define SAMPLING_COVERGROUPS \
    cg_a cg_a_inst = new(); \
    cg_b cg_b_inst = new(); \
    initial begin \
        forever begin \
            @(posedge clk); \
            cg_a_inst.sample(); \
            cg_b_inst.sample(); \
        end \
    end \



