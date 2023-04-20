onerror {resume}
quietly virtual signal -install /mem_system_perfbench/DUT/m0 { (context /mem_system_perfbench/DUT/m0 )&{state_ff[3]/q , state_ff[2]/q , state_ff[1]/q , state_ff[0]/q }} curr_state
quietly WaveActivateNextPane {} 0
add wave -noupdate /mem_system_perfbench/DUT/m0/curr_state
add wave -noupdate {/mem_system_perfbench/DUT/m0/state_ff[3]/q}
add wave -noupdate {/mem_system_perfbench/DUT/m0/state_ff[2]/q}
add wave -noupdate {/mem_system_perfbench/DUT/m0/state_ff[1]/q}
add wave -noupdate {/mem_system_perfbench/DUT/m0/state_ff[0]/q}
add wave -noupdate /mem_system_perfbench/DUT/m0/hit
add wave -noupdate /mem_system_perfbench/DUT/m0/hit
add wave -noupdate /mem_system_perfbench/DUT/m0/valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1537 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 258
configure wave -valuecolwidth 162
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
WaveRestoreZoom {0 ns} {3240 ns}
