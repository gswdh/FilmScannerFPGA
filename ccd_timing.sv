module ccd_timing(

	// Input clock
	input logic 		clk_100M,



	// CCD control
	output reg 			ccd_p1 = 0, 
						ccd_p2, 
						ccd_sh = 0,
						ccd_rs = 0, 
						ccd_cp = 0
	);


	// p1 is always opposite to p2
	assign ccd_p2 = ~ccd_p1;

	// Compensation was needed for propagtion through the level shifters
	parameter SH_HIGH = 0;
	parameter SH_LOW = 5;
	parameter P1_HIGH = 24;
	parameter P1_LOW = 0;
	parameter RS_HIGH = 16;
	parameter RS_LOW = 21;
	parameter CP_HIGH = 26;
	parameter CP_LOW = 31;

	parameter stop = 0;

	// Create a counter to manage the timings from
	reg [7:0] timings_cntr = 0;

	// Use the 100MHz clock to create the timings
	always_ff @ (posedge clk_100M)
	begin

		// If they should run (not SH time)
		if(stop == 1)
		begin

			// reset the counter
			timings_cntr <=0;

			// Set the clocks
			ccd_p1 <= 1;
			ccd_rs <= 0; 
			ccd_cp <= 0;
		end

		// Run
		else
		begin

			// Run the counter
			if(timings_cntr == 49) timings_cntr <= 0;

			// Increment
			else timings_cntr <= timings_cntr + 1;

			// Create the timings
			case(timings_cntr)

				P1_HIGH: ccd_p1 <= 1;
				P1_LOW: ccd_p1 <= 0;
				RS_HIGH: ccd_rs <= 1;
				RS_LOW: ccd_rs <= 0;
				CP_HIGH: ccd_cp <= 1;
				CP_LOW: ccd_cp <= 0;
			endcase // timings_cntr
		end
	end


	// 

	// Count the rising edges of p2


	// Now we need to create the SH signal


/*
	SH_HIGH: begin

				end

				SH_LOW: begin

				end
				*/

















endmodule // ccd_timing