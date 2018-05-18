module control(

	// Reset
	input logic 		nrst,

	// GS bus input
	input logic 		bus_clk, bus_valid,
	input logic [31:0]	bus_data,
	input logic [63:0]	bus_addr,
	input logic [15:0]	bus_gpreg,

	// Output control
	output reg 			mtr_en, mtr_dir,
	output reg 	[15:0]	mtr_speed,

	output reg 	[7:0]	led_pwm_val,

	output reg 			scan_en,
	output reg 	[3:0]	scan_sub_smpl, scan_fr,

	output reg 	[15:0]	dac_gain, dac_offset
);

/*
	MEMORY MAP

	addr : data
	0x0000 0000 0000 0000 : mtr_en[0]
	0x0000 0000 0000 0001 : mtr_dir[0]
	0x0000 0000 0000 0002 : mtr_speed[15:0]

	0x0000 0000 0000 0003 : led_pwm_val[7:0]

	0x0000 0000 0000 0004 : scan_en[0]
	0x0000 0000 0000 0005 : scan_sub_smpl[3:0]
	0x0000 0000 0000 0006 : scan_fr[3:0]

	0x0000 0000 0000 0007 : dac_gain[15:0]
	0x0000 0000 0000 0008 : dac_offset[15:0]
*/

	// Internal regs
	reg 		bus_valid_r = 0;
	reg [31:0]	bus_data_r;
	reg [63:0]	bus_addr_r;
	reg [15:0]	bus_gpreg_r;
	
	// Process the clock
	always_ff @ (posedge bus_clk or negedge nrst)
	begin

		// Reset
		if(nrst == 1'b0)
		begin

			bus_valid_r <= 0;
			bus_data_r <= 0;
			bus_addr_r <= 0;
			bus_gpreg_r <= 0;
		end

		// Run
		else
		begin

			// Keep the regs updated
			bus_valid_r <= bus_valid;
			bus_data_r <= bus_data;
			bus_addr_r <= bus_addr;
			bus_gpreg_r <= bus_gpreg;

			// Update the outputs
			if(bus_valid_r == 1'b1)
			begin

				case(bus_addr_r)

					// Motor enable signal
					0: mtr_en <= bus_data_r[0];

					// Motor direction
					1: mtr_dir <= bus_data_r[0];

					// Motor speed
					2: mtr_speed <= bus_data_r[15:0];
					
					// LED PWM value
					3: led_pwm_val <= bus_data_r[7:0];
					
					// Scan enable
					4: scan_en <= bus_data_r[0];

					// Scan sub-sampling quantity
					5: scan_sub_smpl <= bus_data_r[3:0];

					// Scan frame rate divider
					6: scan_fr <= bus_data_r[3:0];

					// Analogue sensor gain
					7: dac_gain <= bus_data_r[15:0];

					// Analogue sensor dark offset
					8: dac_offset <= bus_data_r[15:0];

				endcase // bus_addr_r
			end
		end
	end
endmodule // control