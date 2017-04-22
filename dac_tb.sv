module dac_tb();


	// tb variables
	reg [15:0]	offset, gain;
	reg clk_100M = 0, sclk, sdata, sync;

	// 100MHz clock
	always #5 clk_100M = ~clk_100M;


	initial
	begin
		offset = 200; gain = 56142; #125ns
		offset = 5482; gain = 2;
	end

	dac dac0(

		// Input control
		.clk_100M(clk_100M),

		// Input data
		.offset(offset), .gain(gain),

		// DAC output signals
		.sclk(sclk),
		.sdata(sdata),
		.sync(sync)
	);
	
endmodule // dac