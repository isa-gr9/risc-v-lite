vsim work.tb_exe
add wave *
add wave -position insertpoint sim:/tb_exe/exe/*
add wave -position insertpoint sim:/tb_exe/exe/ALU0/*
run 500 ns
wave zoom full