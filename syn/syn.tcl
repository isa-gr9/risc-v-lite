######################################################################
##
## SPECIFY LIBRARIES
##
######################################################################

#Source setup files
source ./.synopsys_dc.setup


# SUPPRESS WARNING MESSAGES
suppress_message MWLIBP-319
suppress_message MWLIBP-324
suppress_message TFCHK-012
suppress_message TFCHK-014
suppress_message TFCHK-049
suppress_message TFCHK-072
suppress_message TFCHK-084
suppress_message PSYN-651
suppress_message PSYN-650
suppress_message UID-401
suppress_message LINK-14
suppress_message TIM-134
suppress_message VER-130
suppress_message UISN-40
suppress_message VO-4
suppress_message RTDC-126

######################################################################
##
## READ DESIGN
##
######################################################################

# Set the design to synthesize
set active_design "top"


# DEFINE WORK DIRS
set dirname "../syn/results/${active_design}"
if {![file exists $dirname]} {
	file mkdir $dirname
}

set libDir "./work/"
file mkdir $libDir
#define_design_lib $active_design -path $libDir


analyze -format sv -library work {../rtl/basic_elements/ffd.sv ../rtl/basic_elements/mux21generic.sv ../rtl/basic_elements/register_generic.sv ../rtl/cu/cu.sv ../rtl/decode/RegisterFile.sv ../rtl/decode/reg_generator.sv ../rtl/decode/decode.sv ../rtl/exe/alu.sv ../rtl/exe/execute.sv ../rtl/fetch/adder.sv ../rtl/fetch/fetcher.sv ../rtl/fetch/ifu.sv ../rtl/mem/loadStore.sv ../rtl/mem/memory.sv ../rtl/wb/wb.sv ../rtl/fwu.sv ../rtl/hdu.sv ../rtl/datapath.sv ../rtl/top.sv} > ${dirname}/${active_design}_analyze.txt

#Preserve rtl names for make the power consumption estimation easier
set power_preserve_rtl_hier_names true


# Elaborate design
elaborate -lib work $active_design > ${dirname}/${active_design}_elaborate.txt

######################################################################
##
## SET DESIGN CONSTRAINTS
##
######################################################################
source "../syn/${active_design}.sdc"


#####################################################################
# COMPILE
#####################################################################

compile -exact_map
#compile_ultra


#####################################################################
# Reports
#####################################################################

# SET REPORT FILE NAME
set timing_rpt "${dirname}/${active_design}_postsyn_timing.rpt"
set power_rpt_noopt "${dirname}/${active_design}_postsyn_power_noopt.rpt"
set clk_rpt "${dirname}/${active_design}_postsyn_timing.rpt"
set area_rpt "${dirname}/${active_design}_postsyn_area.rpt"

# Report the properties of the clock just created
report_clock > $clk_rpt
# TIMING REPORT
report_timing > $timing_rpt
# POWER REPORT
report_power > $power_rpt_noopt
# AREA REPORT
report_area > $area_rpt

#####################################################################
# 
#   SAVE DESIGN
#
#####################################################################

#Erase the hierarchy
ungroup -all -flatten

#Imposing verilog rules to obtain a verilog netlist
change_names -hierarchy -rules verilog


#Delay of the netlist
write_sdf "${dirname}/${active_design}.sdf"
#Netlist
write -format sv -hierarchy -output "${dirname}/${active_design}_postsyn_netlist.v"
#design constraints
write_sdc "${dirname}/${active_design}.sdc"


exec rm -rf $libDir
exec rm -rf ./alib-52
exec rm default.svf command.log 
exit
