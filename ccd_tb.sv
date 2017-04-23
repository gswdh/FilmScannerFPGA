module ccd_tb(

);





	reg	adc_cs, adc_sclk, adc_sdo;


	reg clk_80M = 0;

	always #6250ps clk_80M = ~clk_80M;



	// CCD timing
	ccd_timing ccd0(

		// Input clock
		.clk_80M(clk_80M),

		// CCD control
		.ccd_p1(), 
		.ccd_p2(), 
		.ccd_sh(),
		.ccd_rs(), 
		.ccd_cp(),

		// ADC stuff
		.adc_cs(adc_cs), 
		.adc_sclk(adc_sclk), 
		.adc_sdo(adc_sdo)
	);


endmodule