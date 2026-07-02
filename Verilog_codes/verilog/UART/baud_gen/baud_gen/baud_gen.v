module baud_gen #(
    parameter CLK_FREQ  = 100_000_000, // FPGA Clock Frequency (100 MHz)
    parameter BAUD_RATE = 9600          // UART Baud Rate
)(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

    // Number of clock cycles for one baud period
    localparam BAUD_COUNT = CLK_FREQ / BAUD_RATE;

    // Counter
    reg [31:0] counter;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            counter   <= 32'd0;
            baud_tick <= 1'b0;
        end
        else
        begin
            if (counter == BAUD_COUNT - 1)
            begin
                counter   <= 32'd0;
                baud_tick <= 1'b1;      // Generate one-clock pulse
            end
            else
            begin
                counter   <= counter + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule