module control(

	// Clock and reset
	input logic 		clk_100M, nrst,

	// Read interface to the USb module
	output reg 			usb_rd_clk,
	output reg	 		usb_rd_valid = 0,
	input logic [7:0] 	usb_readdata,
	input logic [7:0]	usb_rxbytes,

	// Output of the control information
	output reg			cont_en,				// Enable to start scanning
	output reg [15:0]	cont_gain, cont_off		// The analogue gain and offset for the front end
);

	// Parameters for the USB interface
	localparam WRDATA_ADDR	  = 4'd0;
	localparam RDDATA_ADDR	  = 4'd1;
	localparam TXSTATUSL_ADDR = 4'd2;
	localparam TXSTATUSH_ADDR = 4'd3;
	localparam RXSTATUSL_ADDR = 4'd4;
	localparam RXSTATUSH_ADDR = 4'd5;

	// Assign the clocks
	assign usb_rd_clk = clk_100M;
	assign data_clk = clk_100M;

	// Two varibales to store the conrtrol information, one temp and another regd
	reg [255:0]	control_reg = 0;
	reg [7:0] c_temp[32];

	// Assign the output data
	assign cont_en = control_reg[0];		// Enable flag
	assign cont_gain = control_reg[24:8];	// Analogue front end gain setting
	assign cont_off = control_reg[40:25];	// Analogue front end offset setting

	// State machine variable
	reg [7:0]	state = 0;

	// Counter to count the bytes out of the FIFO
	reg [5:0]	byte_cntr = 0;

	// In this state machine we prioritse the reading of data
	always_ff @ (negedge usb_rd_clk or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

		end

		// Run
		else
		begin

			// State machine to clock data in and out of the USB FIFOs with prority on reads
			case(state)

				// Fork to read or write
				0: begin

					// If we have recieved a control packet
					if(usb_rxbytes > 31)
					begin

						// Go to read them out
						state <= 1;

						// Assert the read request
						usb_rd_valid <= 1;

						// Reset the byte counter
						byte_cntr <= 0;
					end
				end

				// Start reading from the FIFO
				1: begin

					// Wait until we have enough clock cylces before we read anything!
					if(byte_cntr == 31)
					begin

						// Last byte
						c_temp[31] <= usb_readdata;

						// Stop reading
						usb_rd_valid <= 0;

						// Progress
						state <= 2;
					end

					// Just wait otherwise
					else 
					begin

						// Write into the temps
						c_temp[byte_cntr] <= usb_readdata;
						byte_cntr <= byte_cntr + 1;
					end
				end 

				// Latch the new values into the actualy control register and return to the beginning
				2: begin

					// New valeus
					control_reg <= {c_temp[31], c_temp[30], c_temp[29], c_temp[28], c_temp[27], 
									c_temp[26], c_temp[25], c_temp[24], c_temp[23], c_temp[22], 
									c_temp[21], c_temp[20], c_temp[19], c_temp[18], c_temp[17], 
									c_temp[16], c_temp[15], c_temp[14], c_temp[13], c_temp[12], 
									c_temp[11], c_temp[10], c_temp[9], 	c_temp[8], 	c_temp[7], 
									c_temp[6], 	c_temp[5], 	c_temp[4], 	c_temp[3], 	c_temp[2], 
									c_temp[1], 	c_temp[0]};

					// Return to the beginning
					state <= 0;
				end
			endcase // state
		end
	end




















endmodule // control