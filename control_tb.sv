module control_tb();




	// Clock gen
	reg clk_100M = 0;
	always #5ns clk_100M = ~clk_100M;

	// IO variables
	logic 			usb_rd_clk, usb_rd_valid;
	logic [7:0] 	usb_readdata, usb_rxbytes = 32;

	// Control varibles
	logic 			en;
	logic [15:0] 	gain, off;

	



	// Output some data onto the bus when the read signal is asserted.
	always_ff @ (posedge usb_rd_clk)
	begin

		if(usb_rd_valid == 1)
		begin

			// Decrement the words availble
			usb_rxbytes <= usb_rxbytes - 1;

			// Output some data
			usb_readdata <= $urandom_range(0, 255);
		end
	end








	
	control cont0(

		// Clock and reset
		.clk_100M(clk_100M), .nrst(1),

		// Read interface to the USB module
		.usb_rd_clk(usb_rd_clk),
		.usb_rd_valid(usb_rd_valid),
		.usb_readdata(usb_readdata),
		.usb_rxbytes(usb_rxbytes),

		// Output of the control information
		.cont_en(en),				// Enable to start scanning
		.cont_gain(gain), .cont_off(off)		// The analogue gain and offset for the front end
	);



endmodule // control_tb