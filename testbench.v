module testbench();
	 reg 			clock;
	 reg 			resetn;
	// from reg
	 reg 			uart_en;
	 reg [2:0]		baud_tx_sel;
	 reg [2:0]		baud_rx_sel;
	 reg 			start_tx;
	 reg [7:0]		data_in;
	//to wire 
	 wire 			rec_valid;
	 wire [7:0] 	rec_data;
	// UART 
	 wire 			TX;
	 reg 			RX;
	 
	uart_ip dut (
		clock,
		resetn,
		uart_en,
		baud_rx_sel,
		baud_tx_sel,
		start_tx,
		data_in,
		rec_valid,
		rec_data,
		tx_done,
		TX,
		RX
	); 
	
	initial begin
		clock 		= 1'b0;
		resetn 		= 1'b0;
		uart_en 	= 1'b1;
		baud_tx_sel 	= 3'b111;
		baud_rx_sel 	= 3'b111;
		start_tx	= 1'b0;
		data_in		= 7'h5a;	
		RX 			= 1'b1;
	end
	
	// clock gen
	always begin
		#5; clock  = ~clock;
	end
	
	// 
	initial begin 
	#10000; resetn 	= 1'b1;
	#100; start_tx 	= 1'b1;
	#30;  start_tx	= 1'b0;
		
	end
	 
endmodule