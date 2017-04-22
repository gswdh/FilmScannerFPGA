module control(

	// Input control
	input logic 		clk_100M,
						
	// Data input
	input logic [7:0]	data,

	input logic 		data_rdy,

	output reg	 		data_clk = 0,

	// Output control
	output reg [7:0]	run = 0,

	// Analogue front end control
	output reg [15:0]	dac_gain = 0, 
						dac_offset = 0,

	// Lines to scan
	output reg [23:0]	lines = 0,

	// Resolution setting (divider of max, multiplier for motor speed) reso_div = divider - 1
	output reg [7:0]	reso_div = 0,

	// LED Brightness
	output reg [7:0]	led_pwm_div = 0





);
















endmodule