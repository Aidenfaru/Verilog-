module full_adder_32(
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);

wire [31:0] c;

full_adder FA0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(c[0])
);

genvar i;
generate
    for(i = 1; i < 32; i = i + 1)
    begin : ADDER
        full_adder FA (
            .a(a[i]),
            .b(b[i]),
            .cin(c[i-1]),
            .sum(sum[i]),
            .cout(c[i])
        );
    end
endgenerate

assign cout = c[31];

endmodule