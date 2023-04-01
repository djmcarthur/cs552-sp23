/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE
    wire [3:0] cout;
    wire [3:0] G;
    wire [3:0] P;

    cla_logic_16b cla_logic(.c_out(cout), .G(G), .P(P), .c_in(c_in));

    cla_4b cla3(.s(sum[15:12]), .c_out(), .G(G[3]), .P(P[3]), .a(a[15:12]), .b(b[15:12]), .c_in(cout[2]));
    cla_4b cla2(.s(sum[11:8]), .c_out(), .G(G[2]), .P(P[2]), .a(a[11:8]), .b(b[11:8]), .c_in(cout[1]));
    cla_4b cla1(.s(sum[7:4]), .c_out(), .G(G[1]), .P(P[1]), .a(a[7:4]), .b(b[7:4]), .c_in(cout[0]));
    cla_4b cla0(.s(sum[3:0]), .c_out(), .G(G[0]), .P(P[0]), .a(a[3:0]), .b(b[3:0]), .c_in(c_in));

    assign c_out = cout[3];
endmodule
