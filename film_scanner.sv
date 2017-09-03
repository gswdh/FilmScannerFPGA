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
	output wire 		dac_sclk,
						dac_sdin,
						dac_sync,

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
						ft_siwu,
						ft_pwrsav,
						ft_nrst,

	// LEDs
	output reg 			[3:0] led
);

	// Pix signals
	reg pix_clk = 0, pix_valid;
	reg [15:0] pix_data;

	// 80MHz clock
	reg clk_160M;
	
	pll_80	pll_80_inst (
		.inclk0(clk_100M),
		.c0(clk_160M),
		.locked(led[0])
	);


	// CCD timing
	ccd_timings_new ccd0(

		// Input clock
		.clk_160M(clk_160M), .nrst(1),
		.en(1), .cal_mode(1),

		// Clock divisor 0 = divide by 2
		.div(0),

		// CCD control
		.ccd_p1(ccd_p1), 
		.ccd_p2(ccd_p2), 
		.ccd_sh(ccd_sh),
		.ccd_rs(ccd_rs), 
		.ccd_cp(ccd_cp),

		// ADC stuff
		.adc_cs(adc_cs), 
		.adc_sclk(adc_sclk), 
		.adc_sdo(1),

		// Data output 
		.pix_clk(), .pix_out_valid(),
		.pix_data()
	);


	dac dac0(

		// Input control
		.clk_100M(clk_100M),

		// Input data
		.offset(41351), .gain(40097),

		// DAC output signals
		.sclk(dac_sclk),
		.sdata(dac_sdin),
		.sync(dac_sync)
	);


	// Set the ft signals
	always_comb
	begin

		ft_siwu = 1;
		ft_pwrsav = 1;
		ft_nrst = 1;
	end


	usb_ft232h usb0(

		//Avalon-MM Slave
		.clk_i(pix_clk),
		.reset_i(0),
		.address_i(0),
		.read_i(0),
		.readdata_o(),
		.write_i(pix_valid),
		.writedata_i(pix_data[15:8]),

		//FT232H
		.usb_clk_i(ft_clk),
		.usb_data_io(ft_bus),
		.usb_rxf_n_i(ft_rxf),
		.usb_txe_n_i(ft_txe),
		.usb_rd_n_o(ft_rd),
		.usb_wr_n_o(ft_wr),
		.usb_oe_n_o(ft_oe)
	);

endmodule