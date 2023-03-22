/*
    CS/ECE 552 Spring '23
    
    an implementation of carry lookahead logic
*/
`default_nettype none
module cla_logic_4b(P, G, c_out, g, p, c_in);

    output wire P;
    output wire G;
    output wire [3:0] c_out;
    input wire [3:0] g;
    input wire [3:0] p;
    input wire c_in;

    wire c1Expr2;
    wire c2Expr2, c2Expr3;
    wire c3Expr2, c3Expr3, c3Expr4;
    wire c4Expr2, c4Expr3, c4Expr4, c4Expr5;
    wire bigGInter1, bigGInter2, bigGInter3;

    // c_out[3:0] --> C4, C3, C2, C1

    // break into expressions
    /*
    
    EXPR NUMBER
    ----------------------------------------------------------------------------------------
       |   1  |     2     |       3        |          4          |            5            |
    ----------------------------------------------------------------------------------------
    c1 = (g0) + (p0 * c0)

    c2 = (g1) + (p1 * g0) + (p1 * p0 * c0)

    c3 = (g2) + (p2 * g1) + (p2 * p1 * g0) + (p2 * p1 * p0 * c0)

    c4 = (g3) + (p3 * g2) + (p3 * p2 * g1) + (p3 * p2 * p1 * g0) + (p3 * p2 * p1 * p0 * c0)

    NOTE: Expr1 for some c(i) is always g(i-1)

    */

    // carry 4 logic
    or5 c4log(.out(c_out[3]),.in1(g[3]),.in2(c4Expr2),.in3(c4Expr3),.in4(c4Expr4),.in5(c4Expr5));

    and5 c4Inter1(.out(c4Expr5),.in1(p[3]),.in2(p[2]),.in3(p[1]),.in4(p[0]),.in5(c_in));
    and4 c4Inter2(.out(c4Expr4),.in1(p[3]),.in2(p[2]),.in3(p[1]),.in4(g[0]));
    and3 c4Inter3(.out(c4Expr3),.in1(p[3]),.in2(p[2]),.in3(g[1]));
    and2 c4Inter4(.out(c4Expr2),.in1(p[3]),.in2(g[2]));


    // carry 3 logic
    or4 c3log(.out(c_out[2]),.in1(g[2]),.in2(c3Expr2),.in3(c3Expr3),.in4(c3Expr4));

    and4 c3Inter1(.out(c3Expr4),.in1(p[2]),.in2(p[1]),.in3(p[0]),.in4(c_in));
    and3 c3Inter2(.out(c3Expr3),.in1(p[2]),.in2(p[1]),.in3(g[0]));
    and2 c3Inter3(.out(c3Expr2),.in1(p[2]),.in2(g[1]));


    // carry 2 logic
    or3 c2log(.out(c_out[1]),.in1(g[1]),.in2(c2Expr2),.in3(c2Expr3));

    and3 c2Inter1(.out(c2Expr3),.in1(p[1]),.in2(p[0]),.in3(c_in));
    and2 c2Inter2(.out(c2Expr2),.in1(p[1]),.in2(g[0]));


    // carry 1 logic
    or2 c1log(.out(c_out[0]),.in1(g[0]),.in2(c1Expr2));

    and2 c1Inter1(.out(c1Expr2),.in1(p[0]),.in2(c_in));


    // define P and G
    and4 bigPLogic(.out(P),.in1(p[3]),.in2(p[2]),.in3(p[1]),.in4(p[0]));

    or4 bigGLogic(.out(G),.in1(g[3]),.in2(bigGInter1),.in3(bigGInter2),.in4(bigGInter3));
    and2 bigG1(.out(bigGInter1),.in1(p[3]),.in2(g[2]));
    and3 bigG2(.out(bigGInter2),.in1(p[3]),.in2(p[2]),.in3(g[1]));
    and4 bigG3(.out(bigGInter3),.in1(p[3]),.in2(p[2]),.in3(p[1]),.in4(g[0]));


endmodule
`default_nettype wire
