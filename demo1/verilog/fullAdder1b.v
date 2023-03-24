/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
`default_nettype none
module fullAdder1b(s, cOut, inA, inB, cIn, sub);
    output wire s;
    output wire cOut;
    input  wire inA, inB;
    input  wire sub;
    input  wire cIn;

    // YOUR CODE HERE
   wire 	gen, prop, propAndcIn;
   wire 	opB;

   xor2 xor2_0(.out(opB), .in1(sub), .in2(inB));

   xor2 xor2_1(.out(prop), .in1(inA), .in2(opB));
   and2 and2_1(.out(gen),.in1(inA), .in2(opB));
   and2 and2_2(.out(propAndcIn), .in1(cIn), .in2(prop));
   xor2 xor2_2(.out(s), .in1(prop), .in2(cIn));
   or2 or2_1(.out(cOut), .in1(gen), .in2(propAndcIn));   
   

endmodule
`default_nettype wire
