module uart_tx(
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] data_in,

    output reg        tx,
    output reg        tx_busy
);

    // State Encoding
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state     <= IDLE;
            tx         <= 1'b1;      // UART idle is HIGH
            tx_busy    <= 1'b0;
            shift_reg  <= 8'd0;
            bit_count  <= 3'd0;
        end
        else
        begin
            case (state)

                //---------------------------------
                // IDLE
                //---------------------------------
                IDLE:
                begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;

                    if (tx_start)
                    begin
                        shift_reg <= data_in;
                        bit_count <= 3'd0;
                        tx_busy <= 1'b1;
                        state <= START;
                    end
                end

                //---------------------------------
                // START BIT
                //---------------------------------
                START:
                begin
                    tx <= 1'b0;

                    if (baud_tick)
                        state <= DATA;
                end

                //---------------------------------
                // DATA BITS
                //---------------------------------
                DATA:
                begin
                    tx <= shift_reg[0];

                    if (baud_tick)
                    begin
                        shift_reg <= shift_reg >> 1;

                        if (bit_count == 3'd7)
                            state <= STOP;
                        else
                            bit_count <= bit_count + 1'b1;
                    end
                end

                //---------------------------------
                // STOP BIT
                //---------------------------------
                STOP:
                begin
                    tx <= 1'b1;

                    if (baud_tick)
                        state <= IDLE;
                end

                default:
                    state <= IDLE;

            endcase
        end
    end

endmodule