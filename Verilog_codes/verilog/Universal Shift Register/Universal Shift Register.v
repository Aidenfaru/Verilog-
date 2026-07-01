module universal_shift_register(
    input clk,
    input reset,
    input [1:0] mode,      // 00 = Hold
                             // 01 = Shift Right
                             // 10 = Shift Left
                             // 11 = Parallel Load
    input serial_right,     // Input during Shift Right
    input serial_left,      // Input during Shift Left
    input [3:0] parallel_in,
    output reg [3:0] q
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        q <= 4'b0000;
    else
    begin
        case(mode)

            2'b00:    // Hold
                q <= q;

            2'b01:    // Shift Right
                q <= {serial_right, q[3:1]};

            2'b10:    // Shift Left
                q <= {q[2:0], serial_left};

            2'b11:    // Parallel Load
                q <= parallel_in;

            default:
                q <= q;

        endcase
    end
end

endmodule