module ccd_timing
	(

	// Input clock and control
	input logic 		clk_160M, nrst,
						en, cal_mode,

	// Clock divisor 0 = divide by 2
	input logic [7:0]	div,


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
	output reg			pix_clk, pix_out_valid,
	output reg [15:0]	pix_data = 0

	);


	// Timings clock
	reg clk_timings = 0;

	// Timings contuer
	reg clk_timings_cntr = 0;

	// Create the timings clock
	always_ff @ (posedge clk_160M or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			clk_timings <= 0;
			clk_timings_cntr <= 0;
		end

		// Run
		else
		begin

			// Divide the clock to div
			if(clk_timings_cntr == div)
			begin

				// Invert the clock
				clk_timings <= ~clk_timings;

				// Reset the counter
				clk_timings_cntr <= 0;
			end

			// Else count to the div
			else clk_timings_cntr <= clk_timings_cntr + 1;
		end
	end

	// p1 is always opposite to p2
	assign ccd_p2 = ~ccd_p1; 

	// Start numbers for a new line
	parameter P1_HIGH_SH = 0;
	parameter RS_HIGH_SH = 21;
	parameter RS_LOW_SH = 26;	
	parameter CP_HIGH_SH = 31;
	parameter CP_LOW_SH = 36;
	parameter SH_HIGH = 41;
	parameter SH_LOW = 61;	
	parameter RS_HIGH_SH2 = 70;
	parameter RS_LOW_SH2 = 74;	
	parameter CP_HIGH_SH2 = 78;
	parameter CP_LOW_SH2 = 81;
	parameter P1_LOW_SH = 80;

	// Compensation was needed for propagtion through the level shifters
	parameter P1_LOW = 120;
	parameter RS_HIGH = 132;	
	parameter RS_LOW = 136;
	parameter CP_HIGH = 140;
	parameter CP_LOW = 144;
	parameter P1_HIGH = 139;

	// ADC output timings
	parameter D0_LOW = 159;				// Start of the sample
	parameter CS_HIGH = 120;
	parameter CS_LOW = 127;
	parameter D15_HIGH = CS_LOW + 1;			// Sample stops
	parameter D15_LOW = D15_HIGH + 1;
	parameter D14_HIGH = D15_LOW + 1;
	parameter D14_LOW = D14_HIGH + 1;
	parameter D13_HIGH = D14_LOW + 1;
	parameter D13_LOW = D13_HIGH + 1;
	parameter D12_HIGH = D13_LOW + 1;
	parameter D12_LOW = D12_HIGH + 1;
	parameter D11_HIGH = D12_LOW + 1;
	parameter D11_LOW = D11_HIGH + 1;
	parameter D10_HIGH = D11_LOW + 1;
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
	
	// Timings definitions
	parameter LINE_WAIT = 0;
	parameter LINE_RUN = 1;

	// Create the output pixel data clock
	assign pix_clk = adc_cs;

	// Create a counter to manage the timings from
	reg [7:0] timings_cntr = 4, start_cntr = 0;
	reg [13:0] pixel_cntr = 0;
	reg state = 0;

	// ADC data variable
	reg [15:0]	adc_data = 0;

	// Create a series of counters to time the output signals from
	always_ff @ (posedge clk_timings or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			// Reset the variables
			timings_cntr <= 4;
			start_cntr <= 0;
			pixel_cntr <= 0;
			state <= 0;
		end

		// Run
		else
		begin

			case(state)

				LINE_WAIT: 
				begin

					// Wait for the EN signal to be high
					if(en == 1) state <= LINE_RUN;
					else state <= LINE_WAIT;
				end

				LINE_RUN:
				begin

					// Check to see if the line has finished
					if(pixel_cntr == 2088)
					begin

						// Reset the pixel counter
						pixel_cntr <= 0;

						// Go back to line wait
						state <= LINE_WAIT;

						// Set the timings counter so that P1 is high
						timings_cntr <= 0;
					end

					// If it hasn't
					else 
					begin

						// Progress the timings coutner
						if(timings_cntr == 159)
						begin

							timings_cntr <= 120;

							pixel_cntr <= pixel_cntr + 1;
						end

						else timings_cntr <= timings_cntr + 1;	
					end
				end
			endcase // state
		end
	end

	// Control all the output signals
	always_ff @ (posedge clk_timings or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			// Set the clocks
			ccd_p1 <= 1;
			ccd_rs <= 0; 
			ccd_cp <= 0;

			// ADC data
			adc_data <= 0;
		end

		// Run
		else
		begin

			// Create CCD signals
			case(timings_cntr)

				// CCD outputs
				P1_HIGH: ccd_p1 <= 1;
				P1_LOW: ccd_p1 <= 0;
				RS_HIGH: ccd_rs <= 1;
				RS_LOW: ccd_rs <= 0;
				CP_HIGH: ccd_cp <= 1;
				CP_LOW: ccd_cp <= 0;

				P1_HIGH_SH: ccd_p1 <= 1;
				P1_LOW_SH: ccd_p1 <= 0;
				RS_HIGH_SH: ccd_rs <= 1;
				RS_LOW_SH: ccd_rs <= 0;
				CP_HIGH_SH: ccd_cp <= 1;
				CP_LOW_SH: ccd_cp <= 0;
				SH_HIGH: ccd_sh <= 1;
				SH_LOW: ccd_sh <= 0;
				RS_HIGH_SH2: ccd_rs <= 1;
				RS_LOW_SH2: ccd_rs <= 0;
				CP_HIGH_SH2: ccd_cp <= 1;
				CP_LOW_SH2: ccd_cp <= 0;
			endcase

			// Create the ADC signals
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

	// Clock the ADC data out of the module
	always_ff @ (negedge adc_cs or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			pix_data <= 0;
		end

		// Run
		else
		begin

			// Output the data
			pix_data <= adc_data;

			// Create the valid output signal
			if(cal_mode == 1)
			begin

				if(pixel_cntr == 1) pix_out_valid <= 1;
				if(pixel_cntr == 2088) pix_out_valid <= 0;
			end

			// Else normal mode
			else
			begin

				if(pixel_cntr == 32) pix_out_valid <= 1;
				if(pixel_cntr == 2080) pix_out_valid <= 0;
			end
		end
	end
endmodule // ccd_timings_new