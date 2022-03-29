module stream_encoder (
	// Reset
	input logic 		nrst,

	// Input data
	input logic 		rx_clk, rx_valid,
	input logic [15:0]	rx_data,

	// Output data
	output reg	 		tx_clk, tx_readreq, tx_empty,
	output reg [15:0]	tx_data 
	);


	// Recieved stream data
	ft_rxfifo	ft_rxfifo_inst (

		// Reset
		.aclr(~nrst),

		// Write
		.wrclk(rx_clk),
		.wrreq(rx_valid),
		.data(rx_data),
		.wrfull(),

		// Read
		.rdclk(),
		.rdreq(),
		.rdusedw(),
		.q(),
		.rdempty()
	);

	// Stream data to transmit
	ft_txfifo ft_txfifo_inst(

		// Reset
		.aclr(~nrst),

		// Write
		.wrclk(),
		.wrreq(),
		.data(),
		.wrfull(),
		.wrusedw(),

		// Read
		.rdclk(tx_clk),
		.rdreq(tx_readreq),
		.q(tx_data),
		.rdempty(tx_empty)
	);




endmodule // stream_encoder