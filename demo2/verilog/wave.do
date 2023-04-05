onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/clk
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/instr
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/IF_ID_instr
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/instr
add wave -noupdate /proc_hier_pbench/DUT/p0/IF_ID_reg/rst
add wave -noupdate /proc_hier_pbench/DUT/p0/halt
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/halt
add wave -noupdate /proc_hier_pbench/DUT/p0/ID_EX_reg/ID_EX_halt
add wave -noupdate /proc_hier_pbench/DUT/p0/EX_MEM_reg/EX_MEM_halt
add wave -noupdate /proc_hier_pbench/DUT/p0/EX_MEM_reg/ID_EX_halt
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/halt
add wave -noupdate /proc_hier_pbench/DUT/p0/MEM_WB_reg/MEM_WB_halt
add wave -noupdate /proc_hier_pbench/DUT/p0/proc_cntrl/halt
add wave -noupdate /proc_hier_pbench/DUT/p0/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {212 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 299
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
WaveRestoreZoom {0 ns} {425 ns}
