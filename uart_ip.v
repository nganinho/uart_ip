
`define IDLE  2'b00
`define START 2'b01
`define DATA  2'b10
`define STOP  2'b11



module uart_ip  (
	input wire 			clock,
	input wire 			resetn,
// from reg
	input wire 			uart_en,
	input wire [2:0]	baud_rx_sel,
	input wire [2:0]	baud_tx_sel,
	input wire 			start_tx,
//input wire 			mode,
	input wire [7:0]	data_in,

//to reg 
	output wire 		rec_valid,
	output wire [7:0] 	rec_dat,
	output wire 		tx_done,
// UART 
	output wire TX,
	input  wire RX
);

// UART_TX
uart_tx uart_tx (
	clock,
	resetn,
	uart_en,
	baud_tx_sel,
	start_tx,
	data_in,
	TX,
	tx_done
);

//UART RX 
uart_rx uart_rx (
	clock,
	resetn,
	uart_en,
	baud_rx_sel,
	RX,
	rec_valid,
	rec_dat
);

endmodule