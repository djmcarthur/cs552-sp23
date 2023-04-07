/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 1

    4-1 mux template
*/
module mux4_1(out, inA, inB, inC, inD, s);
    output       out;
    input        inA, inB, inC, inD;
    input [1:0]  s;

    // YOUR CODE HERE
    wire out1, out2;
    mux2_1 mux1(.out(out1), .inA(inA), .inB(inB), .s(s[0]));
    mux2_1 mux2(.out(out2), .inA(inC), .inB(inD), .s(s[0]));
    mux2_1 mux3(.out(out), .inA(out1), .inB(out2), .s(s[1]));

      
endmodule
