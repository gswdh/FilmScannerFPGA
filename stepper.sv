
module stepper(

	// Inputs
	input logic 		clk_100M, nrst,

	// Control logic
	input logic 		en, dir,

	input logic [7:0]	speed,

	// Motor outputs
	output reg 			mtr_nen,
						mtr_step, 
						mtr_nrst, 
						mtr_slp, 
						mtr_decay, 
						mtr_dir, 

	output reg  [2:0] 	mtr_m,

	input logic 		mtr_nhome, mtr_nflt

	);




	// Set the motor to micro stepping mode 1/32nd speed
	assign mtr_m = 7;

	// Motor enable
	assign mtr_nen = ~en;
	assign mtr_nrst = nrst;
	assign mtr_slp = en;

	// Fast decay mode
	assign mtr_decay = 1;

	// Motor directions
	assign mtr_dir = dir;


	// Divide the clock for the motor steps
	reg [18:0] mtr_cntr = 0;

	always_ff @ (posedge clk_100M or negedge nrst)
	begin 

		// Reset
		if(nrst == 0)
		begin

			mtr_step <= 0;
			mtr_cntr <= 0;
		end

		// Run
		else
		begin

			// Create a step
			if(mtr_cntr == 2000)
			begin

				mtr_step <= ~mtr_step;

				mtr_cntr <= 0;
			end

			// Increment the counter
			else mtr_cntr <= mtr_cntr + 1;
		end
	end

























endmodule // stepper