set top_level ALU
source -verbose "../common_script/common.tcl"
read_verilog {../../rtl/$top_level/$top_level.v }
set set_fix_multiple_port_nets "true"
list_designs

if { [check_error -v] == 1 } { exit 1 }

#########################################
# Design Constraints                    #
#########################################
current_design $top_level
link
check_design
source -verbose "./timing.tcl"
set_max_capacitance 0.005 [all_inputs]
set_max_fanout 4 $top_level
set_max_fanout 4 [all_inputs]
set_max_area 0 
set_fix_multiple_port_nets -all -buffer_constants

#########################################
# Compile                               #
#########################################
check_design
#uniquify
current_design $top_level
link
