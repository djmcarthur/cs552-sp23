/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
module cla_4b(s, c_out, G, P, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] s;
    output         c_out, G, P;
    input [N-1: 0] a, b;
    input          c_in;

    wire [N-1:0] cout;

    fullAdder_1b fa0(.s(s[0]), .c_out(), .a(a[0]), .b(b[0]), .c_in(c_in));
    fullAdder_1b fa1(.s(s[1]), .c_out(), .a(a[1]), .b(b[1]), .c_in(cout[0]));
    fullAdder_1b fa2(.s(s[2]), .c_out(), .a(a[2]), .b(b[2]), .c_in(cout[1]));
    fullAdder_1b fa3(.s(s[3]), .c_out(), .a(a[3]), .b(b[3]), .c_in(cout[2]));
    assign c_out = cout[3];

    cla_logic_4b cla(.P(P), .G(G), .c_out(cout), .a(a), .b(b), .c_in(c_in));

endmodule
