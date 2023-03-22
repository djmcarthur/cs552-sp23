/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 1

    4-1 mux template
*/
`default_nettype none
module mux4_1(out, inputA, inputB, inputC, inputD, sel);
    output wire      out;
    input wire       inputA, inputB, inputC, inputD;
    input wire [1:0] sel;

    // 4:1 mux can be built using three 2:1 mux
    wire lowBitOut;
    wire highBitOut;
    mux2_1 muxLow0(.out(lowBitOut ),.inputA(inputA   ),.inputB(inputB    ),.sel(sel[0]));
    mux2_1 muxLow1(.out(highBitOut),.inputA(inputC   ),.inputB(inputD    ),.sel(sel[0]));
    mux2_1 muxHigh(.out(out       ),.inputA(lowBitOut),.inputB(highBitOut),.sel(sel[1]));
      
endmodule
`default_nettype wire
