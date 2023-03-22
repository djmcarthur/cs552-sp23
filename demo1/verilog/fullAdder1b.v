/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
`default_nettype none
module fullAdder1b(s, cOut, gen, prop, inA, inB, cIn);
    output wire s;
    output wire cOut;
    output wire gen, prop;
    input  wire inA, inB;
    input  wire cIn;

    // YOUR CODE HERE
    wire xor2_1_o;
    wire and2_1_o;
    wire and2_2_o;

    xor2 xor2_1(.out(xor2_1_o),.in1(inA     ),.in2(inB     ));
    xor2 xor2_2(.out(s       ),.in1(xor2_1_o),.in2(cIn     ));
    and2 and2_1(.out(and2_1_o),.in1(xor2_1_o),.in2(cIn     ));
    and2 and2_2(.out(and2_2_o),.in1(inA     ),.in2(inB     ));
    or2  or2_1 (.out(cOut    ),.in1(and2_1_o),.in2(and2_2_o));

    // generate and propagate signals
    and2 genlogic(.out(gen ),.in1(inA),.in2(inB));
    or2 proplogic(.out(prop),.in1(inA),.in2(inB)); 

endmodule
`default_nettype wire
