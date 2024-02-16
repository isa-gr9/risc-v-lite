vsim work.tb_fetcher
add wave *
add wave -position insertpoint sim:/tb_fetcher/dut/*
#add wave -position insertpoint sim:/tb_exe/exe/ALU0/*
run 500 ns
wave zoom full