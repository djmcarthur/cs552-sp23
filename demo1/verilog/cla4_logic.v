/*
    a 4 bit CLA Logic Block
*/
`default_nettype none
module cla4_logic(c,inA, inB, c_in, P, G);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output wire [N: 0] c;
    input wire [N-1: 0] inA, inB;
    input wire 		c_in;
    output wire         P, G;

   wire [N-1: 0] 	gen;
   wire [N-1: 0] 	prop;
   wire [N: 1] 		cin_prop;
   wire [N: 2]          gen0_prop;
   wire [N: 3]          gen1_prop;
   wire [N: 3]          gen2_prop;
 		
 		
 	
   assign c[0] = c_in;

   or2 or2_0[N-1: 0](.out(prop), .in1(inA), .in2(inB));
   
   and2 and2_0[N-1: 0](.out(gen), .in1(inA), .in2(inB));

   //Logic for c1
   and2 and2_1(.out(cin_prop[1]), .in1(prop[0]), .in2(c[0]));
   or2 or2_1(.out(c[1]), .in1(cin_prop[1]), .in2(gen[0]));

   // Logic for c2
   and3 and3_2(.out(cin_prop[2]), .in1(prop[0]), .in2(prop[1]), .in3(c[0]));
   and2 and2_2(.out(gen0_prop[2]), .in1(gen[0]), .in2(prop[1]));
   or3 or3_3(.out(c[2]), .in1(cin_prop[2]), .in2(gen0_prop[2]), .in3(gen[1]));

   // Logic for c3
   and4 and4_3(.out(cin_prop[3]), .in1(prop[0]), .in2(prop[1]), .in3(prop[2]), .in4(c[0]));
   and3 and3_3(.out(gen0_prop[3]), .in1(gen[0]), .in2(prop[1]), .in3(prop[2]));
   and2 and2_3(.out(gen1_prop[3]), .in1(gen[1]), .in2(prop[2]));
   or4 or4_3(.out(c[3]), .in1(cin_prop[3]), .in2(gen0_prop[3]), .in3(gen1_prop[3]), .in4(gen[2]));

   // Logic for c4
   and5 and5_4(.out(cin_prop[4]), .in1(prop[0]), .in2(prop[1]), .in3(prop[2]), .in4(prop[3]), .in5(c[0]));
   and4 and4_4(.out(gen0_prop[4]), .in1(gen[0]), .in2(prop[1]), .in3(prop[2]), .in4(prop[3]));
   and3 and3_4(.out(gen1_prop[4]), .in1(gen[1]), .in2(prop[2]), .in3(prop[3]));
   and2 and2_4(.out(gen2_prop[4]), .in1(gen[2]), .in2(prop[3]));
   or5 or5_4(.out(c[4]), .in1(cin_prop[4]), .in2(gen0_prop[4]), .in3(gen1_prop[4]), .in4(gen2_prop[4]), .in5(gen[3]));

   // Logic for super gen (G)
   or4 or4_g(.out(G), .in1(gen0_prop[4]), .in2(gen1_prop[4]), .in3(gen2_prop[4]), .in4(gen[3]));

   // Logic for super prop (P)
   and4 and4_p(.out(P), .in1(prop[0]), .in2(prop[1]), .in3(prop[2]), .in4(prop[3]));
   
endmodule
`default_nettype wire
