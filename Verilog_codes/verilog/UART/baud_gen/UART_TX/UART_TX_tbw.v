`timescale 1ns / 1ps

module uart_tx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire baud_tick;
wire tx;
wire tx_busy;

//------------------------------------------
// Baud Generator
//------------------------------------------

baud_gen #(
    .CLK_FREQ(100),
    .BAUD_RATE(10)
)
baud_generator
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

//------------------------------------------
// UART TX
//------------------------------------------

uart_tx transmitter
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_busy(tx_busy)
);

//------------------------------------------
// Clock
//------------------------------------------

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

//------------------------------------------
// Test
//------------------------------------------

initial
begin

    rst = 1;
    tx_start = 0;
    data_in = 8'h00;

    #20;

    rst = 0;

    #20;

    data_in = 8'h41;      // ASCII 'A'
    tx_start = 1;

    #10;
    tx_start = 0;

    #1200;

    $finish;

end

//------------------------------------------
// Monitor
//------------------------------------------

initial
begin
    $monitor("Time=%0t  TX=%b Busy=%b",
              $time, tx, tx_busy);
end

endmodule