/*

    CS 552 Spring '23
    
    5 input AND
*/
`default_nettype none
module and5(out, in1, in2, in3, in4, in5);
    output wire out;
    input wire in1, in2, in3, in4, in5;

    wire and2Inter, and3Inter;

    and2 and2(and2Inter, in1, in2);
    and3 and3(and3Inter, in3, in4, in5);
    and2 and2Res(out, and2Inter, and3Inter);
endmodule
`default_nettype wire
