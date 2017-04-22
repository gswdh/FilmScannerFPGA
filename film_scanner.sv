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
	output reg 			ccd_p1 = 0, 
						ccd_p2 = 0, 
						ccd_sh = 0,
						ccd_rs = 0, 
						ccd_cp = 0,

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
						ft_nrst = 0,

	// LEDs
	output reg 			[3:0] led
);
















endmodule