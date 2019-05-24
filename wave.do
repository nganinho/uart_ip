onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/uart_en
add wave -noupdate /testbench/tx_done
add wave -noupdate /testbench/start_tx
add wave -noupdate /testbench/resetn
add wave -noupdate /testbench/rec_valid
add wave -noupdate /testbench/rec_data
add wave -noupdate /testbench/data_in
add wave -noupdate /testbench/clock
add wave -noupdate /testbench/baud_tx_sel
add wave -noupdate /testbench/baud_rx_sel
add wave -noupdate /testbench/TX
add wave -noupdate /testbench/RX
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/uart_en
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/tx_done
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/state_tx
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/state_end
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/start_tx
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/resetn
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/next_tx
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/data_in
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/data_cnt
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/clock
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/baud_tx_sel
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/baud_time
add wave -noupdate -expand -group TX -radix unsigned /testbench/dut/uart_tx/baud_cnt_num
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/baud_cnt
add wave -noupdate -expand -group TX /testbench/dut/uart_tx/TX
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/uart_en
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/state_rx
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/state_end
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/start_rx
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/resetn
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/rec_valid
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/rec_dat
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/next_rx
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/latch_time
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/data_cnt
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/clock
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/baud_time
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/baud_rx_sel
add wave -noupdate -expand -group RX -radix unsigned /testbench/dut/uart_rx/baud_cnt_num
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/baud_cnt
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/RX__
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/RX_
add wave -noupdate -expand -group RX /testbench/dut/uart_rx/RX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18547 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 359
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {31500 ps}
