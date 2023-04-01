module cla_logic_16b(c_out, G, P, c_in);

output [3:0] c_out;
input c_in;
input [3:0] G;
input [3:0] P;

wire c1, c2, c3, c4;

and2 andA(c1, P[0], c_in);
or2 orA(c_out[0], c1, G[0]);

and2 andB(c2, P[1], c_out[0]);
or2 orB(c_out[1], c2, G[1]);

and2 andC(c3, P[2], c_out[1]);
or2 orC(c_out[2], c3, G[2]);

and2 andD(c4, P[3], c_out[2]);
or2 orD(c_out[3], c4, G[3]);

endmodule