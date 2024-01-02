vsim work.tb_decode
add wave *
add wave -position insertpoint sim:/tb_decode/Du/RG/*
add wave -position insertpoint sim:/tb_decode/Du/RF/*
add wave -position insertpoint sim:/tb_decode/Du/RF/REGISTERS
run 500 ns
wave zoom full