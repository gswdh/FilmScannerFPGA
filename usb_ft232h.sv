/*
 *	Если error срабатывает на последнем байте пакета, то он не будет отправлен, пока
 * не придет следующий пакет
 */


module usb_ft232h (
	//Avalon-MM Slave
	clk_i,
	reset_i,
	address_i,
	read_i,
	readdata_o,
	write_i,
	writedata_i,

	// Amount of data recieved 
	rx_n_bytes_o,

	//FT232H
	usb_clk_i,
	usb_data_io,
	usb_rxf_n_i,
	usb_txe_n_i,
	usb_rd_n_o,
	usb_wr_n_o,
	usb_oe_n_o,

	// Read hack
	rxf_rdclk,		// Read clock
	rxf_rdreq,		// Read request

	rxf_rddata,		// Data read
	rxf_rdusedw		// Number of bytes in the FIFO
);



parameter TX_FIFO_DEPTH  = 512;
parameter TX_FIFO_WIDTHU = 9;
parameter RX_FIFO_DEPTH  = 512;
parameter RX_FIFO_WIDTHU = 9;

localparam WRDATA_ADDR	  = 4'd0;
localparam RDDATA_ADDR	  = 4'd1;
localparam TXSTATUSL_ADDR = 4'd2;
localparam TXSTATUSH_ADDR = 4'd3;
localparam RXSTATUSL_ADDR = 4'd4;
localparam RXSTATUSH_ADDR = 4'd5;


input  logic       clk_i;
input  logic       reset_i;
input  logic [3:0] address_i;
input  logic       read_i;
output logic [7:0] readdata_o;
input  logic       write_i;
input  logic [7:0] writedata_i;

output logic [RX_FIFO_WIDTHU-1:0] rx_n_bytes_o;

input  logic       usb_clk_i;
inout  logic [7:0] usb_data_io;
input  logic       usb_rxf_n_i;
input  logic       usb_txe_n_i;
output logic       usb_rd_n_o;
output logic       usb_wr_n_o;
output logic       usb_oe_n_o;

// Read hack
input logic 		rxf_rdclk;		// Read clock
input logic			rxf_rdreq;		// Read request

output reg [7:0] 	rxf_rddata;		// Data read
output reg [8:0]	rxf_rdusedw;	// Number of bytes in the FIFO



reg                        error;
reg                        rxerror;
reg   [7:0]                rxerrdata;
logic [15:0]               txstatus;
logic [15:0]               rxstatus;

reg                        read_pipe;
reg                        read_pipe2;

reg                        adr_data;
reg                        adr_txsl;
reg                        adr_txsh;
reg                        adr_rxsl;
reg                        adr_rxsh;


logic [7:0]                txf_wrdata;
logic                      txf_wrclk;
logic                      txf_wrreq;
logic                      txf_wrfull;
logic [TX_FIFO_WIDTHU-1:0] txf_wrusedw;
logic                      txf_rdclk;
logic                      txf_rdreq;
logic [7:0]                txf_rddata;
logic                      txf_rdempty;

logic [7:0]                rxf_wrdata;
logic                      rxf_wrclk;
logic                      rxf_wrreq;
logic                      rxf_wrfull;
//logic [RX_FIFO_WIDTHU-1:0] rxf_rdusedw;
//logic                      rxf_rdclk;
//logic                      rxf_rdreq;
//logic [7:0]                rxf_rddata;
logic                      rxf_rdempty;
logic                      rxf_rdfull;


assign usb_data_io = ( usb_oe_n_o ) ? ( txf_rddata ) : ( {8{1'bZ}} );

assign rxf_wrclk   = ~usb_clk_i;
assign txf_rdclk   = usb_clk_i;
//assign rxf_rdclk   = clk_i;
assign txf_wrclk   = ~clk_i;

assign txstatus[15]                  = ~txf_wrfull; //can write
assign txstatus[14:TX_FIFO_WIDTHU+1] = 0;
assign txstatus[TX_FIFO_WIDTHU]      = txf_wrfull;
assign txstatus[TX_FIFO_WIDTHU-1:0]  = ( txf_wrfull ? {TX_FIFO_WIDTHU{1'b0}} : txf_wrusedw );

assign rxstatus[15]                  = ~rxf_rdempty; //can read
assign rxstatus[14:RX_FIFO_WIDTHU+1] = 0;
assign rxstatus[RX_FIFO_WIDTHU]      = rxf_rdfull;
assign rxstatus[RX_FIFO_WIDTHU-1:0]  = ( rxf_rdempty ? {RX_FIFO_WIDTHU{1'b0}} : rxf_rdusedw );


dcfifo	txfifo (
				.aclr      ( reset_i ),
				.data      ( txf_wrdata ),
				.rdclk     ( txf_rdclk ),
				.rdreq     ( txf_rdreq ),
				.wrclk     ( txf_wrclk ),
				.wrreq     ( txf_wrreq ),
				.q         ( txf_rddata ),
				.rdempty   ( txf_rdempty ),
				.wrfull    ( txf_wrfull ),
				.wrusedw   ( txf_wrusedw ),
				.eccstatus (),
				.rdfull    (),
				.rdusedw   (),
				.wrempty   ());
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

		
dcfifo	rxfifo (
				.aclr      ( reset_i ),
				.data      ( rxf_wrdata ),
				.rdclk     ( rxf_rdclk ),	//
				.rdreq     ( rxf_rdreq ),	//	
				.wrclk     ( rxf_wrclk ),
				.wrreq     ( rxf_wrreq ),	
				.q         ( rxf_rddata ),	//
				.rdempty   ( rxf_rdempty ),	//
				.wrfull    ( rxf_wrfull ),
				.wrusedw   (),
				.eccstatus (),
				.rdfull    ( rxf_rdfull ),
				.rdusedw   ( rxf_rdusedw ),	//
				.wrempty   ());
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
		

assign rx_n_bytes_o = rxf_rdusedw;

/* read usb data to rx fifo */
always_ff @( negedge rxf_wrclk or posedge reset_i )
begin
  if( reset_i )
    begin
	   rxf_wrreq <= 1'b0;
		rxf_wrdata <= 8'b0;
		rxerror <= 1'b0;
		rxerrdata <= 8'b0;
	 end
  else
    begin
	   if( ~usb_rd_n_o & rxf_wrfull )
		  begin
		    rxerror <= 1'b1;
			 rxerrdata <= usb_data_io;
		  end
	 
	   if( ~rxf_wrfull & ((~usb_rd_n_o & ~usb_rxf_n_i) | rxerror) )
		  begin
		    rxf_wrreq <= 1'b1;
			 if( rxerror )
			   begin
			     rxerror <= 1'b0;
				  rxf_wrdata <= rxerrdata;
				end
			 else
			   rxf_wrdata <= usb_data_io;
		  end
		else
		  begin
		    rxf_wrreq <= 1'b0;
		  end
	 end
end
always_ff @( posedge usb_clk_i or posedge reset_i )
begin
  if( reset_i )
    begin
	   usb_oe_n_o <= 1'b1;
		usb_rd_n_o <= 1'b1;
	 end
  else
    begin
	   if( ~usb_rxf_n_i & ~rxf_wrfull & ( usb_txe_n_i | ( ~txf_rdreq & ~error )) & ~rxerror )
		  begin
		    usb_oe_n_o <= 1'b0;
			 if( ~usb_oe_n_o )
		      usb_rd_n_o <= 1'b0;
		  end
		else
		  begin
		    usb_oe_n_o <= 1'b1;
			 usb_rd_n_o <= 1'b1;
		  end
	 end
end

/*---------------------------------*/

/* write tx fifo data to usb */
always_ff @( negedge txf_rdclk or posedge reset_i )
begin
  if( reset_i )
    begin
	   txf_rdreq <= 1'b0;
	 end
  else
    begin
	   if( ~usb_txe_n_i & ~txf_rdempty & ~error & usb_oe_n_o )
		  begin
		    txf_rdreq <= 1'b1;
		  end
		else
		  txf_rdreq <= 1'b0;
	 end
end
always_ff @( posedge usb_clk_i or posedge reset_i )
begin
  if( reset_i )
    begin
		usb_wr_n_o <= 1'b1;
		error      <= 1'b0;
	 end
  else
    begin
	   if( usb_txe_n_i & ~usb_wr_n_o )
		  begin
		    error <= 1'b1;
		  end
	 
	   if( ~usb_txe_n_i & ( txf_rdreq | error ) & usb_oe_n_o )
		  begin
		    usb_wr_n_o <= 1'b0;
			 if( error )
			   error <= 1'b0;
		  end
		else
		  begin
		    usb_wr_n_o <= 1'b1;
		  end
    end
end
/*-----------------------------*/


/* avalon data to tx fifo*/
always_ff @( negedge txf_wrclk or posedge reset_i )
begin
  if( reset_i )
    begin
	   txf_wrreq  <= 1'b0;
		txf_wrdata <= 8'b0;
	 end
  else
    begin
	   if( write_i & ( address_i == WRDATA_ADDR ) & ~txf_wrfull )
		  begin
		    txf_wrreq  <= 1'b1;
			 txf_wrdata <= writedata_i;
		  end
		else
		  begin
		    txf_wrreq  <= 1'b0;
		  end
	 end
end
/*------------------------------------*/

/* rx fifo data to avalon */
always_ff @( posedge clk_i or posedge reset_i )
begin
  if( reset_i )
    begin
	   adr_data <= 1'b0;
		adr_txsl <= 1'b0;
		adr_txsh <= 1'b0;
		adr_rxsl <= 1'b0;
		adr_rxsh <= 1'b0;
	 end
  else
    begin
	   if( read_i )
		  begin
		    if( address_i == RDDATA_ADDR )
			   adr_data <= 1'b1;
			 else
			   adr_data <= 1'b0;
				
			 if( address_i == TXSTATUSL_ADDR )
			   adr_txsl <= 1'b1;
			 else
			   adr_txsl <= 1'b0;
			
			 if( address_i == TXSTATUSH_ADDR )
			   adr_txsh <= 1'b1;
			 else
			   adr_txsh <= 1'b0;
			
			 if( address_i == RXSTATUSL_ADDR )
			   adr_rxsl <= 1'b1;
			 else
			   adr_rxsl <= 1'b0;
				
			 if( address_i == RXSTATUSH_ADDR )
			   adr_rxsh <= 1'b1;
			 else
			   adr_rxsh <= 1'b0;
		  end
	 end
end

always_ff @( posedge clk_i or posedge reset_i )
begin
  if( reset_i )
    begin
	   read_pipe <= 1'b0;
    end
  else
    begin
	   if( read_i )
		  read_pipe <= 1'b1;
		else
		  read_pipe <= 1'b0;
	 end
end

/*
always_ff @( negedge rxf_rdclk or posedge reset_i )
begin
  if( reset_i )
    begin
	   rxf_rdreq <= 1'b0;
	 end
  else
    begin
	   if( read_pipe & adr_data & ~rxf_rdempty )
		  rxf_rdreq <= 1'b1;
		else
		  rxf_rdreq <= 1'b0;
	 end
end
*/

always_ff @( posedge clk_i or posedge reset_i )
begin
  if( reset_i )
    begin
	   read_pipe2 <= 1'b0;
    end
  else
    begin
	   if( read_pipe )
		  read_pipe2 <= 1'b1;
		else
		  read_pipe2 <= 1'b0;
	 end
end

always_ff @( posedge clk_i or posedge reset_i )
begin
  if( reset_i )
    begin
	   readdata_o <= 8'b0;
	 end
  else
    begin
	   if( read_pipe2 )
		  begin
		    if( adr_data )
			   readdata_o <= rxf_rddata;
			 else if( adr_txsl )
			   readdata_o <= txstatus[7:0];
			 else if( adr_txsh )
			   readdata_o <= txstatus[15:8];
			 else if( adr_rxsl )
			   readdata_o <= rxstatus[7:0];
			 else if( adr_rxsh )
			   readdata_o <= rxstatus[15:8];
			 else
			   readdata_o <= 8'b0;
		  end
	 end
end
/*------------------------------------*/


endmodule
