/*

    CS 552 Spring '23
    
    5 input AND
*/
`default_nettype none
module or5(out, in1, in2, in3, in4, in5);
    output wire out;
    input wire in1, in2, in3, in4, in5;

    wire or2Inter, or3Inter;

    or2 or2(or2Inter, in1, in2);
    or3 or3(or3Inter, in3, in4, in5);
    or2 or2Res(out, or2Inter, or3Inter);
endmodule
`default_nettype wire
