##################################
# A very simple modelsim do file #
##################################

# 1) Create a library for working in
#vlib work

# 2) Compile the half adder
#vcom -93 -explicit -work work 
#vcom -93 -explicit -work work HalfAdder.vhd
#vlog -compile_uselibs[=</home/george/intelFPGA/16.1/modelsim_ase/altera/verilog/altera_mf>] usb_ft232h.sv
vlog ../usb_ft232h.sv
vlog ../usb_ft232h_tb.sv

# 3) Load it for simulation
vsim usb_ft232h_tb -L altera_mf_ver

# 4) Open some selected windows for viewing
view structure
view signals
view wave

# 5) Show some of the signals in the wave window
add wave -divider "USB Signals"
add wave -noupdate -radix unsigned usb_data_io
add wave -noupdate -radix unsigned usb_clk
add wave -noupdate -radix unsigned usb_rxf_n
add wave -noupdate -radix unsigned usb_txe_n
add wave -noupdate -radix unsigned usb_rd_n
add wave -noupdate -radix unsigned usb_wr_n
add wave -noupdate -radix unsigned usb_oe_n

add wave -divider "TX FIFO"
add wave -noupdate -radix unsigned wr_data
add wave -noupdate -radix unsigned wr_clk
add wave -noupdate -radix unsigned wr_req
add wave -noupdate -radix unsigned wr_full
add wave -noupdate -radix unsigned wr_used

add wave -divider "RX FIFO"
add wave -noupdate -radix unsigned rd_data
add wave -noupdate -radix unsigned rd_clk
add wave -noupdate -radix unsigned rd_req
add wave -noupdate -radix unsigned rd_used


# 6) Set some test patterns

# a = 0, b = 0 at 0 ns
#force a 0 0
#force b 0 0

# 7) Run the simulation for 40 ns
run 1000ms