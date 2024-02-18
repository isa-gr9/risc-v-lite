#!/bin/sh

# Exit immediately if any command fails
set -e


#COMPILE
vlog -reportprogress 300 -work work ../basic_elements/ffd.sv
vlog -reportprogress 300 -work work ../basic_elements/register_generic.sv
vlog -reportprogress 300 -work work alu.sv
vlog -reportprogress 300 -work work execute.sv
#Testbench
vlog -reportprogress 300 -work work ./tb.sv

vsim -do ./run.do

# Remove work directory
rm -rf work

# Remove vsim and transcript files
rm -f vsim.wlf transcript