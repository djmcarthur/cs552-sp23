/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
`default_nettype none
module cla16b(sum, cOut, inA, inB, cIn, sub);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;
    input wire 		sub;
   

    // YOUR CODE HERE

    wire [(N/4): 0] 	c;
    wire [(N/4)-1: 0] 	c_out;
    wire [(N/4)-1: 0] 	P;
    wire [(N/4)-1: 0] 	G;
   

   assign cOut = c[N/4];

   cla4b cla4b_03(.sum(sum[3: 0]), .cOut(c_out[0]), .inA(inA[3: 0]), .inB(inB[3: 0]), .cIn(c[0]), .P(P[0]), .G(G[0]), .sub(sub));
   cla4b cla4b_47(.sum(sum[7: 4]), .cOut(c_out[1]), .inA(inA[7: 4]), .inB(inB[7: 4]), .cIn(c[1]), .P(P[1]), .G(G[1]), .sub(sub));
   cla4b cla4b_811(.sum(sum[11: 8]), .cOut(c_out[2]), .inA(inA[11: 8]), .inB(inB[11: 8]), .cIn(c[2]), .P(P[2]), .G(G[2]), .sub(sub));
   cla4b cla4b_1215(.sum(sum[15: 12]), .cOut(c_out[3]), .inA(inA[15: 12]), .inB(inB[15: 12]), .cIn(c[3]), .P(P[3]), .G(G[3]), .sub(sub));
   

   cla16_logic cla16_block(.c(c), .P(P), .G(G), .c_in(cIn));
   
     
endmodule
`default_nettype wire
