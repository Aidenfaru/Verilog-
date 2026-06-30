module fifo (
    input clk,
    input reset,
    input write,
    input read,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

// FIFO Memory (4 locations, each 8 bits)
reg [7:0] fifo [0:3];

// Write Pointer
reg [1:0] wr_ptr;

// Read Pointer
reg [1:0] rd_ptr;

// Counter
reg [2:0] count;

// Status Signals
assign full  = (count == 4);
assign empty = (count == 0);

// Sequential Logic
always @(posedge clk)
begin

    // Reset FIFO
    if (reset)
    begin
        wr_ptr   <= 0;
        rd_ptr   <= 0;
        count    <= 0;
        data_out <= 0;
    end

    // Write Operation
    else if (write && !full)
    begin
        fifo[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
    end

    // Read Operation
    else if (read && !empty)
    begin
        data_out <= fifo[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
    end

end

endmodule