#!/bin/sh

# Exit immediately if any command fails
set -e


#COMPILE
vlog -reportprogress 300 -work work cu.sv
#Testbench
vlog -reportprogress 300 -work work ./tb_cu.sv

vsim -do ./run.do

# Remove work directory
rm -rf work

# Remove vsim and transcript files
rm -f vsim.wlf transcript