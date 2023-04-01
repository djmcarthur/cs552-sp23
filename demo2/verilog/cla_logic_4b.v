
module cla_logic_4b(P, G, c_out, a, b, c_in);

parameter N = 4;

output G;
output P;
output [N-1:0] c_out;
input [N-1:0] a;
input [N-1:0] b;
input c_in;

wire p0, g0, c1;
wire p1, g1, c2;
wire p2, g2, c3;
wire c4;

or2 orA(p0, a[0], b[0]);
and2 andA(g0, a[0], b[0]);

and2 andB(c1, p0, c_in);
or2 orB(c_out[0], c1, g0);

or2 orC(p1, a[1], b[1]);
and2 andC(g1, a[1], b[1]);

and2 andD(c2, p1, c_out[0]);
or2 orD(c_out[1], c2, g1);

or2 orE(p2, a[2], b[2]);
and2 andE(g2, a[2], b[2]);

and2 andF(c3, p2, c_out[1]);
or2 orF(c_out[2], c3, g2);

or2 orG(p3, a[3], b[3]);
and2 andG(g3, a[3], b[3]);

and2 andH(c4, p3, c_out[2]);
or2 orH(c_out[3], c4, g3);

and2 andJ(p01, p0, p1);
and2 andK(p23, p2, p3);
and2 andL(P, p01, p23);

or2 orI(G, c_out[3], g3);

endmodule