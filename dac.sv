/*



DAC is updated when there is a chnage in input data.



*/
module dac(

	// Input control
	input logic 		clk_100M,

	// Input data
	input logic [15:0]	offset, gain,

	// DAC output signals
	output reg 			sclk = 1,
						sdata = 0,
						sync = 1
	);

	// DAC PARAMETERS
	parameter DAC_LOAD_A = 1048576;
	parameter DAC_LOAD_B = 2359296;

	// Clock divisor 
	reg [4:0] clk_2MHz_cntr = 0;

	// 1MHz clock
	reg clk_2MHz = 0;

	// Create a 1MHz clock
	always_ff @ (posedge clk_100M)
	begin

		// Threshold reached 
		if(clk_2MHz_cntr == 24)
		begin

			// Invert the clock
			clk_2MHz <= ~clk_2MHz;

			// Reset the counter
			clk_2MHz_cntr <= 0;
		end

		// Else keep counting
		else clk_2MHz_cntr <= clk_2MHz_cntr + 1;
	end



	// Local values for the offset and gain
	reg [15:0] this_offset = 0, this_gain = 0;

	// Previous values for the offset and gain
	reg [15:0] this_prev_offset = 0, this_prev_gain = 0;

	// Previous values for the offset and gain
	reg [23:0] dac_offset = 0, dac_gain = 0;

	// Start the state machine variable to initiate one conversion to start with
	reg [7:0] dac_state = 1;

	// Bit counter for serially clocking out
	reg [4:0] bit_cntr = 0;

	// Clock out on the 2MHz clock for a 1MHz output
	always_ff @ (posedge clk_2MHz)
	begin

		// Clock in the new data to the local variables
		this_offset <= offset;
		this_gain <= gain;

		// Use a state machine to clock out the data
		case(dac_state)

			// If there is a change in input value start a conversion
			0: begin

				// Change, increment the machine
				if((this_offset !== this_prev_offset) | (this_gain !== this_prev_gain))
				begin

					// Increment
					dac_state <= dac_state + 1;

					// Make sure the sync is high
					sync <= 1;
				end

				// Else stay here
				else dac_state <= 0;
			end

			// Create the DAC values for clocking out
			1: begin

				// Get the new values for conversion
				dac_gain <= this_gain && DAC_LOAD_A;
				dac_offset <= this_offset && DAC_LOAD_B;

				// Set the SYNC line low to start the conversion
				sync <= 0;

				// Clock to high
				sclk <= 1;

				// Reset the bit counter
				bit_cntr <= 0;

				// Progress
				dac_state <= dac_state + 1;
			end

			// Now start the conversion for the gain
			2: begin

				// Assess the progress
				if(bit_cntr !== 23)
				begin
					// Clock the bit out on the falling edge
					sdata <= dac_gain[23 - bit_cntr];

					// Increment the bit cntr
					bit_cntr <= bit_cntr + 1;

					// Create the rising edge
					sclk <= 1;

					// Go to the falling edge
					dac_state <= 3;
				end

				// If we are done move onto the offset after clocing the last bit
				else 
				begin

					// Clock the bit out on the falling edge
					sdata <= dac_gain[0];

					// Reset the bit cntr
					bit_cntr <= 0;

					// Create the rising edge
					sclk <= 1;

					// Move on
					dac_state <= 4;
				end
			end

			// Create the rising edge
			3: begin

				// Create the falling edge
				sclk <= 0;

				// Go to the falling edge
				dac_state <= 2;
			end

			// Create a last falling edge
			4: begin

				// 
				sclk <= 0;

				// Progress
				dac_state <= dac_state + 1;
			end

			// Put the sync and clocks high 
			5: begin

				// 
				sync <= 1;
				sclk <= 1;

				// Progress
				dac_state <= dac_state + 1;
			end

			// 
			6: begin

				// Pull the sync low for the next conversion
				sync <= 0;

				// Progress
				dac_state <= dac_state + 1;
			end

			// Now start the conversion for the offset
			7: begin

				// Assess the progress
				if(bit_cntr !== 23)
				begin
					// Clock the bit out on the rising edge
					sdata <= dac_offset[23 - bit_cntr];

					// Increment the bit cntr
					bit_cntr <= bit_cntr + 1;

					// Create the rising edge
					sclk <= 1;

					// Go to the rising edge
					dac_state <= 8;
				end

				// If we are done move onto the offset after clocing the last bit
				else 
				begin

					// Clock the bit out on the rising edge
					sdata <= dac_offset[0];

					// Reset the bit cntr
					bit_cntr <= 0;

					// Create the rising edge
					sclk <= 1;

					// Move on
					dac_state <= 9;
				end
			end

			// Create the falling edge
			8: begin

				// Create the falling edge
				sclk <= 0;

				// Go to the rising edge
				dac_state <= 6;
			end

			// Create the last falling edge
			9: begin

				// Pull the sync low for the next conversion
				sclk <= 0;

				// Progress
				dac_state <= dac_state + 1;
			end

			// Reset all the variables
			10: begin

				// Clock and sync to stay high
				sync <= 1;
				sclk <= 1;

				// Assign the previous values 
				this_prev_gain <= dac_gain && 65535;
				this_prev_offset <= dac_offset && 65535;

				// Reset the state machine
				dac_state <= 0;
			end
		endcase // dac_state
	end
endmodule // dac