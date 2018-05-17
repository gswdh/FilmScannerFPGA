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
				rxf_aclr,
				rd_empty;
	logic [8:0]	rd_used;

	// Pixel data IO
	logic		 pix_clk, pix_out_valid;
	logic [15:0] pix_data;

	// Control signals
	logic [17:0] mtr_cont;
	logic [7:0]  led_pwm_val;
	logic 		 scan_en;
	logic [31:0] dac_vals;

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
		.en(scan_en), .cal_mode(0),

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
		.pix_clk(pix_clk), .pix_out_valid(pix_out_valid),
		.pix_data(pix_data)
	);

	// Analogue front end control
	dac dac0(

		// Input control
		.clk_100M(clk_100M),

		// Input data
		.offset(dac_vals[15:0]), .gain(dac_vals[31:16]),

		// DAC output signals
		.sclk(dac_sclk),
		.sdata(dac_sdin),
		.sync(dac_sync)
	);

	// Stepper control
	stepper step0(

		// Inputs
		.clk_100M(clk_100M), .nrst(1),

		// Control logic
		.en(mtr_cont[16]), .dir(mtr_cont[17]),

		.speed(mtr_cont[15:0]),

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
		.rx_aclr(rx_aclr),
		.rx_data(rd_data),
		.rx_nbytes(rd_used),
		.rx_empty(rd_empty),

		// TX FIFO interface (To go to the PC)
		.tx_clk(wr_clk),
		.tx_wrreq(wr_req),
		.tx_full(),
		.tx_data(wr_data),
		.tx_nbytes()
	);

	data_formater form0(

		// Reset
		.nrst(1),

		// Input data
		.rx_clk(pix_clk), .rx_valid(pix_out_valid),
		.rx_data(pix_data),

		// Output data
		.tx_clk(wr_clk), .tx_valid(wr_req),
		.tx_data(wr_data)
	);

	// Create the bus
	logic [113:0]	gs_cont_bus;

	gsbus gs_cont(

		// Clock and reset
		.clk(clk_100M), .nrst(1'b1),

		//  FIFO
		.fifo_clk(rd_clk), .fifo_rdempty(rd_empty),
		.fifo_redreq(rd_req),
		.fifo_data(rd_data),

		// Output bus
		.bus_clk(gs_cont_bus[113]), .bus_valid(gs_cont_bus[112]),
		.bus_data(gs_cont_bus[31:0]),
		.bus_addr(gs_cont_bus[95:32]),
		.bus_gpreg(gs_cont_bus[111:96])
	);

	control cont0(

		// Clock and reset
		.nrst(1'b1),

		// GS bus 
		.bus_clk(gs_cont_bus[113]), .bus_valid(gs_cont_bus[112]),
		.bus_data(gs_cont_bus[31:0]),
		.bus_addr(gs_cont_bus[95:32]),
		.bus_gpreg(gs_cont_bus[111:96]),

			//  control
		.mtr_en(mtr_cont[16]), .mtr_dir(mtr_cont[17]),
		.mtr_speed(mtr_cont[15:0]),

		.led_pwm_val(led_pwm_val),

		.scan_en(scan_en),
		.scan_sub_smpl(), .scan_fr(),

		.dac_gain(dac_vals[31:16]), .dac_offset(dac_vals[15:0])
	);

	assign led[0] = scan_en;


endmodule
