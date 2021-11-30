onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_tb/write_address
add wave -noupdate /lab7_tb/write
add wave -noupdate /lab7_tb/reset
add wave -noupdate /lab7_tb/read_data
add wave -noupdate /lab7_tb/read_address
add wave -noupdate /lab7_tb/mem_cmd
add wave -noupdate /lab7_tb/mem_addr
add wave -noupdate /lab7_tb/dout
add wave -noupdate /lab7_tb/din
add wave -noupdate /lab7_tb/clk
add wave -noupdate /lab7_tb/DUT/CPU/SM/state
add wave -noupdate /lab7_tb/DUT/CPU/SM/mem_cmd
add wave -noupdate /lab7_tb/DUT/CPU/SM/load_pc
add wave -noupdate /lab7_tb/DUT/CPU/SM/load_ir
add wave -noupdate /lab7_tb/DUT/CPU/SM/addr_sel
add wave -noupdate /lab7_tb/DUT/CPU/IR/read_data
add wave -noupdate /lab7_tb/DUT/CPU/IR/load_ir
add wave -noupdate /lab7_tb/DUT/CPU/IR/in_out
add wave -noupdate /lab7_tb/DUT/CPU/IR/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1 ns}
