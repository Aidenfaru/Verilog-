module uart_rx(
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       rx,

    output reg [7:0]  data_out,
    output reg        rx_done
);

    // State Encoding
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            data_out  <= 8'd0;
            rx_done   <= 1'b0;
        end
        else
        begin
            // Default
            rx_done <= 1'b0;

            case (state)

                //---------------------------------
                // Wait for Start Bit
                //---------------------------------
                IDLE:
                begin
                    bit_count <= 3'd0;

                    if (rx == 1'b0)
                        state <= START;
                end

                //---------------------------------
                // Start Bit
                //---------------------------------
                START:
                begin
                    if (baud_tick)
                    begin
                        if (rx == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                //---------------------------------
                // Receive Data
                //---------------------------------
                DATA:
                begin
                    if (baud_tick)
                    begin
                        shift_reg[bit_count] <= rx;

                        if (bit_count == 3'd7)
                        begin
                            bit_count <= 3'd0;
                            state <= STOP;
                        end
                        else
                        begin
                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end

                //---------------------------------
                // Stop Bit
                //---------------------------------
                STOP:
                begin
                    if (baud_tick)
                    begin
                        if (rx == 1'b1)
                        begin
                            data_out <= shift_reg;
                            rx_done  <= 1'b1;
                        end

                        state <= IDLE;
                    end
                end

                default:
                    state <= IDLE;

            endcase
        end
    end

endmodule