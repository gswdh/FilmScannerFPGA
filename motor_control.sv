/*



*/
module motor_control(

	// Clock 
	input logic 		clk_100MHz,

	// Control
	input logic 		en,

	// Speed divisor
	input logic [7:0]	div,

	// Motor controller
	output reg 			mtr_nen,
						mtr_step = 0, 
						mtr_nrst, 
						mtr_slp, 
						mtr_decay = 0, 
						mtr_dir = DIRECTION, 

	output reg  [2:0] 	mtr_m = 7,

	input logic 		mtr_nhome, mtr_nflt,
);


	// Speed parameter NEEDS TO BE CALIBRATED
	parameter SPEED_DIV = 100000 * (div + 1) / 2;

	// Direction
	parameter DIRECTION = 0;

	// Clock divider
	reg [23:0]	step_cntr = 0;

	// Divide the 100MHz clock for the step output 
	always_ff @ (posedge clk_100MHz)
	begin

		// Create the step
		if(step_cntr == SPEED_DIV)
		begin

			// If we are meant to run
			if(en == 1) mtr_step <= ~mtr_step;
			else mtr_step <= 0;

			// Reset the counter
			step_cntr <= 0;
		end

		// Else incrment the counter
		else step_cntr <= step_cntr + 1;

	end

	// When we aren't enabled
	always_comb
	begin

		// Run
		if(en == 1)
		begin
			mtr_nen = 1;
			mtr_nrst = 0; 
			mtr_slp = 0;
		end

		// Stop
		else
		begin
			mtr_nen = 0;
			mtr_nrst = 1; 
			mtr_slp = 1;
		end
	end
endmodule // motor_control