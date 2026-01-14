# Cadence Genus(TM) Synthesis Solution, Version 25.12-s067_1, built Nov 17 2025 13:10:10

# Date: Tue Jan 13 23:27:48 2026
# Host: rocky0 (x86_64 w/Linux 5.15.0-164-generic) (12cores*48cpus*2physical cpus*Intel(R) Xeon(R) Gold 5118 CPU @ 2.30GHz 16896KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

set_db lib_search_path {/home/chuy/FPU_LAEDC/static_timing_analysis}
read_libs {/home/chuy/FPU_LAEDC/static_timi                                                                                                                          ng_analysis/sky130_fd_sc_hd__ff_100C_1v65.lib}
read_libs {/home/chuy/FPU_LAEDC/static_timing_analysis/sky130_fd_sc_hd__ff_100C_1v65.lib}
read_hdl -f rtl_list
elaborate "FPU"
read_sdc constraints.sdc
report_designs
report_hierarchy > hier.txt
syn_generic
syn_map
syn_opt
report_qor       > qor.txt
report_area      > area.txt
report_gates     > gates.txt
report_timing -delay_type max -path_type full -max_paths 10 > timing_max.txt
report_timing -path_type full -max_paths 10 > timing_max.txt
report_area -hierarchical -depth 3 > area_hier_depth3.txt
report_area  -depth 3 > area_hier_depth3.txt
report_area -detail -gates -depth 3 > area_hier_depth3.txt
report_area -detail -depth 3 > area_hier_depth3.txt
report_area -detail > area_hier_depth3.txt
report_area -detail > area_hier_depth3.txt
report_area -detail -depth 3 > area_hier_depth3.txt
report_area -detail -depth 10 > area_hier_depth3.txt
report_area -detail -depth 10 > area_hier_depth3.txt
report_timing -help
report_area -detail -nets > area_hier_depth3.txt
report_area nets > area_hier_depth3.txt
report_area -nets > area_hier_depth3.txt
report_timing -help
report_timing -nets -path_type full -max_paths 10 > timing_max.txt
pwd
write_hdl -mapped > netlist_mapped.v
exit
