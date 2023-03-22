/*

    CS 552 Spring '23
    
    5 input AND
*/
`default_nettype none
module or4(out, in1, in2, in3, in4);
    output wire out;
    input wire in1, in2, in3, in4;

    wire or21Inter, or22Inter;

    or2 or2_1(or21Inter, in1, in2);
    or2 or2_2(or22Inter, in3, in4);
    or2 or2Res(out, or21Inter, or22Inter);
endmodule
`default_nettype wire
