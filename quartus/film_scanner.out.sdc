## Generated SDC file "film_scanner.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 Patches 0.01we SJ Web Edition"

## DATE    "Sat Sep 23 11:58:58 2017"

##
## DEVICE  "EP4CE6E22C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_60M} -period 16.000 -waveform { 0.000 8.000 } [get_ports {ft_clk}]
create_clock -name {clk_100M} -period 10.000 -waveform { 0.000 5.000 } [get_ports {clk_100M}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_bus[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_rxf}]
set_input_delay -add_delay  -clock [get_clocks {clk_60M}]  2.000 [get_ports {ft_txe}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk_60M}]  1.000 [get_ports {ft_oe}]
set_output_delay -add_delay  -clock [get_clocks {clk_60M}]  1.000 [get_ports {ft_rd}]
set_output_delay -add_delay  -clock [get_clocks {clk_60M}]  1.000 [get_ports {ft_wr}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {clk_60M}]  -to  [get_clocks {clk_60M}]
set_false_path  -from  [get_clocks {clk_100M}]  -to  [get_clocks {clk_60M}]
set_false_path  -from  [get_clocks {clk_60M}]  -to  [get_clocks {clk_100M}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_od9:dffpipe22|dffe23a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_nd9:dffpipe13|dffe14a*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

