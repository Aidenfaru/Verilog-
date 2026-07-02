module baud_gen
#(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 9600
)
(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

    // Number of clock cycles per baud period
    localparam integer BAUD_DIV = CLK_FREQ / BAUD_RATE;

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
            if (counter == BAUD_DIV - 1)
            begin
                counter   <= 32'd0;
                baud_tick <= 1'b1;   // One-clock pulse
            end
            else
            begin
                counter   <= counter + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule