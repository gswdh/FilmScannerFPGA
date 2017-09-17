module usb_ft232h (

	// Reset
	input logic 		nrst, 

	//FT232H
	input  logic       	usb_clk_i,
	inout  logic [7:0] 	usb_data_io,
	input  logic       	usb_rxf_n_i,
	input  logic       	usb_txe_n_i,
	output logic       	usb_rd_n_o,
	output logic       	usb_wr_n_o,
	output logic       	usb_oe_n_o,

	// Read port
	input logic 		rxf_rdclk_i,		// Read clock
						rxf_rdreq_i,		// Read request
	output logic [7:0]	rxf_rddata_o,		// Data read
	output logic [8:0]	rxf_rdusedw_o,		// Number of bytes in the FIFO

	// Write port
	input logic 		txe_wrclk_i,		// Write clock
						txe_wrreq_i,		// Write request
	input logic [7:0]	txe_wrdata_i,		// Data to write
	output logic [8:0]	txe_wrusedw_o,		// FIFO status
	output logic 		txe_wrfull_o
);


// TODO Make the rxf_rdusedw_o signal parameterised
parameter TX_FIFO_DEPTH  = 512;
parameter TX_FIFO_WIDTHU = 9;
parameter RX_FIFO_DEPTH  = 512;
parameter RX_FIFO_WIDTHU = 9;

reg                        error = 0;
reg                        rxerror = 0;
reg   [7:0]                rxerrdata, rxf_data;

logic                      txf_wrfull;
logic                      txf_rdclk;
logic                      txf_rdreq;
logic [7:0]                txf_rddata;
logic                      txf_rdempty;

logic [7:0]                rxf_wrdata;
logic                      rxf_wrclk;
logic                      rxf_wrreq;
logic                      rxf_wrfull;
logic                      rxf_rdempty;
logic                      rxf_rdfull;

// Set the FT232H port to input or the write data
assign usb_data_io = ( usb_oe_n_o ) ? ( txf_rddata ) : ( {8{1'bZ}} );

// Create the clocks
assign rxf_wrclk   = ~usb_clk_i;
assign txf_rdclk   = ~usb_clk_i;

// Full signal
assign txe_wrfull_o = txf_wrfull;

	// FIFO for sending data instatiation
	dcfifo	txfifo (
		.aclr      ( ~nrst ),
		.data      ( txe_wrdata_i ),
		.rdclk     ( txf_rdclk ),
		.rdreq     ( txf_rdreq ),
		.wrclk     ( txe_wrclk_i ),
		.wrreq     ( txe_wrreq_i ),
		.q         ( txf_rddata ),
		.rdempty   ( txf_rdempty ),
		.wrfull    ( txf_wrfull ),
		.wrusedw   ( txe_wrusedw_o ),
		//.eccstatus (),
		.rdfull    (),
		.rdusedw   (),
		.wrempty   ()
	);
	
	defparam
		txfifo.intended_device_family = "Cyclone IV E",
		txfifo.lpm_numwords = TX_FIFO_DEPTH,
		txfifo.lpm_showahead = "OFF",
		txfifo.lpm_type = "dcfifo",
		txfifo.lpm_width = 8,
		txfifo.lpm_widthu = TX_FIFO_WIDTHU,
		txfifo.overflow_checking = "ON",
		txfifo.rdsync_delaypipe = 11,
		txfifo.read_aclr_synch = "ON",
		txfifo.underflow_checking = "ON",
		txfifo.use_eab = "ON",
		txfifo.write_aclr_synch = "ON",
		txfifo.wrsync_delaypipe = 11;

	// FIFO for recieving data instatiation
	dcfifo	rxfifo (
		.aclr      ( ~nrst ),
		.data      ( rxf_wrdata ),
		.rdclk     ( rxf_rdclk_i ),	//
		.rdreq     ( rxf_rdreq_i ),	//	
		.wrclk     ( rxf_wrclk ),
		.wrreq     ( rxf_wrreq ),	
		.q         ( rxf_rddata_o ),	//
		.rdempty   ( rxf_rdempty ),	//
		.wrfull    ( rxf_wrfull ),
		.wrusedw   (),
		//.eccstatus (),
		.rdfull    ( rxf_rdfull ),
		.rdusedw   ( rxf_rdusedw_o ),	//
		.wrempty   ()
	);
	
	defparam
		rxfifo.intended_device_family = "Cyclone IV E",
		rxfifo.lpm_numwords = RX_FIFO_DEPTH,
		rxfifo.lpm_showahead = "OFF",
		rxfifo.lpm_type = "dcfifo",
		rxfifo.lpm_width = 8,
		rxfifo.lpm_widthu = RX_FIFO_WIDTHU,
		rxfifo.overflow_checking = "ON",
		rxfifo.rdsync_delaypipe = 11,
		rxfifo.read_aclr_synch = "ON",
		rxfifo.underflow_checking = "ON",
		rxfifo.use_eab = "ON",
		rxfifo.write_aclr_synch = "ON",
		rxfifo.wrsync_delaypipe = 11;




	// Create another stage for the RX data flow
	always_ff @ (negedge usb_clk_i or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			rxf_data <= 0;
		end

		// Run
		else
		begin

			// Assign the data through the pipe
			rxf_data <= usb_data_io;
		end
	end

	// Read USB data to RX FIFO
	always_ff @ (negedge rxf_wrclk or negedge nrst)
	begin

		// Reset
	  	if(nrst == 0)
	    begin

	    	// Reset strobes
			rxf_wrreq <= 0;
			rxf_wrdata <= 0;
			rxerror <= 0;
			rxerrdata <= 0;
		end

		// Run
	  	else
	    begin

	    	// If we are attempting to read data from the FT232H but the RX FIFO is full
		   	if((usb_rd_n_o == 0) && (rxf_wrfull == 1))
	 	 	begin

	 	 		// If the RD signal is set low to read data from the USB but the RX FIFO is full
			    rxerror <= 1;

			    // Save the incoming byte into an intermediate variable
				rxerrdata <= rxf_data;
			end
		 
		 	// If the (RX FIFO is not full and ((we are reading and there is data to read) or there's an error))
		   	if((rxf_wrfull == 0) && (((usb_rd_n_o == 0) && (usb_rxf_n_i == 0)) || (rxerror == 1)))
			begin

				// Start writing into the RX FIFO
			    rxf_wrreq <= 1;
			 	
			 	// If there's an error set the input data into the FIFO to be something?
			 	if(rxerror == 1)
			   	begin

			   		// Reset the error signal
			     	rxerror <= 0;

			     	// Input the saved byte from when there was an error
				  	rxf_wrdata <= rxerrdata;
				end
				
				// If everything is fine, write some USB data into the FIFO
				else rxf_wrdata <= rxf_data;
			end

			else
			begin

				// Else stop writing data into the FIFO
				rxf_wrreq <= 0;
			end
		end
	end

	// Set the FT232H port direction
	always_ff @ (negedge usb_clk_i or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			// Reset strobes
			usb_oe_n_o <= 1;
			usb_rd_n_o <= 1;
		end

		// Run
		else
		begin
			
			// If there's data to be read, the RX FIFO is not full and there is no TX happening and there are no errors
			if((usb_rxf_n_i == 0) && (rxf_wrfull == 0) && ((usb_txe_n_i == 1) || ((txf_rdreq == 0) && (error == 0))) && (rxerror == 0))
			begin

				// Set the the port direction to output (so we can read data from it)
				usb_oe_n_o <= 0;
				
				// If the direction has been set assert the read request
				if(usb_oe_n_o == 0) usb_rd_n_o <= 0;
			end
			
			else
			begin
			
				// Else set for writing to the FT232H
				usb_oe_n_o <= 1;
				usb_rd_n_o <= 1;
			end
		end
	end

	// Write data from the TX FIFO to the USB
	always_ff @ (negedge txf_rdclk or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			// 
			txf_rdreq <= 0;
		end

		// Run
		else
		begin

			// 
			if((usb_txe_n_i == 0) && (txf_rdempty == 0) && (error == 0) && (usb_oe_n_o == 1))
			begin
			
				txf_rdreq <= 1;
			end

			// 
			else txf_rdreq <= 0;
		end
	end
		
	// 
	always_ff @ (negedge usb_clk_i or negedge nrst)
	begin

		// Reset
		if(nrst == 0)
		begin

			usb_wr_n_o <= 1;
			error <= 0;
		end

		// Run
		else
		begin

			// 
			if((usb_txe_n_i == 1) && (usb_wr_n_o == 0))
			begin
				
				error <= 1;
			end

			//
			if((usb_txe_n_i == 0) && ((txf_rdreq == 1) /*|| (error == 1)*/) && (usb_oe_n_o == 1))
			begin
				
				// 
				usb_wr_n_o <= 0;
		
				// 
				if(error == 1) error <= 0;
			end
			
			// 
			else usb_wr_n_o <= 1;
		end
	end
endmodule
