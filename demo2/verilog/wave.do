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
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/ID_EX_rt
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/ID_EX_rs
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/EX_MEM_rd
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/MEM_WB_rd
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/check_rs
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/check_rt
add wave -noupdate /proc_hier_pbench/DUT/p0/stall0/stall
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/sel_pc_new
add wave -noupdate -radix decimal /proc_hier_pbench/DUT/p0/decode0/next_pc
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/flush
add wave -noupdate /proc_hier_pbench/DUT/p0/ID_EX_reg/ID_EX_sel_pc_new
add wave -noupdate -radix decimal /proc_hier_pbench/DUT/p0/ID_EX_reg/pc_new
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/sel_pc_new
add wave -noupdate -radix decimal /proc_hier_pbench/DUT/p0/fetch0/nxt_pc
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/jump
add wave -noupdate -radix decimal /proc_hier_pbench/DUT/p0/decode0/branch_addr
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/br_type
add wave -noupdate /proc_hier_pbench/DUT/p0/decode0/gte
add wave -noupdate -radix decimal /proc_hier_pbench/DUT/p0/ID_EX_reg/ID_EX_pc_new
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/next_pc
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/sel_pc_new
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/nxt_pc
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/halt
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/rst
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8651 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 295
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
WaveRestoreZoom {8354 ns} {9170 ns}
