set outputDir ./synth_output
file mkdir $outputDir

# STEP 1: setup design sources and constraints
read_verilog  [ glob ./hdl/*.sv ]
read_xdc ./constraint/Nexys_A7.xdc

# STEP 2: run synthesis
synth_design -top cpu_top -part xc7a100tcsg324-1 -flatten rebuilt

# STEP 3: run placement and logic optimization
opt_design
power_opt_design
place_design
phys_opt_design

# STEP 4: run router, report actual utilization
route_design
report_utilization -file $outputDir/post_route_util.rpt

# STEP 5: generate a bitstream
write_bitstream -force $outputDir/cpu.bit
