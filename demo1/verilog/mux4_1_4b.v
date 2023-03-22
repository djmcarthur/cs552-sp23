/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 1

    a 4-bit (quad) 4-1 Mux template
*/
`default_nettype none
module mux4_1_4b(out, inputA, inputB, inputC, inputD, sel);

    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 4;

    output wire [N-1:0]  out;
    input wire [N-1:0]   inputA, inputB, inputC, inputD;
    input wire [1:0]     sel;

    // YOUR CODE HERE
    // The quad 4:1 mux is composed of four single-bit 4:1 muxes
    mux4_1 mux4_1_quad[N-1:0](.out(out),.inputA(inputA),.inputB(inputB),.inputC(inputC),.inputD(inputD),.sel(sel)); 
endmodule
`default_nettype wire
