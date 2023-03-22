/*
    Logic block for hierarchical 16b carry lookahead

*/
`default_nettype none
module cla_logic_16b(cOut, G, P, cIn);

    output wire [3:0] cOut;
    input wire cIn;
    input wire [3:0] G;
    input wire [3:0] P;


    wire c4Expr2;
    wire c8Expr2, c8Expr3;
    wire c12Expr2, c12Expr3, c12Expr4;
    wire c16Expr2, c16Expr3, c16Expr4, c16Expr5;

    // carry 16 logic
    or5 c16log(.out(cOut[3]),.in1(G[3]),.in2(c16Expr2),.in3(c16Expr3),.in4(c16Expr4),.in5(c16Expr5));

    and5 c16Inter1(.out(c16Expr5),.in1(P[3]),.in2(P[2]),.in3(P[1]),.in4(P[0]),.in5(cIn));
    and4 c16Inter2(.out(c16Expr4),.in1(P[3]),.in2(P[2]),.in3(P[1]),.in4(G[0]));
    and3 c16Inter3(.out(c16Expr3),.in1(P[3]),.in2(P[2]),.in3(G[1]));
    and2 c16Inter4(.out(c16Expr2),.in1(P[3]),.in2(G[2]));


    // carry 12 logic
    or4 c12log(.out(cOut[2]),.in1(G[2]),.in2(c12Expr2),.in3(c12Expr3),.in4(c12Expr4));

    and4 c12Inter1(.out(c12Expr4),.in1(P[2]),.in2(P[1]),.in3(P[0]),.in4(cIn));
    and3 c12Inter2(.out(c12Expr3),.in1(P[2]),.in2(P[1]),.in3(G[0]));
    and2 c12Inter3(.out(c12Expr2),.in1(P[2]),.in2(G[1]));


    // carry 8 logic
    or3 c8log(.out(cOut[1]),.in1(G[1]),.in2(c8Expr2),.in3(c8Expr3));

    and3 c8Inter1(.out(c8Expr3),.in1(P[1]),.in2(P[0]),.in3(cIn));
    and2 c8Inter2(.out(c8Expr2),.in1(P[1]),.in2(G[0]));


    // carry 4 logic
    or2 c4log(.out(cOut[0]),.in1(G[0]),.in2(c4Expr2));

    and2 c4Inter1(.out(c4Expr2),.in1(P[0]),.in2(cIn));


endmodule
`default_nettype wire
