
set ROOT [pwd]
set LIBDIR "$ROOT"
set RTL_LIST "rtl_list"          ;
set TOP     "FPU"                ;
set SDC     "./constraints.sdc"  ;

set_db lib_search_path  [list $LIBDIR]
set_db hdl_search_path  [list $ROOT]

set_db library [list \
  /home/chuy/FPU_LAEDC/static_timing_analysis/sky130_fd_sc_hd__ff_100C_1v65.lib \
]

set_db timing_disable_library_data_to_data_checks 0
set_db timing_disable_non_sequential_checks 0

read_hdl -f $RTL_LIST

elaborate 


read_sdc $SDC

# --- Síntesis ---
syn_generic
syn_map
syn_opt

# --- Reportes ---
report_qor       > qor.txt
report_area      > area.txt
report_gates     > gates.txt

report_timing -delay_type max -path_type full -max_paths 10 > timing_max.txt

write_hdl -mapped > netlist_mapped.v

write_design -basename ./alfacen_innovus

quit