module uart_tx(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire tx_start,
    input wire [7:0] data_in,

    output reg tx,
    output reg tx_busy
);

    // State Encoding
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state     <= IDLE;
            tx         <= 1'b1;
            tx_busy    <= 1'b0;
            shift_reg  <= 8'd0;
            bit_count  <= 3'd0;
        end

        else
        begin

            case(state)

            //--------------------------------------------------
            // IDLE STATE
            //--------------------------------------------------

            IDLE:
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;

                if(tx_start)
                begin
                    shift_reg <= data_in;
                    bit_count <= 3'd0;
                    tx_busy <= 1'b1;
                    state <= START;
                end
            end

            //--------------------------------------------------
            // START BIT
            //--------------------------------------------------

            START:
            begin
                if(baud_tick)
                begin
                    tx <= 1'b0;
                    state <= DATA;
                end
            end

            //--------------------------------------------------
            // DATA BITS
            //--------------------------------------------------

            DATA:
            begin
                if(baud_tick)
                begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;

                    if(bit_count == 3'd7)
                    begin
                        state <= STOP;
                    end
                    else
                    begin
                        bit_count <= bit_count + 1;
                    end
                end
            end

            //--------------------------------------------------
            // STOP BIT
            //--------------------------------------------------

            STOP:
            begin
                if(baud_tick)
                begin
                    tx <= 1'b1;
                    state <= IDLE;
                end
            end

            endcase

        end

    end

endmodule