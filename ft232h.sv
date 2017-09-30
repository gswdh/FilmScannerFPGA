module ft_232h(

	// Reset
	input logic 		nrst,

	// FT Bus
	inout wire [7:0] 	ft_bus,

	input logic 		ft_clk,
						ft_txe,
						ft_rxf,

	output reg 			ft_wr,
						ft_rd,
						ft_oe,

	// RX FIFO interface (From the PC)
	input logic 		rx_clk,
						rx_rdreq,
	output reg	[7:0]	rx_data,
	output reg  [8:0]	rx_nbytes,

	// TX FIFO interface (To go to the PC)
	input logic 		tx_clk,
						tx_rdreq,
						tx_full,
	input logic	[7:0]	tx_data

	);

	// RX FIFO Signals
	logic 			rxf_wrclk,
					rxf_wrfull,
					rxf_wrreq;
	logic [7:0]		rxf_wrdata;

	// RX FIFO
	ft_rxfifo	ft_rxfifo_inst (

		// Write
		.wrclk(rxf_wrclk),
		.wrreq(rxf_wrreq),
		.data(rxf_wrdata),
		.wrfull(rxf_wrfull),

		// Read
		.rdclk(rx_clk),
		.rdreq(rx_rdreq),
		.rdusedw(rx_nbytes),
		.q(rx_data)
	);





	// FT232H module
	ft232h_fifos_interface usb_ft232h_fifo_int (
		
		// Reset
		.reset_i(~nrst),

		// FT232H
		.usb_clk_i(ft_clk),
		.usb_data_io(ft_bus),
		.usb_rxf_n_i(ft_rxf),
		.usb_txe_n_i(ft_txe),
		.usb_rd_n_o(ft_rd),
		.usb_wr_n_o(ft_wr),
		.usb_oe_n_o(ft_oe),

		// RX FIFO (Recieve from the PC)
		.rxf_wrclk_o(rxf_wrclk),
		.rxf_wrfull_i(rxf_wrfull),
		.rxf_wrreq_o(rxf_wrreq),
		.rxf_wrdata_o(rxf_wrdata),

		// TX FIFO (Send data to the PC)
		.txf_rdclk_o(),
		.txf_rdempty_i(),
		.txf_rdreq_o(),
		.txf_rddata_i()
	);

endmodule // ft_232h