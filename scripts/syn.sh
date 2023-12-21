#!/bin/sh

# Move to the run directory
cd ../syn
mkdir work

source /eda/scripts/init_design_vision

TIME=`date "+%T"`
DATE=`date +%d-%m-%y` 
FILE=sys
EXT=.log
FINALS=${FILE}_${DATE}_${TIME}_dc${EXT}


echo "Running the synthesis.."

dc_shell-xg-t -64 -f ../scripts/syn.tcl > ${FINALS}


