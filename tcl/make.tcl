create_project -force project_5 ./build/project_5 -part xc7a100tcsg324-1
add_files -norecurse [glob ./hdl/*.sv]
add_files -norecurse [glob ./hdl/asm/*.mem]
add_files -fileset constrs_1 -norecurse ./constraint/Nexys_A7.xdc
set_property top_file {./hdl/cpu_top.sv} [current_fileset]
set_property top cpu_top [current_fileset]
set_property top_file {./hdl/cpu_tb.sv} [get_filesets sim_1]
set_property top cpu_tb [get_filesets sim_1]
close_project
