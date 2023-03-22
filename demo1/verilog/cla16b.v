/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
`default_nettype none
module cla16b(sum, cOut, inA, inB, cIn);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;

    // YOUR CODE HERE
    wire [3:0] carry;
    wire [3:0] G;
    wire [3:0] P;

    assign cOut = carry[3];

    cla4b cla3(.sum(sum[15:12]),.cOut(),.G(G[3]),.P(P[3]),.inA(inA[15:12]),.inB(inB[15:12]),.cIn(carry[2]));
    cla4b cla2(.sum(sum[11:8] ),.cOut(),.G(G[2]),.P(P[2]),.inA(inA[11:8] ),.inB(inB[11:8] ),.cIn(carry[1]));
    cla4b cla1(.sum(sum[7:4]  ),.cOut(),.G(G[1]),.P(P[1]),.inA(inA[7:4]  ),.inB(inB[7:4]  ),.cIn(carry[0]));
    cla4b cla0(.sum(sum[3:0]  ),.cOut(),.G(G[0]),.P(P[0]),.inA(inA[3:0]  ),.inB(inB[3:0]  ),.cIn(cIn     ));

    cla_logic_16b cla_logic(.cOut(carry),.G(G),.P(P),.cIn(cIn));

endmodule
`default_nettype wire
