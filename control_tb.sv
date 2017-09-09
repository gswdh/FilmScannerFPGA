module control_tb();




	// Generate the clock
	reg clk_100M = 0;
	always #5ns clk_100M = ~clk_100M;





	reg [8:0]	bytes_availble = 50;
	reg 		read_valid;




	always_ff @ (negedge read_valid) bytes_availble <= 0;




	control cont0(

		// Clock and reset
		.clk_100M(clk_100M), .nrst(1),

		// Interface to the formatter
		.data_valid(),
		.data(),
		.data_clk(),

		// Interface to the FT232H
		.usb_clk(), .usb_reset(),
		.usb_address(),
		.usb_read_valid(read_valid),
		.usb_readdata(1),
		.usb_write_valid(),
		.usb_writedata(),
		.usb_rxbytes(bytes_availble),

		// Output of the control information
		.cont_en(),				// Enable to start scanning
		.cont_gain(), .cont_off()		// The analogue gain and offset for the front end
	);













endmodule // control_tb