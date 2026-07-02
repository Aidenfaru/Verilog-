`timescale 1ns / 1ps

module baud_gen_tb;

    // Testbench signals
    reg clk;
    reg rst;
    wire baud_tick;

    // Instantiate DUT (Device Under Test)
    baud_gen #(
        .CLK_FREQ(100),
        .BAUD_RATE(10)
    ) uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    // Clock Generation (10 ns period = 100 MHz equivalent for simulation)
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial
    begin
        rst = 1;

        #20;
        rst = 0;

        // Run simulation for some time
        #300;

        $finish;
    end

    // Monitor outputs
    initial
    begin
        $monitor("Time = %0t | Counter Tick = %b", $time, baud_tick);
    end

endmodule