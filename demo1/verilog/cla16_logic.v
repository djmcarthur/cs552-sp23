/*
    a 16 bit CLA Logic Block
    Author: Brandon Niles
*/
`default_nettype none
module cla16_logic(c, P, G, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output wire [N: 0] c;
    input wire [N-1: 0] P, G;
    input wire 		c_in;
    wire [N: 1] cin_prop; 
    wire [N: 2]	gen0_prop;
    wire [N: 3] gen1_prop;
    wire [N: 3] gen2_prop;
 		
   assign c[0] = c_in;

   // Logic for c4
   and2 and2_1(.out(cin_prop[1]), .in1(P[0]), .in2(c[0]));
   or2 or2_1(.out(c[1]), .in1(cin_prop[1]), .in2(G[0]));

   // Logic for c8
   and3 and3_2(.out(cin_prop[2]), .in1(P[0]), .in2(P[1]), .in3(c[0]));
   and2 and2_2(.out(gen0_prop[2]), .in1(G[0]), .in2(P[1]));
   or3 or3_3(.out(c[2]), .in1(cin_prop[2]), .in2(gen0_prop[2]), .in3(G[1]));

   // Logic for c12
   and4 and4_3(.out(cin_prop[3]), .in1(P[0]), .in2(P[1]), .in3(P[2]), .in4(c[0]));
   and3 and3_3(.out(gen0_prop[3]), .in1(G[0]), .in2(P[1]), .in3(P[2]));
   and2 and2_3(.out(gen1_prop[3]), .in1(G[1]), .in2(P[2]));
   or4 or4_3(.out(c[3]), .in1(cin_prop[3]), .in2(gen0_prop[3]), .in3(gen1_prop[3]), .in4(G[2]));

   // Logic for c16
   and5 and5_4(.out(cin_prop[4]), .in1(P[0]), .in2(P[1]), .in3(P[2]), .in4(P[3]), .in5(c[0]));
   and4 and4_4(.out(gen0_prop[4]), .in1(G[0]), .in2(P[1]), .in3(P[2]), .in4(P[3]));
   and3 and3_4(.out(gen1_prop[4]), .in1(G[1]), .in2(P[2]), .in3(P[3]));
   and2 and2_4(.out(gen2_prop[4]), .in1(G[2]), .in2(P[3]));
   or5 or5_4(.out(c[4]), .in1(cin_prop[4]), .in2(gen0_prop[4]), .in3(gen1_prop[4]), .in4(gen2_prop[4]), .in5(G[3]));
   
endmodule
`default_nettype wire
