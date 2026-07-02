`timescale 1ns/1ps

module uart_top_tb;

reg clk;
reg rst;

reg tx_start;
reg [7:0] tx_data;

wire tx_busy;
wire tx;

wire [7:0] rx_data;
wire rx_done;

//////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////

uart_top
#(
    .CLK_FREQ(100),
    .BAUD_RATE(10)
)
dut
(
    .clk(clk),
    .rst(rst),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .tx(tx),

    // Loopback
    .rx(tx),

    .tx_busy(tx_busy),

    .rx_data(rx_data),
    .rx_done(rx_done)
);

//////////////////////////////////////////////////////
// Clock Generation
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

    #30;
    rst = 0;

    //-------------------------
    // Send 0x41
    //-------------------------

    #20;

    tx_data = 8'h41;
    tx_start = 1;

    #10;
    tx_start = 0;

    wait(rx_done);

    #50;

    //-------------------------
    // Send 0x55
    //-------------------------

    tx_data = 8'h55;
    tx_start = 1;

    #10;
    tx_start = 0;

    wait(rx_done);

    #50;

    //-------------------------
    // Send 0xAA
    //-------------------------

    tx_data = 8'hAA;
    tx_start = 1;

    #10;
    tx_start = 0;

    wait(rx_done);

    #100;

    $finish;

end

//////////////////////////////////////////////////////
// Monitor
//////////////////////////////////////////////////////

always @(posedge clk)
begin
    if(rx_done)
    begin
        $display("------------------------------------");
        $display("Time     = %0t", $time);
        $display("Received = %h", rx_data);
        $display("------------------------------------");
    end
end

endmodule