`timescale 1ns/1ps

module uart_top_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

// UART Serial Wire
wire serial_wire;

wire tx_busy;
wire [7:0] rx_data;
wire rx_done;

//////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////

uart_top #(
    .CLK_FREQ(100),
    .BAUD_RATE(10)
)
uut
(
    .clk(clk),
    .rst(rst),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .tx(serial_wire),
    .rx(serial_wire),     // Loopback connection

    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

//////////////////////////////////////////////////////
// Clock
//////////////////////////////////////////////////////

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

//////////////////////////////////////////////////////
// Stimulus
//////////////////////////////////////////////////////

initial
begin

    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #20;
    rst = 0;

    //-----------------------------
    // Send A
    //-----------------------------
    #20;
    tx_data = 8'h41;
    tx_start = 1;
    #10;
    tx_start = 0;

    #1200;

    //-----------------------------
    // Send 55
    //-----------------------------
    tx_data = 8'h55;
    tx_start = 1;
    #10;
    tx_start = 0;

    #1200;

    //-----------------------------
    // Send AA
    //-----------------------------
    tx_data = 8'hAA;
    tx_start = 1;
    #10;
    tx_start = 0;

    #1200;

    $finish;

end

//////////////////////////////////////////////////////
// Monitor
//////////////////////////////////////////////////////

initial
begin

$monitor("Time=%0t TX=%b Busy=%b RX_DONE=%b RX_DATA=%h",
         $time,
         serial_wire,
         tx_busy,
         rx_done,
         rx_data);

end

endmodule