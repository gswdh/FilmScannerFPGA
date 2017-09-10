`timescale 1ns/1ns



module usb_ft232h_tb();


	// Clocks
	reg clk_60M = 0;
	always #8333ps clk_60M = ~clk_60M;
	
	reg clk_1M = 0;
	always #500ns clk_1M = ~clk_1M;

	// USB IO
	logic [7:0]	usb_data_io;
	logic 		usb_clk,
				usb_rxf_n = 1,
				usb_txe_n = 1,
				usb_rd_n,
				usb_wr_n,
				usb_oe_n;

	// Write IO
	logic [7:0]	wr_data = 0;
	logic		wr_clk,
				wr_req = 0,
				wr_used,
				wr_full;

	// Read IO
	logic [7:0]	rd_data;
	logic		rd_clk = 0,
				rd_req = 0,
				rd_used;


	// Signal assignment
	assign usb_clk = clk_60M;
	assign wr_clk = clk_1M;



	// FT232H module
	usb_ft232h usb0(

		// Reset
		.nrst(1), 

		//FT232H
		.usb_clk_i(usb_clk),
		.usb_data_io(usb_data_io),
		.usb_rxf_n_i(usb_rxf_n),
		.usb_txe_n_i(usb_txe_n),
		.usb_rd_n_o(usb_rd_n),
		.usb_wr_n_o(usb_wr_n),
		.usb_oe_n_o(usb_oe_n),

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

endmodule