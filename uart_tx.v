`define IDLE  2'b00
`define START 2'b01
`define DATA  2'b10
`define STOP  2'b11

module uart_tx (
	input wire 			clock,
	input wire 			resetn,
	// from reg
	input wire 			uart_en,
	input wire [2:0]	baud_tx_sel,
	input wire 			start_tx,
	//input wire 			mode,
	input wire [7:0]	data_in,
	// UART 
	output reg 			TX,
	output wire			tx_done
);

wire 		baud_time;
reg [13:0] 	baud_cnt, baud_cnt_num;
reg 		state_end;
reg [2:0]	data_cnt;

reg [1:0] 	state_tx, next_tx;

// baud rate generator
// system clock: 100Mhz
// 
// 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600

// sys clock  period:  10ns 
// 9600: 1 bit priod = 104166 ns --> 10416 count --> Half: 5208 count 

// baud_cnt_num
always @ (*) begin 
	case (baud_tx_sel)
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
		if ( uart_en == 1'b1 && state_tx != `IDLE ) begin 
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
assign baud_time = (baud_cnt == baud_cnt_num ) ? 1'b1 : 1'b0;
assign tx_done = ((baud_cnt == baud_cnt_num) && (state_tx == `STOP)) ? 1'b1 : 1'b0;
// state_end
always @ (*) begin 
	case (state_tx)
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
		if (state_tx == `DATA && baud_time == 1'b1 ) begin
			if ( data_cnt < 3'd7 ) 	data_cnt <= data_cnt + 3'd1;
			else 					data_cnt <= 3'd0;
		end
	end
end

// state_tx machine
always @(*) begin
	case( state_tx )
		`IDLE:		if (start_tx == 1'b1 && uart_en == 1'b1 ) 	next_tx = `START;
					else 				next_tx = `IDLE;
		`START:		if (state_end )		next_tx = `DATA;
					else 				next_tx = `START;
		`DATA:		if (state_end )		next_tx = `STOP;
					else 				next_tx = `DATA;
		`STOP:		if (state_end)		next_tx = `IDLE;
					else 				next_tx = `STOP;
		default: next_tx = `IDLE;
	endcase
end

// state_tx
always @ (posedge clock ) begin
	if (resetn == 1'b0 ) begin
		state_tx <= `IDLE;
	end
	else begin
		state_tx <= next_tx;
	end
end


// TX data
always @ (posedge clock) begin 
	if (resetn == 1'b0) begin
		TX <= 1'b1;
	end
	else begin
		case (state_tx)
			`START: 	TX 	<= 	1'b0;
			`DATA:  	TX	<= 	data_in[data_cnt];
			`STOP: 		TX	<= 	1'b1;
			default: 	TX	<= 	1'b1;
		endcase
	end
end 

endmodule