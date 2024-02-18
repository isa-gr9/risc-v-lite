#!/bin/sh

# Exit immediately if any command fails
set -e


#COMPILE
vlog -reportprogress 300 -work work ../basic_elements/ffd.sv
vlog -reportprogress 300 -work work ../basic_elements/register_generic.sv
vlog -reportprogress 300 -work work ../basic_elements/mux21generic.sv

vlog -reportprogress 300 -work work adder.sv
vlog -reportprogress 300 -work work fetcher.sv
vlog -reportprogress 300 -work work ifu.sv
#Testbench


#Testbench
#vlog -reportprogress 300 -work work tb_fetcher.sv
#
#vsim -do ./run.do
#
## Remove work directory
#rm -rf work
#
## Remove vsim and transcript files
#rm -f vsim.wlf transcript