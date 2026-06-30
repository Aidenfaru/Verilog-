`timescale 1ns/1ps

module full_adder_32_tb;

reg  [31:0] a;
reg  [31:0] b;
reg         cin;

wire [31:0] sum;
wire        cout;

full_adder_32 uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial
begin
    a = 32'd10;
    b = 32'd20;
    cin = 0;
    #10;

    a = 32'd100;
    b = 32'd50;
    cin = 0;
    #10;

    a = 32'hFFFFFFFF;
    b = 32'd1;
    cin = 0;
    #10;

    a = 32'd500;
    b = 32'd300;
    cin = 1;
    #10;

    $finish;
end

endmodule