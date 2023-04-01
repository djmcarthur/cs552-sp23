/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1(out, inA, inB, s);
    output  out;
    input   inA, inB;
    input   s;

    // YOUR CODE HERE
    wire inA_1, inB_1, inA_2, inB_2, out_1, sbar;
    not1 notA(sbar, s);
    nand2 nandA(inA_1, sbar, inA);
    nand2 nandB(inB_1, s, inB);
    nand2 nandC(inA_2, inA_1, inA_1);
    nand2 nandD(inB_2, inB_1, inB_1);
    nor2 norA(out_1, inA_2, inB_2);
    nor2 norB(out, out_1, out_1);
        
    
endmodule
