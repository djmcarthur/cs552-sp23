/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 1

    2-1 mux template
*/
`default_nettype none
module mux2_1(out, inputA, inputB, sel);
    output wire  out;
    input wire  inputA, inputB;
    input wire  sel;

    wire inA_1, inB_1, inA_2, inB_2, out_1, sNot;
    not1 notA(sNot, sel);
    nand2 nandA(inA_1, sNot, inputA);
    nand2 nandB(inB_1, sel, inputB);
    nand2 nandC(inA_2, inA_1, inA_1);
    nand2 nandD(inB_2, inB_1, inB_1);
    nor2 norA(out_1, inA_2, inB_2);
    nor2 norB(out, out_1, out_1);
    
endmodule
`default_nettype wire
