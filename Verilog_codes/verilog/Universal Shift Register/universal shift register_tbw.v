`timescale 1ns/1ps

module universal_shift_register_tb;

reg clk;
reg reset;
reg [1:0] mode;
reg serial_right;
reg serial_left;
reg [3:0] parallel_in;

wire [3:0] q;

universal_shift_register uut(
    .clk(clk),
    .reset(reset),
    .mode(mode),
    .serial_right(serial_right),
    .serial_left(serial_left),
    .parallel_in(parallel_in),
    .q(q)
);

// Clock generation
always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    mode = 2'b00;
    serial_right = 0;
    serial_left = 0;
    parallel_in = 4'b0000;

    #10 reset = 0;

    // Parallel Load (1010)
    mode = 2'b11;
    parallel_in = 4'b1010;
    #10;

    // Hold
    mode = 2'b00;
    #10;

    // Shift Right (insert 1)
    mode = 2'b01;
    serial_right = 1;
    #10;

    // Shift Right (insert 0)
    serial_right = 0;
    #10;

    // Shift Left (insert 1)
    mode = 2'b10;
    serial_left = 1;
    #10;

    // Shift Left (insert 0)
    serial_left = 0;
    #10;

    // Parallel Load (1100)
    mode = 2'b11;
    parallel_in = 4'b1100;
    #10;

    #20;
    $finish;
end

initial
begin
    $monitor("Time=%0t Reset=%b Mode=%b Parallel=%b SR=%b SL=%b Q=%b",
             $time, reset, mode, parallel_in,
             serial_right, serial_left, q);
end

endmodule