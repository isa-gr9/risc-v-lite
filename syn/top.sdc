####################################################################
#  Design constraints of the basic version of IIR
####################################################################


set clockName "clk"
set clockSys  "clk_sys"

# Period measured in nanoseconds. So for a 100MHz frequency, 10 ns are selected

set clockPeriod "1.5"


# Set-up Clock
create_clock -name $clockSys -period $clockPeriod $clockName

#Don't touch property highlighting that is a special signal in the design
set_dont_touch_network $clockSys

#Set clock uncertainty for jitter problems
set_clock_uncertainty 0.07 [get_clocks $clockSys]


#Set input and output delay
#input must be lower than the clock period
set_input_delay 0.5 -max -clock $clockSys [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -clock $clockSys [all_outputs]


# Setting the load of all the outputs to a buffer taken from the tech lib 
set outputload [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $outputload [all_outputs]
