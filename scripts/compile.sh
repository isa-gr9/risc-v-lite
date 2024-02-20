#!/bin/sh

# Exit immediately if any command fails
set -e


vlog -reportprogress 300 -work work ffd.sv 
vlog -reportprogress 300 -work work mux21generic.sv 
vlog -reportprogress 300 -work work register_generic.sv 
vlog -reportprogress 300 -work work cu.sv 
vlog -reportprogress 300 -work work RegisterFile.sv 
vlog -reportprogress 300 -work work reg_generator.sv 
vlog -reportprogress 300 -work work decode.sv alu.sv 
vlog -reportprogress 300 -work work execute.sv 
vlog -reportprogress 300 -work work adder.sv 
vlog -reportprogress 300 -work work fetcher.sv 
vlog -reportprogress 300 -work work ifu.sv 
vlog -reportprogress 300 -work work loadstoreunit.sv 
vlog -reportprogress 300 -work work memory.sv 
vlog -reportprogress 300 -work work wb.sv 
vlog -reportprogress 300 -work work fwu.sv 
vlog -reportprogress 300 -work work hdu.sv 
vlog -reportprogress 300 -work work datapath.sv 
vlog -reportprogress 300 -work work top.sv



# Remove work directory
rm -rf work

# Remove vsim and transcript files
rm -f vsim.wlf transcript