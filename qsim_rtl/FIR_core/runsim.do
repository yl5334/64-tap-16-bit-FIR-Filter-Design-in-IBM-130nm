##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -incr ../../rtl/FIR_core/FIR_core.v
vlog +acc -incr ../../rtl/FIR_core/AsyncFIFO.v
vlog +acc -incr ../../mem_comp/rf1shd/bin/sram.v   
vlog +acc -incr ../../mem_comp/rf1shd/bin/memory.v   
vlog +acc -incr testbench.v 

# Run Simulator 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
