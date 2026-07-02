module uart_rx(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire rx,

    output reg [7:0] data_out,
    output reg rx_done
);

    // State Encoding
    localparam IDLE  = 2'b00;
    localparam DATA  = 2'b01;
    localparam STOP  = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            data_out <= 8'd0;
            rx_done <= 1'b0;
        end

        else
        begin

            rx_done <= 1'b0;

            case(state)

            //-----------------------------------------
            // IDLE
            //-----------------------------------------

            IDLE:
            begin
                bit_count <= 3'd0;

                if(rx == 1'b0)
                begin
                    state <= DATA;
                end
            end

            //-----------------------------------------
            // RECEIVE DATA
            //-----------------------------------------

            DATA:
            begin
                if(baud_tick)
                begin
                    shift_reg[bit_count] <= rx;

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

            //-----------------------------------------
            // STOP BIT
            //-----------------------------------------

            STOP:
            begin
                if(baud_tick)
                begin
                    data_out <= shift_reg;
                    rx_done <= 1'b1;
                    state <= IDLE;
                end
            end

            endcase

        end

    end

endmodule