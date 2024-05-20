onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk1
add wave -noupdate /testbench/clk2
add wave -noupdate /testbench/ALU_restn
add wave -noupdate /testbench/b_valid
add wave -noupdate -radix signed /testbench/x
add wave -noupdate -radix signed /testbench/b
add wave -noupdate -radix signed /testbench/y
add wave -noupdate -radix signed /testbench/y_com
add wave -noupdate -radix unsigned /testbench/error_count
add wave -noupdate -radix signed /testbench/myALU/x_fifo
add wave -noupdate -radix signed /testbench/myALU/y_t
add wave -noupdate -radix signed /testbench/myALU/b_t
add wave -noupdate -radix signed /testbench/myALU/y_t2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 89
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {12 ns}


