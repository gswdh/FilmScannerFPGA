module dataformtter 
	(

		// Clock and reset
		input logic 		clk_100M, nrst,

		// Error signal (when FIFO is full)
		output reg 			error,

		// Output data
		input logic 		pix_in_clk, pix_in_valid,
		input logic [15:0]	pix_in_data,

		// Output data
		output reg 			pix_out_clk = 0, pix_out_valid = 0,
		output reg [7:0]	pix_out_data,
	);

	// Divide the clk_100M for an output clock (divide by 8)
	reg [1:0] clk_div = 0;

	// 
	always_ff @ (posedge clk_100M pr negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			pix_out_clk <= 0;
			clk_div <= 0;
		end

		// Run
		else
		begin

			// Divide the clock
			if(clk_div == 3)
			begin

				pix_out_clk <= ~pix_out_clk;

				clk_div <= 0;
			end

			else clk_div <= clk_div + 1;
		end
	end


	// Internal signals
	reg [15:0] 	pix_data;
	reg 		pix_valid = 0;

	// If the data is valid, input the data over two bytes with the MSBs = 0, else it's 255
	assign pix_data = (pix_in_valid) ? {0, pix_in_data[15:9], 0, pix_in_data[8:2]} : 65536;

	// Here, we will delay the pix_in_valid signal by one to drop the first word and add a dummy 65536 onto the end
	always_ff @ (negedge pix_in_clk or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			pix_valid <= 0;
		end

		// Run
		else
		begin

			pix_valid <= pix_in_valid;
		end
	end

	// Instantiate the FIFO
	pix_data_fifo pix_data_fifo_inst 
	(
		// Write signals
		.wrclk(pix_in_clk),
		.wrreq(pix_valid),
		.data(pix_data),
		.wrfull(error),

		// Read signals
		.rdclk(pix_out_clk),
		.rdreq(pix_out_valid),
		.q(pix_out_data),			
		.rdempty(),	
	);























endmodule // dataformtter