`timescale 1ns / 1ps

module fifo_tb;

    // Inputs
    reg clk;
    reg reset;
    reg write;
    reg read;
    reg [7:0] data_in;

    // Outputs
    wire [7:0] data_out;
    wire full;
    wire empty;

    // Instantiate the FIFO
    fifo uut (
        .clk(clk),
        .reset(reset),
        .write(write),
        .read(read),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;

    // Test Procedure
    initial
    begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        write = 0;
        read = 0;
        data_in = 0;

        // Apply Reset
        #10;
        reset = 0;

        // Write 10
        #10;
        write = 1;
        data_in = 8'd10;

        // Write 20
        #10;
        data_in = 8'd20;

        // Write 30
        #10;
        data_in = 8'd30;

        // Stop Writing
        #10;
        write = 0;

        // Read First Value
        #10;
        read = 1;

        // Read Second Value
        #10;

        // Read Third Value
        #10;

        // Stop Reading
        #10;
        read = 0;

        // Finish Simulation
        #20;
        $finish;
    end

endmodule