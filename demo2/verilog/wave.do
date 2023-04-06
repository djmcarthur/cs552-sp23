onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/clk
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/rst
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/stall
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/IF_ID_instr
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/IF_ID_pc_inc
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/instr
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/pc_inc
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/read1
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/read2
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/MEM_WB_rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {649 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 260
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2315 ns}
