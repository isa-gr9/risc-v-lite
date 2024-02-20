#!/bin/sh

# Exit immediately if any command fails
set -e


vlog -reportprogress 300 -work work ../rtl/basic_elements/ffd.sv 
vlog -reportprogress 300 -work work ../rtl/basic_elements/mux21generic.sv 
vlog -reportprogress 300 -work work ../rtl/basic_elements/register_generic.sv 
vlog -reportprogress 300 -work work ../rtl/cu/cu.sv 
vlog -reportprogress 300 -work work ../rtl/decode/RegisterFile.sv 
vlog -reportprogress 300 -work work ../rtl/decode/reg_generator.sv 
vlog -reportprogress 300 -work work ../rtl/decode/decode.sv 
vlog -reportprogress 300 -work work ../rtl/exe/alu.sv 
vlog -reportprogress 300 -work work ../rtl/exe/execute.sv 
vlog -reportprogress 300 -work work ../rtl/fetch/adder.sv 
vlog -reportprogress 300 -work work ../rtl/fetch/fetcher.sv 
vlog -reportprogress 300 -work work ../rtl/fetch/ifu.sv 
vlog -reportprogress 300 -work work ../rtl/mem/loadStore.sv 
vlog -reportprogress 300 -work work ../rtl/mem/memory.sv 
vlog -reportprogress 300 -work work ../rtl/wb/wb.sv 
vlog -reportprogress 300 -work work ../rtl/fwu.sv 
vlog -reportprogress 300 -work work ../rtl/hdu.sv 
vlog -reportprogress 300 -work work ../rtl/datapath.sv 
vlog -reportprogress 300 -work work ../rtl/top.sv



# Remove work directory
rm -rf work

# Remove vsim and transcript files
rm -f vsim.wlf transcript