###################################################################

# Created by write_sdc on Mon Nov 27 23:15:36 2023

###################################################################
set sdc_version 1.7

set_units -time ns -resistance kOhm -capacitance pF -power mW -voltage V       \
-current mA
set_max_fanout 4 [current_design]
set_max_area 0
set_driving_cell -lib_cell INVX1TS [get_ports clk1]
set_driving_cell -lib_cell INVX1TS [get_ports clk2]
set_driving_cell -lib_cell INVX1TS [get_ports ALU_restn]
set_driving_cell -lib_cell INVX1TS [get_ports {x[15]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[14]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[13]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[12]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[11]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[10]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[9]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[8]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[7]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[6]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[5]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[4]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[3]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[2]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[1]}]
set_driving_cell -lib_cell INVX1TS [get_ports {x[0]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[15]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[14]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[13]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[12]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[11]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[10]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[9]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[8]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[7]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[6]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[5]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[4]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[3]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[2]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[1]}]
set_driving_cell -lib_cell INVX1TS [get_ports {b[0]}]
set_driving_cell -lib_cell INVX1TS [get_ports b_valid]
set_load -pin_load 0.005 [get_ports {y[15]}]
set_load -pin_load 0.005 [get_ports {y[14]}]
set_load -pin_load 0.005 [get_ports {y[13]}]
set_load -pin_load 0.005 [get_ports {y[12]}]
set_load -pin_load 0.005 [get_ports {y[11]}]
set_load -pin_load 0.005 [get_ports {y[10]}]
set_load -pin_load 0.005 [get_ports {y[9]}]
set_load -pin_load 0.005 [get_ports {y[8]}]
set_load -pin_load 0.005 [get_ports {y[7]}]
set_load -pin_load 0.005 [get_ports {y[6]}]
set_load -pin_load 0.005 [get_ports {y[5]}]
set_load -pin_load 0.005 [get_ports {y[4]}]
set_load -pin_load 0.005 [get_ports {y[3]}]
set_load -pin_load 0.005 [get_ports {y[2]}]
set_load -pin_load 0.005 [get_ports {y[1]}]
set_load -pin_load 0.005 [get_ports {y[0]}]
set_max_capacitance 0.005 [get_ports clk1]
set_max_capacitance 0.005 [get_ports clk2]
set_max_capacitance 0.005 [get_ports ALU_restn]
set_max_capacitance 0.005 [get_ports {x[15]}]
set_max_capacitance 0.005 [get_ports {x[14]}]
set_max_capacitance 0.005 [get_ports {x[13]}]
set_max_capacitance 0.005 [get_ports {x[12]}]
set_max_capacitance 0.005 [get_ports {x[11]}]
set_max_capacitance 0.005 [get_ports {x[10]}]
set_max_capacitance 0.005 [get_ports {x[9]}]
set_max_capacitance 0.005 [get_ports {x[8]}]
set_max_capacitance 0.005 [get_ports {x[7]}]
set_max_capacitance 0.005 [get_ports {x[6]}]
set_max_capacitance 0.005 [get_ports {x[5]}]
set_max_capacitance 0.005 [get_ports {x[4]}]
set_max_capacitance 0.005 [get_ports {x[3]}]
set_max_capacitance 0.005 [get_ports {x[2]}]
set_max_capacitance 0.005 [get_ports {x[1]}]
set_max_capacitance 0.005 [get_ports {x[0]}]
set_max_capacitance 0.005 [get_ports {b[15]}]
set_max_capacitance 0.005 [get_ports {b[14]}]
set_max_capacitance 0.005 [get_ports {b[13]}]
set_max_capacitance 0.005 [get_ports {b[12]}]
set_max_capacitance 0.005 [get_ports {b[11]}]
set_max_capacitance 0.005 [get_ports {b[10]}]
set_max_capacitance 0.005 [get_ports {b[9]}]
set_max_capacitance 0.005 [get_ports {b[8]}]
set_max_capacitance 0.005 [get_ports {b[7]}]
set_max_capacitance 0.005 [get_ports {b[6]}]
set_max_capacitance 0.005 [get_ports {b[5]}]
set_max_capacitance 0.005 [get_ports {b[4]}]
set_max_capacitance 0.005 [get_ports {b[3]}]
set_max_capacitance 0.005 [get_ports {b[2]}]
set_max_capacitance 0.005 [get_ports {b[1]}]
set_max_capacitance 0.005 [get_ports {b[0]}]
set_max_capacitance 0.005 [get_ports b_valid]
set_max_fanout 4 [get_ports clk1]
set_max_fanout 4 [get_ports clk2]
set_max_fanout 4 [get_ports ALU_restn]
set_max_fanout 4 [get_ports {x[15]}]
set_max_fanout 4 [get_ports {x[14]}]
set_max_fanout 4 [get_ports {x[13]}]
set_max_fanout 4 [get_ports {x[12]}]
set_max_fanout 4 [get_ports {x[11]}]
set_max_fanout 4 [get_ports {x[10]}]
set_max_fanout 4 [get_ports {x[9]}]
set_max_fanout 4 [get_ports {x[8]}]
set_max_fanout 4 [get_ports {x[7]}]
set_max_fanout 4 [get_ports {x[6]}]
set_max_fanout 4 [get_ports {x[5]}]
set_max_fanout 4 [get_ports {x[4]}]
set_max_fanout 4 [get_ports {x[3]}]
set_max_fanout 4 [get_ports {x[2]}]
set_max_fanout 4 [get_ports {x[1]}]
set_max_fanout 4 [get_ports {x[0]}]
set_max_fanout 4 [get_ports {b[15]}]
set_max_fanout 4 [get_ports {b[14]}]
set_max_fanout 4 [get_ports {b[13]}]
set_max_fanout 4 [get_ports {b[12]}]
set_max_fanout 4 [get_ports {b[11]}]
set_max_fanout 4 [get_ports {b[10]}]
set_max_fanout 4 [get_ports {b[9]}]
set_max_fanout 4 [get_ports {b[8]}]
set_max_fanout 4 [get_ports {b[7]}]
set_max_fanout 4 [get_ports {b[6]}]
set_max_fanout 4 [get_ports {b[5]}]
set_max_fanout 4 [get_ports {b[4]}]
set_max_fanout 4 [get_ports {b[3]}]
set_max_fanout 4 [get_ports {b[2]}]
set_max_fanout 4 [get_ports {b[1]}]
set_max_fanout 4 [get_ports {b[0]}]
set_max_fanout 4 [get_ports b_valid]
set_ideal_network [get_ports clk1]
set_ideal_network [get_ports clk2]
create_clock [get_ports clk1]  -period 100000  -waveform {0 50000}
set_clock_uncertainty 0  [get_clocks clk1]
set_clock_transition -max -rise 0.01 [get_clocks clk1]
set_clock_transition -max -fall 0.01 [get_clocks clk1]
set_clock_transition -min -rise 0.01 [get_clocks clk1]
set_clock_transition -min -fall 0.01 [get_clocks clk1]
create_clock [get_ports clk2]  -period 1562.5  -waveform {0 781.25}
set_clock_uncertainty 0  [get_clocks clk2]
set_clock_transition -max -rise 0.01 [get_clocks clk2]
set_clock_transition -max -fall 0.01 [get_clocks clk2]
set_clock_transition -min -rise 0.01 [get_clocks clk2]
set_clock_transition -min -fall 0.01 [get_clocks clk2]
set_input_delay -clock clk2  0.05  [get_ports clk1]
set_input_delay -clock clk2  0.05  [get_ports ALU_restn]
set_input_delay -clock clk2  0.05  [get_ports {x[15]}]
set_input_delay -clock clk2  0.05  [get_ports {x[14]}]
set_input_delay -clock clk2  0.05  [get_ports {x[13]}]
set_input_delay -clock clk2  0.05  [get_ports {x[12]}]
set_input_delay -clock clk2  0.05  [get_ports {x[11]}]
set_input_delay -clock clk2  0.05  [get_ports {x[10]}]
set_input_delay -clock clk2  0.05  [get_ports {x[9]}]
set_input_delay -clock clk2  0.05  [get_ports {x[8]}]
set_input_delay -clock clk2  0.05  [get_ports {x[7]}]
set_input_delay -clock clk2  0.05  [get_ports {x[6]}]
set_input_delay -clock clk2  0.05  [get_ports {x[5]}]
set_input_delay -clock clk2  0.05  [get_ports {x[4]}]
set_input_delay -clock clk2  0.05  [get_ports {x[3]}]
set_input_delay -clock clk2  0.05  [get_ports {x[2]}]
set_input_delay -clock clk2  0.05  [get_ports {x[1]}]
set_input_delay -clock clk2  0.05  [get_ports {x[0]}]
set_input_delay -clock clk2  0.05  [get_ports {b[15]}]
set_input_delay -clock clk2  0.05  [get_ports {b[14]}]
set_input_delay -clock clk2  0.05  [get_ports {b[13]}]
set_input_delay -clock clk2  0.05  [get_ports {b[12]}]
set_input_delay -clock clk2  0.05  [get_ports {b[11]}]
set_input_delay -clock clk2  0.05  [get_ports {b[10]}]
set_input_delay -clock clk2  0.05  [get_ports {b[9]}]
set_input_delay -clock clk2  0.05  [get_ports {b[8]}]
set_input_delay -clock clk2  0.05  [get_ports {b[7]}]
set_input_delay -clock clk2  0.05  [get_ports {b[6]}]
set_input_delay -clock clk2  0.05  [get_ports {b[5]}]
set_input_delay -clock clk2  0.05  [get_ports {b[4]}]
set_input_delay -clock clk2  0.05  [get_ports {b[3]}]
set_input_delay -clock clk2  0.05  [get_ports {b[2]}]
set_input_delay -clock clk2  0.05  [get_ports {b[1]}]
set_input_delay -clock clk2  0.05  [get_ports {b[0]}]
set_input_delay -clock clk2  0.05  [get_ports b_valid]
set_output_delay -clock clk2  0.05  [get_ports {y[15]}]
set_output_delay -clock clk2  0.05  [get_ports {y[14]}]
set_output_delay -clock clk2  0.05  [get_ports {y[13]}]
set_output_delay -clock clk2  0.05  [get_ports {y[12]}]
set_output_delay -clock clk2  0.05  [get_ports {y[11]}]
set_output_delay -clock clk2  0.05  [get_ports {y[10]}]
set_output_delay -clock clk2  0.05  [get_ports {y[9]}]
set_output_delay -clock clk2  0.05  [get_ports {y[8]}]
set_output_delay -clock clk2  0.05  [get_ports {y[7]}]
set_output_delay -clock clk2  0.05  [get_ports {y[6]}]
set_output_delay -clock clk2  0.05  [get_ports {y[5]}]
set_output_delay -clock clk2  0.05  [get_ports {y[4]}]
set_output_delay -clock clk2  0.05  [get_ports {y[3]}]
set_output_delay -clock clk2  0.05  [get_ports {y[2]}]
set_output_delay -clock clk2  0.05  [get_ports {y[1]}]
set_output_delay -clock clk2  0.05  [get_ports {y[0]}]
