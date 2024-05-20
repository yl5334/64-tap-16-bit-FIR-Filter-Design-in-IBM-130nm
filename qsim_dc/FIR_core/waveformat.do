onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk1
add wave -noupdate /testbench/clk2
add wave -noupdate /testbench/rstn
add wave -noupdate /testbench/valid_in
add wave -noupdate /testbench/error_count
add wave -noupdate -radix signed /testbench/cin
add wave -noupdate -radix signed /testbench/caddr
add wave -noupdate -radix signed /testbench/cload
add wave -noupdate -radix signed /testbench/din
add wave -noupdate -radix signed /testbench/dout
add wave -noupdate -radix signed /testbench/uut/s
add wave -noupdate -radix signed /testbench/uut/y
add wave -noupdate -radix signed /testbench/uut/y_float
add wave -noupdate -radix signed /testbench/uut/y_shi
add wave -noupdate -radix signed /testbench/uut/y_former


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
WaveRestoreZoom {0 ns} {10 ns}
