dataset open dump.wlf
noview process
noview transcript
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_hier_pbench/PC
add wave -noupdate /proc_hier_pbench/RegWrite
add wave -noupdate /proc_hier_pbench/WriteRegister
add wave -noupdate /proc_hier_pbench/WriteData
add wave -noupdate /proc_hier_pbench/MemWrite
add wave -noupdate /proc_hier_pbench/MemRead
add wave -noupdate /proc_hier_pbench/MemAddress
add wave -noupdate /proc_hier_pbench/DUT/p0/stall
add wave -noupdate /proc_hier_pbench/DUT/p0/HD/EX_MEM_rd
add wave -noupdate /proc_hier_pbench/DUT/p0/HD/MEM_WB_rd
add wave -noupdate /proc_hier_pbench/DUT/p0/HD/rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {641 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 49
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
WaveRestoreZoom {0 ns} {1324 ns}
