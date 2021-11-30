onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_tb/DUT/CPU/IR/load_ir
add wave -noupdate /lab7_tb/DUT/CPU/IR/read_data
add wave -noupdate /lab7_tb/DUT/CPU/IR/in_out
add wave -noupdate /lab7_tb/DUT/CPU/PC/next_pc
add wave -noupdate /lab7_tb/DUT/CPU/PC/load_pc
add wave -noupdate /lab7_tb/DUT/CPU/PC/clk
add wave -noupdate /lab7_tb/DUT/CPU/PC/pc_out
add wave -noupdate /lab7_tb/DUT/CPU/MMEM/pc_out
add wave -noupdate /lab7_tb/DUT/CPU/MMEM/addr_sel
add wave -noupdate /lab7_tb/DUT/CPU/MMEM/mem_addr
add wave -noupdate /lab7_tb/DUT/CPU/MPC/pc_out
add wave -noupdate /lab7_tb/DUT/CPU/MPC/reset_pc
add wave -noupdate /lab7_tb/DUT/CPU/MPC/next_pc
add wave -noupdate /lab7_tb/DUT/CPU/SM/opcode
add wave -noupdate /lab7_tb/DUT/CPU/SM/op
add wave -noupdate /lab7_tb/DUT/CPU/SM/load_ir
add wave -noupdate /lab7_tb/DUT/CPU/SM/load_pc
add wave -noupdate /lab7_tb/DUT/CPU/SM/addr_sel
add wave -noupdate /lab7_tb/DUT/CPU/SM/mem_cmd
add wave -noupdate /lab7_tb/DUT/CPU/SM/state
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
