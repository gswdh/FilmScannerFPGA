module film_scanner(

	// Input control
	input logic 		clk_100M,
						
	// LED back light control
	output reg 			led_pwm = 0,

	// ADC IO
	output reg			adc_cs = 0, 
						adc_sclk = 0, 

	input logic 		adc_sdo,

	// DAC IO
	output reg 			dac_sclk = 0,
						dac_sdin = 0,
						dac_sync = 1,

	// CCD control
	output reg 			ccd_p1, 
						ccd_p2, 
						ccd_sh,
						ccd_rs, 
						ccd_cp,

	// Motor IO
	output reg 			mtr_nen = 1,
						mtr_step = 0, 
						mtr_nrst = 0, 
						mtr_slp = 0, 
						mtr_decay = 0, 
						mtr_dir = 0, 

	output reg  [2:0] 	mtr_m = 0,

	input logic 		mtr_nhome, mtr_nflt,

	// FT Bus
	inout wire [7:0] 	ft_bus,

	input logic 		ft_clk,
						ft_txe,
						ft_rxf,
						ft_ac8,
						ft_ac9,

	output reg 			ft_wr = 1,
						ft_rd = 1,
						ft_siwu = 1,
						ft_pwrsav = 1,
						ft_nrst = 1,
					

	// LEDs
	output reg 			[3:0] led
);

	// 80MHz clock
	reg clk_80M;
	
	pll_80	pll_80_inst (
		.inclk0(clk_100M),
		.c0(clk_80M),
		.locked(led[0])
	);

	// CCD timing
	ccd_timing ccd0(

		// Input clock
		.clk_80M(clk_80M),
		.en(1), .cal_mode(1),

		// CCD control
		.ccd_p1(ccd_p1), 
		.ccd_p2(ccd_p2), 
		.ccd_sh(ccd_sh),
		.ccd_rs(ccd_rs), 
		.ccd_cp(ccd_cp),

		// ADC stuff
		.adc_cs(adc_cs), 
		.adc_sclk(adc_sclk), 
		.adc_sdo(adc_sdo),

		// Data output 
		.pix_clk(led[1]),
		.pix_data()
	);










endmodule