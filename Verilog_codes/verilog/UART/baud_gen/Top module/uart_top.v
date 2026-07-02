module uart_top
#(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 9600
)
(
    input  wire clk,
    input  wire rst,

    input  wire tx_start,
    input  wire [7:0] tx_data,

    output wire tx,
    output wire tx_busy,

    output wire [7:0] rx_data,
    output wire rx_done
);

    //--------------------------------------------------
    // Internal Signals
    //--------------------------------------------------
    wire baud_tick;

    //--------------------------------------------------
    // Baud Generator
    //--------------------------------------------------
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    //--------------------------------------------------
    // UART Transmitter
    //--------------------------------------------------
    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .data_in(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    //--------------------------------------------------
    // UART Receiver
    //--------------------------------------------------
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(tx),              // Loopback connection
        .data_out(rx_data),
        .rx_done(rx_done)
    );

endmodule