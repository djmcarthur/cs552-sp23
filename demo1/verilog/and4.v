/*

    CS 552 Spring '23
    
    5 input AND
*/
`default_nettype none
module and4(out, in1, in2, in3, in4);
    output wire out;
    input wire in1, in2, in3, in4;

    wire and21Inter, and22Inter;

    and2 and2_1(and21Inter, in1, in2);
    and2 and2_2(and22Inter, in3, in4);
    and2 and2Res(out, and21Inter, and22Inter);
endmodule
`default_nettype wire
