vsim work.tb_fetch
add wave *
add wave -position insertpoint sim:/tb_fetch/Du/add/*
add wave -position insertpoint sim:/tb_fetch/Du/fetch/*

run 500 ns
wave zoom full