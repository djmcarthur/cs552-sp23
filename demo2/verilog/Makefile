
run:
	wsrun.pl proc_hier_bench *.v

waves:
	vsim -do wave.do

custom:
	clear
	@read -p "Enter Test File Name:" file; \
	wsrun.pl -pipe -prog ./$$file.asm proc_hier_pbench *.v
asm:
	clear
	@read -p "Enter Test File Name:" file; \
	wsrun.pl -pipe -prog /u/m/c/mcarthur/cs552/project/demo2/my_tests/$$file.asm proc_hier_pbench *.v

	#wsrun.pl -pipe -prog /u/s/i/sinclair/courses/cs552/spring2022/handouts/testprograms/public/inst_tests/$$file.asm proc_hier_pbench *.v
all:
	wsrun.pl -pipe -list all.list proc_hier_pbench *.v

complex:
	clear
	@read -p "Enter Test File Name:" file; \
	wsrun.pl -pipe -prog ~sinclair/courses/cs552/spring2022/handouts/testprograms/public/complex_demo1 proc_hier_pbench *.v

complex_final:
	wsrun.pl -pipe -prog ~sinclair/courses/cs552/spring2022/handouts/testprograms/public/complex_demo1/all.list proc_hier_pbench *.v
	cp summary.log ../summary/complex_demo1.summary.log

rand_simple:
	wsrun.pl -pipe -prog ~sinclair/courses/cs552/spring2022/handouts/testprograms/public/rand_simple/all.list proc_hier_pbench *.v
	cp summary.log ../summary/rand_simple.summary.log

rand_complex:
	wsrun.pl -pipe -prog ~sinclair/courses/cs552/spring2022/handouts/testprograms/public/rand_complex/all.list proc_hier_pbench *.v
	cp summary.log ../summary/rand_complex.summary.log

rand_ctrl:
	wsrun.pl -pipe -prog ~sinclair/courses/cs552/spring2022/handouts/testprograms/public/rand_ctrl/all.list proc_hier_pbench *.v
	cp summary.log ../summary/rand_ctrl.summary.log

rand_mem:
	wsrun.pl -pipe -prog ~sinclair/courses/cs552/spring2022/handouts/testprograms/public/rand_mem/all.list proc_hier_pbench *.v
	cp summary.log ../summary/rand_mem.summary.log

FUCKIT: complex_final rand_simple rand_complex rand_ctrl rand_mem
