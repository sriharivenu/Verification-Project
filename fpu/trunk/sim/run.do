# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the sources.
vlog  ../lib/gscl45nm.v
vlog		../test_bench/test_top.v \
		../verilog/fpu.v		\
		../verilog/pre_norm.v	\
		../verilog/primitives.v	\
		../verilog/post_norm.v	\
		../verilog/except.v	\
		../verilog/pre_norm_fmul.v
vlog +cover -sv ../tb/interfaces.sv  ../tb/sequences.sv ../tb/coverage.sv ../tb/scoreboard.sv ../tb/modules.sv ../tb/tests.sv  ../tb/tb.sv  

# Simulate the design.
vsim -c test 
run -all
exit
