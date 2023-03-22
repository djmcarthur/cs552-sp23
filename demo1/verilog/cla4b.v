/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
`default_nettype none
module cla4b(sum, cOut, G, P, inA, inB, cIn);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output wire [N-1:0] sum;
    output wire         cOut;
    output wire G, P;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;

    wire [3:0] p;
    wire [3:0] g;
    wire [3:0] carry;

    // YOUR CODE HERE

    assign cOut = carry[3];

    fullAdder1b fa1(.s(sum[3]),.cOut(),.gen(g[3]),.prop(p[3]),.inA(inA[3]),.inB(inB[3]),.cIn(carry[2]));
    fullAdder1b fa2(.s(sum[2]),.cOut(),.gen(g[2]),.prop(p[2]),.inA(inA[2]),.inB(inB[2]),.cIn(carry[1]));
    fullAdder1b fa3(.s(sum[1]),.cOut(),.gen(g[1]),.prop(p[1]),.inA(inA[1]),.inB(inB[1]),.cIn(carry[0]));
    fullAdder1b fa4(.s(sum[0]),.cOut(),.gen(g[0]),.prop(p[0]),.inA(inA[0]),.inB(inB[0]),.cIn(cIn));


    cla_logic_4b carry_logic(.P(P),.G(G),.c_out(carry),.g(g),.p(p),.c_in(cIn));
endmodule
`default_nettype wire
