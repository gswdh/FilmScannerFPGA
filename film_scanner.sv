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
	output reg 			mtr_nen,
						mtr_step, 
						mtr_nrst, 
						mtr_slp, 
						mtr_decay, 
						mtr_dir, 

	output reg  [2:0] 	mtr_m,

	input logic 		mtr_nhome, mtr_nflt,

	// FT Bus
	inout wire [7:0] 	ft_bus,

	input logic 		ft_clk,
						ft_txe,
						ft_rxf,
						ft_ac8,
						ft_ac9,

	output reg 			ft_wr,
						ft_rd,
						ft_oe,

						ft_siwu,
						ft_pwrsav,
						ft_nrst,

	// LEDs
	output reg 			[3:0] led
);	

	// Set the ft signals
	always_comb
	begin

		ft_siwu = 1;
		ft_pwrsav = 1;
		ft_nrst = 1;
	end

	// USB FIFO IO
	logic [7:0]	wr_data = 0;
	logic		wr_clk = 0,
				wr_req = 0,
				wr_full;
	logic [8:0]	wr_used;

	// Read IO
	logic [7:0]	rd_data;
	logic		rd_clk,
				rd_req = 0,
				rxf_aclr;
	logic [8:0]	rd_used;

	// Control IO
	reg en = 0;

	// 160MHz clock
	reg clk_160M;
	
	// Generate the 160MHz clock
	pll_80	pll_80_inst (
		.inclk0(clk_100M),
		.c0(clk_160M),
		.locked()
	);

	// CCD timing
	ccd_timing ccd0(

		// Input clock
		.clk_160M(clk_160M), .nrst(1),
		.en(en), .cal_mode(1),

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
		.adc_sdo(adc_sdo),

		// Data output 
		.pix_clk(), .pix_out_valid(),
		.pix_data()
	);

	// Analogue front end control
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


	// Control the scanner
	control cont0(

		// Clock and reset
		.clk_100M(clk_100M), .nrst(1),

		// Read interface to the USB module
		.usb_rd_clk(rd_clk),
		.usb_rd_valid(rd_req),
		.usb_rd_reset(rxf_aclr),
		.usb_readdata(rd_data),
		.usb_rxbytes(rd_used),

		// Output of the control information
		.cont_en(en),				// Enable to start scanning
		.cont_gain(), .cont_off()		// The analogue gain and offset for the front end
	);

	// FT232H
	ft_232h ft0(

		// Reset
		.nrst(1),

		// FT Bus
		.ft_bus(ft_bus),

		.ft_clk(ft_clk),
		.ft_txe(ft_txe),
		.ft_rxf(ft_rxf),

		.ft_wr(ft_wr),
		.ft_rd(ft_rd),
		.ft_oe(ft_oe),

		// RX FIFO interface (From the PC)
		.rx_clk(rd_clk),
		.rx_rdreq(rd_req),
		.rx_data(rd_data),
		.rx_nbytes(rd_used),

		// TX FIFO interface (To go to the PC)
		.tx_clk(),
		.tx_rdreq(),
		.tx_full(),
		.tx_data()
	);
	

endmodule
