clear -all

#

# Flags
analyze -sv ../rtl/flags_block.v

# Exceptions
analyze -sv ../rtl/exception_block.v

# Mul Div
analyze -sv ../rtl/rounding.v
analyze -sv ../rtl/normalizer.v
analyze -sv ../rtl/mantissa_divider.v
analyze -sv ../rtl/sum1b.v
analyze -sv ../rtl/mul1b.v
analyze -sv ../rtl/step.v
analyze -sv ../rtl/flipflop.v
analyze -sv ../rtl/shift.v
analyze -sv ../rtl/parallel_shift.v
analyze -sv ../rtl/mul.v
analyze -sv ../rtl/exponent_logic.v
analyze -sv ../rtl/sign_logic_muldiv.v
analyze -sv ../rtl/mul_div.v
 
# Add Sub
analyze -sv ../rtl/normalize_rounder.v
analyze -sv ../rtl/mantissa_add_sub.v
analyze -sv ../rtl/mantissa_shifter.v 
analyze -sv ../rtl/exponent_sub_upd.v
analyze -sv ../rtl/sign_logic.v
analyze -sv ../rtl/add_sub_main.v

# Top
analyze -sv ../rtl/FPU.v

# FV
analyze -sv fv_FPU.sv

#
elaborate -bbox_a 65535 -bbox_mul 65535 -top FPU

clock clk

reset -expression arst
set_engineJ_max_trace_length 5000
