`timescale 1ns/1ns

module usb_ft232h_tb();


	// Clocks
	reg clk_60M = 0;
	always #8333ps clk_60M = ~clk_60M;
	
	reg clk_10M = 0;
	always #50ns clk_10M = ~clk_10M;

	// USB IO
	wire [7:0]	usb_data_io;
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
				wr_full;
	logic [8:0]	wr_used;

	// Read IO
	logic [7:0]	rd_data;
	logic		rd_clk,
				rd_req = 0;
	logic [8:0]	rd_used;

	// Signal assignment
	assign usb_clk = clk_60M;
	assign wr_clk = clk_10M;
	assign rd_clk = clk_10M;



	/*
		Operate the bidrectional port
	*/

	logic [7:0]	usb_data;

	assign usb_data_io = usb_oe_n ? 8'bZ : usb_data;


	/*
		BEGIN: Read from the USB simulation
	*/

	reg [7:0]	usb_state = 0, usb_cntr = 0;

	// First off we need to write data into the USB controller
	always_ff @ (posedge usb_clk)
	begin

		// End sim
		if(usb_state == 255) $stop;

		// Else continue
		else usb_state <= usb_state + 1;


		// Clock some data out if the rd signal is pulled low
		if(usb_rd_n == 0)
		begin

			usb_data <= $urandom_range(0, 255);
		end

		// State machine
		case(usb_state)

			// WAssert the rxf signal
			3: begin
			
				usb_rxf_n <= 0;
			end

			// Dissasert the rxf signal
			20: begin

				usb_rxf_n <= 1;
			end
		endcase // usb_state
	end

	always_ff @ (negedge rd_clk)
	begin

		if(usb_state > 80) rd_req <= 1;
	end






	reg [7:0]	rd_state = 0, rd_cntr = 10;

	always_ff @ (negedge rd_clk)
	begin

		case(rd_state)

			// Wait one clock cycle
			0: begin

				//rd_state <= rd_state + 1;
			end

			// Start clocking data into the FIFO
			1: begin

				//if(rd_cntr == 10) rd_req <= 1;
				//if(rd_cntr == 15) rd_req <= 0;

				// Set the txe singal low when all the data is in the FIFO
				//if(rd_cntr == 20) usb_txe_n <= 0;

				
			end
		endcase // rd_state
	end


	/*
		END: Write to USB simulation
	*/


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