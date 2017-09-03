module ccd_tb(

);


	reg	adc_cs, adc_sclk, adc_sdo, pix_clk;

	reg [15:0] pix_data;

	reg clk_160M = 0;

	always #3125ps clk_160M = ~clk_160M;



	// CCD timing
	ccd_timings_new ccd0(

		// Input clock
		.clk_160M(clk_160M), .nrst(1),
		.en(1), .cal_mode(1),

		// Clock divisor 0 = divide by 2
		.div(0),

		// CCD control
		.ccd_p1(), 
		.ccd_p2(), 
		.ccd_sh(),
		.ccd_rs(), 
		.ccd_cp(),

		// ADC stuff
		.adc_cs(adc_cs), 
		.adc_sclk(adc_sclk), 
		.adc_sdo(1),

		// Data output 
		.pix_clk(pix_clk), .pix_out_valid(),
		.pix_data(pix_data)
	);


endmodule