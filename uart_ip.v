
`define IDLE  2'b00
`define START 2'b01
`define DATA  2'b10
`define STOP  2'b11



module uart_ip # (
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
		)
		(
	//input wire 			clock,
	//input wire 			resetn,
// from reg
//	input wire 			uart_en,
//	input wire [2:0]	baud_rx_sel,
//	input wire [2:0]	baud_tx_sel,
//	input wire 			start_tx,
//input wire 			mode,
//	input wire [7:0]	data_in,

//to reg 
//	output wire 		rec_valid,
//	output wire [7:0] 	rec_dat,
//	output wire 		tx_done,
// UART 
	output wire TX,
	input  wire RX,
// AXI LITE
	input wire                            S_AXI_ACLK,
	input wire                            S_AXI_ARESETN,
	// Write address (issued by master, acceped by Slave)
	input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
	input wire [2 : 0]                    S_AXI_AWPROT,
	input wire                            S_AXI_AWVALID,
	output wire                           S_AXI_AWREADY,
	// Write data (issued by master, acceped by Slave) 
	input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA, 
	input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
	input wire                            S_AXI_WVALID,
	output wire                           S_AXI_WREADY,
	output wire [1 : 0]                   S_AXI_BRESP,
	output wire                           S_AXI_BVALID,
	input wire                            S_AXI_BREADY,
	input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
	input wire [2 : 0]                    S_AXI_ARPROT,
	input wire                            S_AXI_ARVALID,
	output wire                           S_AXI_ARREADY,
	// Read data (issued by slave)
	output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
	output wire [1 : 0]                   S_AXI_RRESP,
	output wire                           S_AXI_RVALID,
	input wire                            S_AXI_RREADY
);
	// To Internal
	wire  [C_S_AXI_DATA_WIDTH-1:0]	  uart_ctrl;
	wire  [C_S_AXI_DATA_WIDTH-1:0]	  tx_baud;
	wire  [C_S_AXI_DATA_WIDTH-1:0]	  rx_baud;
	wire  [C_S_AXI_DATA_WIDTH-1:0]	  tx_data;


wire clock, resetn;
//wire tx_done;

assign clock = S_AXI_ACLK;
assign resetn = S_AXI_ARESETN;


// UART_TX
uart_tx uart_tx (
	.clock			(clock),
	.resetn			(resetn),
	.uart_en		(uart_ctrl[0]),
	.baud_tx_sel	(tx_baud[2:0]),
	.start_tx		(uart_ctrl[1]),
	.data_in(tx_data[7:0]),
	.TX(TX),
	.tx_done()
);

//UART RX 
uart_rx uart_rx (
	.clock			(clock),
	.resetn			(resetn),
	.uart_en		(uart_ctrl[0]),
	.baud_rx_sel	(rx_baud[2:0]),
	.RX				(RX),
	.rec_valid		(),
	.rec_dat		()
);

axi_if axi_if (
		S_AXI_ACLK,
		S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR,
		S_AXI_AWPROT,
		S_AXI_AWVALID,
		S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA, 
		S_AXI_WSTRB,
		S_AXI_WVALID,
		S_AXI_WREADY,
		S_AXI_BRESP,
		S_AXI_BVALID,
		S_AXI_BREADY,
		S_AXI_ARADDR,
		S_AXI_ARPROT,
		S_AXI_ARVALID,
		S_AXI_ARREADY,
		// Read data (issued by slave)
		S_AXI_RDATA,
		S_AXI_RRESP,
		S_AXI_RVALID,
		S_AXI_RREADY,
		// To Internal
		uart_ctrl,
		tx_baud,
		rx_baud,
		tx_data
);


endmodule