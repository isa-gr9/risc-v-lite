######################################################################
##
## SPECIFY LIBRARIES
##
######################################################################

# SOURCE SETUP FILE
source "./.synopsys_dc.setup"

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

# DEFINE CIRCUITS and WORK DIRS
#set blockName "dlx"
set active_design "riscv"


# DEFINE WORK DIRS
set dirname "./results/"
if {![file exists $dirname]} {
	file mkdir $dirname
}

analyze -library WORK -format vhdl {and2.vhd constants.vhd mux21generic.vhd mux21.vhd ffd.vhd myTypes.vhd register_generic.vhd rca.vhd fetch.vhd signExtend.vhd RegisterFile.vhd decode.vhd lfsr.vhd csb.vhd sumGenerator.vhd pg.vhd g.vhd pg_generator.vhd cla_sparse_tree.vhd xor.vhd p4_adder.vhd ctrl_alu.vhd logic_and_shift.vhd comparator.vhd outputSelect.vhd alu.vhd zero_det.vhd xnor.vhd executionUnit.vhd memory.vhd WB.vhd datapath.vhd CU_HW.vhd dlx.vhd}
# ELABORATE DESIGN

elaborate $active_design -architecture STRUCTURAL -library WORK

# Compile the design using exact mapping
compile -exact_map

######################################################################
##
## WRITE REPORTS
##
######################################################################

# SET REPORT FILE NAME
set timing_noclk_rpt "${dirname}/${active_design}_postsyn_timing.rpt"
set timing_rpt "${dirname}/${active_design}_postsyn_timing.rpt"
set power_rpt "${dirname}/${active_design}_postsyn_power.rpt"
set clk_rpt "${dirname}/${active_design}_postsyn_timing.rpt"

# Generate a timing report without constraints
report_timing > $timing_noclk_rpt
# Create a clock named 'CLK' with a period of 2ns
create_clock -name "CLK" -period 2.5 CLK
# Report the properties of the clock just created
report_clock > $clk_rpt
# Compile the design again after clock creation
compile
# TIMING REPORT
report_timing > $timing_rpt
# POWER REPORT
report_power > $power_rpt

######################################################################
##
## SAVE DESIGN
##
######################################################################

# Write the post-synthesis VHDL netlist to the file 'PostSynthRegFileWindowing.vhdl'
write -format vhdl    -hierarchy -output "${dirname}/${active_design}_postsyn.vhd"
write -format verilog -hierarchy -output "${dirname}/${active_design}_postsyn.v"
write_sdc "${dirname}/${active_design}.sdc"
######################################################################
##
## CLEAN & EXIT
##
######################################################################

exec rm -rf $libDir
exit


