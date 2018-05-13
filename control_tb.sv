module control_tb();




	// Clock gen
	reg clk_100M = 0;
	always #5ns clk_100M = ~clk_100M;

	// IO variables
	reg valid = 1;
	reg [63:0]	addr = 0;
	reg [31:0]	data = 0;


	// Output some data onto the bus when the read signal is asserted.
	always_ff @ (negedge clk_100M)
	begin

		valid <= 1;
		addr <= addr + 1;
		data = $urandom_range(0, 65535);
	end


	
	control cont0(

		// Clock and reset
		.nrst(1'b1),

		// GS bus 
		.bus_clk(clk_100M), .bus_valid(valid),
		.bus_data(data),
		.bus_addr(addr),
		.bus_gpreg(0),

			//  control
		.mtr_en(), .mtr_dir(),
		.mtr_speed(),

		.led_pwm_val(),

		.scan_en(),
		.scan_sub_smpl(), .scan_fr(),

		.dac_gain(), .dac_offset()
	);



endmodule // control_tb