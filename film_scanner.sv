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

	// en reg (won't be here for long)
	reg en;

	// Assign the LEDs
	//assign led[0] = 1;	// Just an on LED
	//assign led[1] = en;	// On while scanning
	//assign led[2] = 0;	// Undecided
	//assign led[3] = 0;	// Undecided


	// Pix signals
	reg pix_clk = 0, pix_valid;
	reg [15:0] pix_data;

	// 80MHz clock
	reg clk_160M;
	
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
		.pix_clk(pix_clk), .pix_out_valid(pix_valid),
		.pix_data(pix_data)
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

	
	// Write IO
	logic [7:0]	wr_data = 0;
	logic		wr_clk = 0,
				wr_req = 0,
				wr_full;
	logic [8:0]	wr_used;

	// Read IO
	logic [7:0]	rd_data;
	logic		rd_clk = 0,
				rd_req = 0;
	logic [8:0]	rd_used;

	// FT232H module
	usb_ft232h usb0(

		// Reset
		.nrst(1), 

		//FT232H
		.usb_clk_i(ft_clk),
		.usb_data_io(ft_bus),
		.usb_rxf_n_i(ft_rxf),
		.usb_txe_n_i(ft_txe),
		.usb_rd_n_o(ft_rd),
		.usb_wr_n_o(ft_wr),
		.usb_oe_n_o(ft_oe),

		// Read port
		.rxf_rdclk_i(rd_clk),		// Read clock
		.rxf_rdreq_i(rd_req),		// Read request
		.rxf_rddata_o(rd_data),		// Data read
		.rxf_rdusedw_o(rd_used),	// Number of bytes in the FIFO

		// Write port
		.txe_wrclk_i(wr_clk),		// Write clock
		.txe_wrreq_i(wr_req),		// Write request
		.txe_wrdata_i(wr_data),		// Data to write
		.txe_wrusedw_o(wr_used),	// FIFO status
		.txe_wrfull_o(wr_full)		// FIFO full signal
	);


/*
	//assign led[2] = usb_read_valid;	// Undecided
	
	control cont0(

		// Clock and reset
		.clk_100M(clk_100M), .nrst(1),

		// Interface to the formatter
		.data_valid(),
		.data(),
		.data_clk(),

		
		// Interface to the FT232H
		.usb_clk(usb_clk), .usb_reset(usb_reset),
		.usb_address(usb_address),
		.usb_read_valid(usb_read_valid),
		.usb_readdata(usb_readdata),
		.usb_write_valid(usb_write_valid),
		.usb_writedata(usb_writedata),
		.usb_rxbytes(usb_rxbytes),
		

		.usb_rd_clk(usb_clk), .usb_reset(),
		.usb_rd_valid(usb_read_valid),
		.usb_readdata(usb_readdata),
		.usb_rxbytes(usb_rxbytes),


		// Output of the control information
		.cont_en(en),				// Enable to start scanning
		.cont_gain(), .cont_off(),		// The analogue gain and offset for the front end

		.leds(led)
	);
*/

/*


	stepper step0(

	// Inputs
	.clk_100M(clk_100M), .nrst(1),

	// Control logic
	.en(1), .dir(0),

	.speed(),

	// Motor outputs
	.mtr_nen(mtr_nen),
	.mtr_step(mtr_step), 
	.mtr_nrst(mtr_nrst), 
	.mtr_slp(mtr_slp), 
	.mtr_decay(mtr_decay), 
	.mtr_dir(mtr_dir), 

	.mtr_m(mtr_m),

	.mtr_nhome(), .mtr_nflt()

	);
	*/
endmodule