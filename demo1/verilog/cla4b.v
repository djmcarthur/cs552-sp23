/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
`default_nettype none
module cla4b(sum, cOut, inA, inB, cIn, P, G, sub);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;
    input wire 		sub; 		
    output wire       	P, G;
   

    // YOUR CODE HERE
   wire [N: 0] 		c;
   wire [N-1: 0] 	c_out; 	

   assign cOut = c[N];

   cla4_logic cla4_block(.c(c), .P(P), .G(G), .inA(inA), .inB(inB),.c_in(cIn));
   
   fullAdder1b add[N-1:0](.s(sum), .cOut(c_out), .inA(inA), .inB(inB), .cIn(c[3:0]), .sub(sub));
   
endmodule
`default_nettype wire
