vcd file ALU.vcd
vcd add /testbench/clk1
vcd add /testbench/clk2

vcd add /testbench/ALU_restn
vcd add /testbench/x
vcd add /testbench/b
vcd add /testbench/y
vcd add /testbench/y_com
vcd add /testbench/error_count

vcd on

run 1ms

vcd off

quit
