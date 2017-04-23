module ccd_timing(

	// Input clock and control
	input logic 		clk_80M,
						en, cal_mode,


	// CCD control
	output reg 			ccd_p1 = 1, 
						ccd_p2, 
						ccd_sh = 0,
						ccd_rs = 0, 
						ccd_cp = 0,

	// ADC signals
	output reg			adc_cs = 0, 
						adc_sclk = 0, 

	input logic 		adc_sdo,

	// Output data
	output reg			pix_clk,
	output reg [15:0]	pix_data = 0

	);


	// p1 is always opposite to p2
	assign ccd_p2 = ~ccd_p1; 

	// Compensation was needed for propagtion through the level shifters
	parameter P1_HIGH = 4;
	parameter P1_LOW = 24;
	parameter RS_HIGH = 1;
	parameter RS_LOW = 5;
	parameter CP_HIGH = 8;
	parameter CP_LOW = 14;

	// ADC output timings
	parameter CS_LOW = 29;
	parameter D15_HIGH = CS_LOW + 1;
	parameter D15_LOW = D15_HIGH + 1;
	parameter D14_HIGH = D15_LOW + 1;
	parameter D14_LOW = D14_HIGH + 1;
	parameter D13_HIGH = D14_LOW + 1;
	parameter D13_LOW = D13_HIGH + 1;
	parameter D12_HIGH = D13_LOW + 1;
	parameter D12_LOW = D12_HIGH + 1;
	parameter D11_HIGH = D12_LOW + 1;
	parameter D11_LOW = D11_HIGH + 1;
	parameter D10_HIGH = 0;
	parameter D10_LOW = D10_HIGH + 1;
	parameter D9_HIGH = D10_LOW + 1;
	parameter D9_LOW = D9_HIGH + 1;
	parameter D8_HIGH = D9_LOW + 1;
	parameter D8_LOW = D8_HIGH + 1;
	parameter D7_HIGH = D8_LOW + 1;
	parameter D7_LOW = D7_HIGH + 1;
	parameter D6_HIGH = D7_LOW + 1;
	parameter D6_LOW = D6_HIGH + 1;
	parameter D5_HIGH = D6_LOW + 1;
	parameter D5_LOW = D5_HIGH + 1;
	parameter D4_HIGH = D5_LOW + 1;
	parameter D4_LOW = D4_HIGH + 1;
	parameter D3_HIGH = D4_LOW + 1;
	parameter D3_LOW = D3_HIGH + 1;
	parameter D2_HIGH = D3_LOW + 1;
	parameter D2_LOW = D2_HIGH + 1;
	parameter D1_HIGH = D2_LOW + 1;
	parameter D1_LOW = D1_HIGH + 1;
	parameter D0_HIGH = D1_LOW + 1;
	parameter D0_LOW = D0_HIGH + 1;
	parameter CS_HIGH = D0_LOW + 1;

	// Timgings of the validity data
	reg [11:0] pix_valid, pix_n_valid;
	reg pix_valid_flag = 0;

	assign pix_valid = cal_mode ? 32 : 1; // Cal mode clocks out all pixels
	assign pix_n_valid = cal_mode ? 2080 : 2088; // Cal mode clocks out all pixels

	// Create the pix_clk
	assign pix_clk = pix_valid_flag ? ~adc_cs : 0;

	// ADC data variable
	reg [15:0]	adc_data = 0;

	// Clock the data out on the negedge of the pix clk
	always_ff @ (negedge pix_clk) pix_data <= adc_data;

	// Stop signal
	reg stop = 0;

	// Create a counter to manage the timings from
	reg [7:0] timings_cntr = 0;

	

	// Use the 100MHz clock to create the timings
	always_ff @ (posedge clk_80M)
	begin

		// If we wish to stop
		if(en == 0)
		begin

			// reset the counter
			timings_cntr <= 0;

			// Set the clocks
			ccd_p1 <= 1;
			ccd_rs <= 0; 
			ccd_cp <= 0;

			// ADC signals
			adc_cs <= 1;
			adc_sclk <= 0;
		end

		// Run
		else
		begin

			// If they should run (not SH time)
			if(stop == 1)
			begin

				// reset the counter
				timings_cntr <= 0;

				// Set the clocks
				ccd_p1 <= 1;
				ccd_rs <= 0; 
				ccd_cp <= 0;
			end

			// Run
			else
			begin

				// Run the counter
				if(timings_cntr == 39) timings_cntr <= 0;

				// Increment
				else timings_cntr <= timings_cntr + 1;

				// Create the timings
				case(timings_cntr)

					// CCD outputs
					P1_HIGH: ccd_p1 <= 1;
					P1_LOW: ccd_p1 <= 0;
					RS_HIGH: ccd_rs <= 1;
					RS_LOW: ccd_rs <= 0;
					CP_HIGH: ccd_cp <= 1;
					CP_LOW: ccd_cp <= 0;
				endcase

				// For the ADC
				case(timings_cntr)
					// ADC outputs
					CS_LOW: adc_cs <= 0;
					CS_HIGH: adc_cs <= 1;
					
					D15_HIGH: adc_sclk <= 1;
					D15_LOW: begin
						adc_data[15] <= adc_sdo;
						adc_sclk <= 0;
					end
					D14_HIGH: adc_sclk <= 1;
					D14_LOW: begin
						adc_data[14] <= adc_sdo;
						adc_sclk <= 0;
					end
					D13_HIGH: adc_sclk <= 1;
					D13_LOW: begin
						adc_data[13] <= adc_sdo;
						adc_sclk <= 0;
					end
					D12_HIGH: adc_sclk <= 1;
					D12_LOW: begin
						adc_data[12] <= adc_sdo;
						adc_sclk <= 0;
					end
					D11_HIGH: adc_sclk <= 1;
					D11_LOW: begin
						adc_data[11] <= adc_sdo;
						adc_sclk <= 0;
					end
					D10_HIGH: adc_sclk <= 1;
					D10_LOW: begin
						adc_data[10] <= adc_sdo;
						adc_sclk <= 0;
					end
					D9_HIGH: adc_sclk <= 1;
					D9_LOW: begin
						adc_data[9] <= adc_sdo;
						adc_sclk <= 0;
					end
					D8_HIGH: adc_sclk <= 1;
					D8_LOW: begin
						adc_data[8] <= adc_sdo;
						adc_sclk <= 0;
					end
					D7_HIGH: adc_sclk <= 1;
					D7_LOW: begin
						adc_data[7] <= adc_sdo;
						adc_sclk <= 0;
					end
					D6_HIGH: adc_sclk <= 1;
					D6_LOW: begin
						adc_data[6] <= adc_sdo;
						adc_sclk <= 0;
					end
					D5_HIGH: adc_sclk <= 1;
					D5_LOW: begin
						adc_data[5] <= adc_sdo;
						adc_sclk <= 0;
					end
					D4_HIGH: adc_sclk <= 1;
					D4_LOW: begin
						adc_data[4] <= adc_sdo;
						adc_sclk <= 0;
					end
					D3_HIGH: adc_sclk <= 1;
					D3_LOW: begin
						adc_data[3] <= adc_sdo;
						adc_sclk <= 0;
					end
					D2_HIGH: adc_sclk <= 1;
					D2_LOW: begin
						adc_data[2] <= adc_sdo;
						adc_sclk <= 0;
					end
					D1_HIGH: adc_sclk <= 1;
					D1_LOW: begin
						adc_data[1] <= adc_sdo;
						adc_sclk <= 0;
					end
					D0_HIGH: adc_sclk <= 1;
					D0_LOW: begin
						adc_data[0] <= adc_sdo;
						adc_sclk <= 0;
					end
				endcase // timings_cntr
			end
		end
	end


	// 
	reg [11:0] p1_cntr = 0;

	// Count the rising edges of cp
	always_ff @ (posedge ccd_p1)
	begin

		// Halt
		if(en == 0)
		begin 

			p1_cntr <= 0;
		end

		// Run
		else 
		begin

			// 
			if(p1_cntr == 2100)
			begin

				// 
				p1_cntr <= 0;
			end

			// Increment
			else p1_cntr <= p1_cntr + 1;
		end
	end

	// A state machine to determine the Validity of the data
	always_ff @ (negedge ccd_p1)
	begin

		// Halt
		if(en == 0)
		begin

			pix_valid_flag <= 0;
		end

		// Run
		else
		begin

			// To determine the output clock
			case(p1_cntr)

				pix_valid: pix_valid_flag <= 1;

				pix_n_valid: pix_valid_flag <= 0;
			endcase
		end
	end

	// SH state machine variable
	reg [7:0] sh_state = 0, sh_delay = 0;

	// Now we need to create the SH signal
	always_ff @ (posedge clk_80M)
	begin

		// Halt
		if(en == 0)
		begin

			// Reset the state
			sh_state <= 0;

			stop <= 0;

			ccd_sh <= 0;

			sh_delay <= 0;
		end

		// Run
		else
		begin

			case(sh_state)

				// Stop the clocks
				0: begin

					// Halt the clocks now were are at the end of the line
					if(p1_cntr == 2100)
					begin

						// Stop
						stop <= 1;

						// Make sure sh is 0
						ccd_sh <= 0;

						// Progress
						sh_state <= 1;
					end
				end

				// Delay for 500ns with sh low
				1: begin

					// 
					ccd_sh <= 0;

					// 
					if(sh_delay == 39)
					begin

						// 
						sh_delay <= 0;

						// 
						sh_state <= 2;
					end

					//
					else sh_delay <= sh_delay + 1;
				end

				// Delay for 50ns with sh high
				2: begin

					// 
					ccd_sh <= 1;

					// 
					if(sh_delay == 3)
					begin

						// 
						sh_delay <= 0;

						// 
						sh_state <= 3;
					end

					//
					else sh_delay <= sh_delay + 1;
				end

				// Delay for 500ns with sh low
				3: begin
					
					// 
					ccd_sh <= 0;

					// 
					if(sh_delay == 39)
					begin

						// 
						sh_delay <= 0;

						// 
						sh_state <= 4;
					end

					//
					else sh_delay <= sh_delay + 1;
				end

				// Start the clocks
				4: begin

					// Stop = 0
					stop <= 0;

					// Delay to wait for the p2 counter to reset
					if(sh_delay == 255)
					begin

						// 
						sh_delay <= 0;

						// 
						sh_state <= 0;
					end

					//
					else sh_delay <= sh_delay + 1;
				end
			endcase // sh_state
		end
	end
endmodule // ccd_timing