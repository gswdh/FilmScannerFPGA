`timescale 1ns/1ns
module data_formatter_tb();

		// Input data
	logic 			rx_clk = 0, rx_valid = 0;
	logic [15:0]	rx_data = 0;

	// Output data
	reg	 			tx_clk = 0, tx_valid = 0;
	reg [7:0]		tx_data = 0;



	// Clock
	reg clk_2M = 0;
	always #250 clk_2M <= ~clk_2M;


	// Counter
	reg [15:0]	counter = 0;

	always_ff @ (posedge clk_2M)
	begin

		counter <= counter + 1;
	end





	always_ff @ (negedge clk_2M)
	begin


		rx_data <= $urandom_range(0, 65535);

		// Make the data valid
		if(counter == 10) rx_valid <= 1;

		// Make the data not valid
		if(counter == 20) rx_valid <= 0;
	end




	data_formater form0(

		// Reset
		.nrst(1),

		// Input data
		.rx_clk(clk_2M), .rx_valid(rx_valid),
		.rx_data(rx_data),

		// Output data
		.tx_clk(tx_clk), .tx_valid(tx_valid),
		.tx_data(tx_data)
	);








endmodule // data_formatter_tb