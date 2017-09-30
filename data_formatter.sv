module data_formater(

	// Reset
	input logic 		nrst,

	// Input data
	input logic 		rx_clk, rx_valid,
	input logic [15:0]	rx_data,

	// Output data
	output reg	 		tx_clk, tx_valid,
	output reg [7:0]	tx_data
	);

	// Put the clocks through
	assign tx_clk = rx_clk;

	// Intermediatry data
	reg [7:0] 	rx_data_int;
	reg [7:0] 	tx_data_int;
	reg 		tx_valid_int;

	// Make the output data
	assign rx_data_int = (rx_data == 255) ? 254 : rx_data;

	// rx_valid falling edge captue
	reg [1:0]	rx_valid_cap = 0;

	// Fallign edge sginal
	reg rx_valid_fall = 0;


	// Put the data through
	always_ff @ (posedge rx_clk or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			rx_valid_cap <= 0;
			tx_valid_int <= 0;
			tx_data_int <= 0;
		end

		// Run
		else
		begin

			// Clock the valid signal through the regs
			rx_valid_cap[0] <= rx_valid;
			rx_valid_cap[1] <= rx_valid_cap[0];


			// There's been a fallign edge (end of line)
			if(rx_valid_fall == 1)
			begin

				tx_valid_int <= 1;
				tx_data_int <= 255;
			end

			// Else just chuck out the the incoming data
			else
			begin

				tx_data_int <= rx_data_int;
				tx_valid_int <= rx_valid;
			end
		end
	end


	// Capture a falling edge
	always_ff @ (negedge rx_clk or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			rx_valid_fall <= 0;
		end

		// Run
		else
		begin	

			// Output true if there's a falling edge
			if(~rx_valid_cap[0] && rx_valid_cap[1]) rx_valid_fall <= 1;
			else rx_valid_fall <= 0;

		end
	end

	// Output the data
	always_ff @ (negedge tx_clk or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			tx_valid <= 0;
			tx_data <= 0;
		end

		// Run
		else
		begin	

			// Output
			tx_valid <= tx_valid_int;
			tx_data <= tx_data_int;
		end
	end





endmodule // data_formater