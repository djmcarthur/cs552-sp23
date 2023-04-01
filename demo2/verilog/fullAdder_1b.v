/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
`default_nettype none
module fullAdder_1b(s, c_out, a, b, c_in);
    output wire s;
    output wire c_out;
    input  wire  a, b;
    input wire c_in;

    // YOUR CODE HERE
    wire nandAB1, nandAB2, nandAxorBC1, nandAorBC2, norcout, xorAB, nandAxorBC2;

    xor2 xorA(xorAB, a, b);
    xor2 xorB(s, xorAB, c_in);
    nand2 nandA(nandAB1, a, b);
    nand2 nandB(nandAB2, nandAB1, nandAB1);
    nand2 nandC(nandAxorBC1, xorAB, c_in);
    nand2 nandD(nandAxorBC2, nandAxorBC1, nandAxorBC1);
    nor2 norA(norcout, nandAxorBC2, nandAB2);
    nor2 norB(c_out, norcout, norcout);

endmodule
`default_nettype wire