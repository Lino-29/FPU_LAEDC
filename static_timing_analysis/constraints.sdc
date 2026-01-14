###################################################################

# Created by write_sdc on Mon Oct  6 11:11:36 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance 1.000000e+04kOhm -capacitance 1.000000e-04pF    \
-voltage V -current uA
set_load -pin_load 0.04 [get_ports {result_reg[2]}]
set_load -pin_load 0.04 [get_ports {result_reg[1]}]
set_load -pin_load 0.04 [get_ports {result_reg[0]}]
create_clock [get_ports clk]  -period 10  -waveform {0 5}
set_clock_latency 0.3  [get_clocks clk]
set_clock_latency -source 0.5  [get_clocks clk]
set_clock_uncertainty -setup 1  [get_clocks clk]
set_clock_transition -min -fall 1 [get_clocks clk]
set_clock_transition -min -rise 1 [get_clocks clk]
set_clock_transition -max -fall 1 [get_clocks clk]
set_clock_transition -max -rise 1 [get_clocks clk]
set_input_delay -clock clk  -max 4  [get_ports {a[2]}]
set_input_delay -clock clk  -max 4  [get_ports {a[1]}]
set_input_delay -clock clk  -max 4  [get_ports {a[0]}]
set_input_delay -clock clk  -max 4  [get_ports {b[2]}]
set_input_delay -clock clk  -max 4  [get_ports {b[1]}]
set_input_delay -clock clk  -max 4  [get_ports {b[0]}]
set_input_delay -clock clk  -max 4  [get_ports {op[1]}]
set_input_delay -clock clk  -max 4  [get_ports {op[0]}]
set_input_delay -clock clk  -max 4  [get_ports arst_n]
set_input_delay -clock clk  -max 4  [get_ports wr_en]
set_output_delay -clock clk  -max 5  [get_ports {result_reg[2]}]
set_output_delay -clock clk  -max 5  [get_ports {result_reg[1]}]
set_output_delay -clock clk  -max 5  [get_ports {result_reg[0]}]
set_input_transition -max 1  [get_ports {a[2]}]
set_input_transition -min 0.1  [get_ports {a[2]}]
set_input_transition -max 1  [get_ports {a[1]}]
set_input_transition -min 0.1  [get_ports {a[1]}]
set_input_transition -max 1  [get_ports {a[0]}]
set_input_transition -min 0.1  [get_ports {a[0]}]
set_input_transition -max 1  [get_ports {b[2]}]
set_input_transition -min 0.1  [get_ports {b[2]}]
set_input_transition -max 1  [get_ports {b[1]}]
set_input_transition -min 0.1  [get_ports {b[1]}]
set_input_transition -max 1  [get_ports {b[0]}]
set_input_transition -min 0.1  [get_ports {b[0]}]
set_input_transition -max 1  [get_ports {op[1]}]
set_input_transition -min 0.1  [get_ports {op[1]}]
set_input_transition -max 1  [get_ports {op[0]}]
set_input_transition -min 0.1  [get_ports {op[0]}]
set_input_transition -max 1  [get_ports arst_n]
set_input_transition -min 0.1  [get_ports arst_n]
set_input_transition -max 1  [get_ports wr_en]
set_input_transition -min 0.1  [get_ports wr_en]
