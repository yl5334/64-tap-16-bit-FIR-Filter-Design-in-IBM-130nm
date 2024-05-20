##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

#Setup
 vlib work
 vmap work work

#Include Netlist and Testbench
 vlog +acc -incr /courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
 vlog +acc -incr ../../dc/FIR_core/FIR_core.nl.v
 vlog +acc -incr ../../mem_comp/rf1shd/bin/memory.v
  #vlog +acc -incr ../../rtl/ALU/fix2float.v
 vlog +acc -incr ./testbench.v 

#Run Simulator 
#SDF from DC is annotated for the timing check 
vsim -voptargs=+acc -t ps -lib work -sdftyp uut=../../dc/FIR_core/FIR_core.syn.sdf testbench 
#vcd file ALU.vcd
#vcd record -r
 do waveformat.do   
 run -all
#vcd stop
