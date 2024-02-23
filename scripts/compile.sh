#!/bin/sh

# Exit immediately if any command fails
set -e
source /eda/scripts/init_questa_core_prime
rm -rf work
vlib work


vlog -reportprogress 300 -work work ../rtl/basic_elements/ffd.sv 
vlog -reportprogress 300 -work work ../rtl/basic_elements/mux21generic.sv 
vlog -reportprogress 300 -work work ../rtl/basic_elements/register_generic.sv 
vlog -reportprogress 300 -work work ../rtl/basic_elements/register_generic_pc.sv
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

vlog -reportprogress 300 -work work ../rtl/tb_top.sv

vsim  -L ./mem_wrap work.tb_top -do run.do -voptargs=+acc


# Remove work directory
rm -rf work

# Remove vsim and transcript files
rm -f vsim.wlf transcript
