`define IDLE  2'b00
`define START 2'b01
`define DATA  2'b10
`define STOP  2'b11

module uart_rx (
	input wire 			clock,
	input wire 			resetn,
	// from reg
	input wire 			uart_en,
	input wire [2:0]	baud_rx_sel,
	// UART 
	input wire 			RX,
	output wire			rec_valid,
	output reg 	[7:0]	rec_dat
);

wire 		baud_time;
reg [13:0] 	baud_cnt, baud_cnt_num;
reg 		state_end;
reg [2:0]	data_cnt;

reg [1:0] 	state_rx, next_rx;

// baud rate generator
// system clock: 100Mhz
// 
// 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
// sys clock  period:  10ns 
// 9600: 1 bit priod = 104166 ns --> 10416 count --> Half: 5208 count 

wire 	start_rx;
reg 	RX_, RX__;

// sync, RX START detection
always @ (posedge clock) begin
	if ( resetn == 1'b0) begin 
		RX_ 	<= 1'b1;
		RX__	<= 1'b1;
	end
	else begin
		RX_		<= RX;
		RX__	<= RX_;
	end
end

assign start_rx = !RX_ && RX__;

// baud_cnt_num
always @ (*) begin 
	case (baud_rx_sel)
		3'b000:    baud_cnt_num =   13'd10416;
		3'b001:    baud_cnt_num =   13'd5208;
		3'b010:    baud_cnt_num =   13'd2604;
		3'b011:    baud_cnt_num =   13'd1736;
		3'b100:    baud_cnt_num =   13'd868;
		3'b101:    baud_cnt_num =   13'd434;
		3'b110:    baud_cnt_num =   13'd217;
		3'b111:    baud_cnt_num =   13'd108;
		default:   baud_cnt_num = 	13'd10416;
	endcase
end

// clock counter for baud rate
always @ ( posedge clock ) begin 
	if (resetn == 1'b0) begin
		baud_cnt <=  13'd0;
	end
	else begin 
		if ( uart_en == 1'b1 && state_rx != `IDLE ) begin 
			if ( baud_cnt < baud_cnt_num ) 
				baud_cnt <= baud_cnt + 13'd1;
			else 
				baud_cnt <= 13'd0;
		end
		else begin 
			baud_cnt <= 13'd0;
		end
	end
end

// point of each baud rate period
assign baud_time 	= (baud_cnt == baud_cnt_num ) 		? 1'b1 : 1'b0;
assign latch_time 	= (baud_cnt == (baud_cnt_num - 20)) ? 1'b1 : 1'b0;
assign rec_valid 	= (baud_cnt == (baud_cnt_num - 20) && (state_rx == `STOP)) ? 1'b1 : 1'b0;

// state_end
always @ (*) begin 
	case (state_rx)
		`START,
		`STOP: 		if (baud_time == 1'b1)  	state_end = 1'b1;
					else 						state_end = 1'b0;
		`DATA: 		if (baud_time == 1'b1 & data_cnt == 3'd7 )  	
												state_end = 1'b1;
					else 						state_end = 1'b0;
		default: 								state_end = 1'b0;	
	endcase
end

// data_cnt
always @ (posedge clock) begin
	if (resetn == 1'b0 ) begin
		data_cnt <= 3'd0;
	end
	else begin
		if (state_rx == `DATA && baud_time == 1'b1 ) begin
			if ( data_cnt < 3'd7 ) 	data_cnt <= data_cnt + 3'd1;
			else 					data_cnt <= 3'd0;
		end
	end
end

// state_rx machine
always @(*) begin
	case( state_rx )
		`IDLE:		if (start_rx == 1'b1 && uart_en == 1'b1 ) 	next_rx = `START;
					else 				next_rx = `IDLE;
		`START:		if (state_end )		next_rx = `DATA;
					else 				next_rx = `START;
		`DATA:		if (state_end )		next_rx = `STOP;
					else 				next_rx = `DATA;
		`STOP:		if (state_end)		next_rx = `IDLE;
					else 				next_rx = `STOP;
		default: next_rx = `IDLE;
	endcase
end

// state_rx
always @ (posedge clock ) begin
	if (resetn == 1'b0 ) begin
		state_rx <= `IDLE;
	end
	else begin
		state_rx <= next_rx;
	end
end


// RX data
always @ (posedge clock) begin 
	if (resetn == 1'b0) begin
		rec_dat <= 8'h00;
	end
	else begin
		if ( start_rx == `DATA ) begin
			if (latch_time) rec_dat[data_cnt] 	<=	RX__;
		end
	end
end 


endmodule