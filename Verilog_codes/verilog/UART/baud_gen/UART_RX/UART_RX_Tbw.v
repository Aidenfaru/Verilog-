`timescale 1ns/1ps

module uart_rx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire baud_tick;
wire tx;

wire [7:0] data_out;
wire rx_done;

// Baud Generator
baud_gen #(
    .CLK_FREQ(100),
    .BAUD_RATE(10)
)
baud_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

// UART TX
uart_tx tx_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_busy()
);

// UART RX
uart_rx rx_inst
(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(tx),
    .data_out(data_out),
    .rx_done(rx_done)
);

// Clock
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test
initial
begin

    rst = 1;
    tx_start = 0;
    data_in = 8'h00;

    #20;

    rst = 0;

    #20;

    data_in = 8'h41;
    tx_start = 1;

    #10;
    tx_start = 0;

    #1500;

    $finish;

end

// Monitor
initial
begin
    $monitor("Time=%0t TX=%b RX_DONE=%b DATA=%h",
              $time, tx, rx_done, data_out);
end

endmodule