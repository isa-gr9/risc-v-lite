#vsim work.tb_top
#add wave *
#add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/DECODE/rf_inst/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/DECODE/rf_inst/registers


add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/FETCH/fetcher/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/FETCH/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/DECODE/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/EXE/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/MEM/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/MEM/Load_Store_unit/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/WB/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/FWDUNIT/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/HZRDUNIT/*
add wave -position insertpoint sim:/tb_top/top_inst/datap_inst/*
#add wave -position insertpoint sim:/tb_exe/exe/*
#add wave -position insertpoint sim:/tb_exe/exe/ALU0/*

run 3500 ns
wave zoom full
