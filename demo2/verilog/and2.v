module and2(out, in1, in2);

output out;
input in1;
input in2;

wire out_1;

nand2 nand1(out_1, in1, in2);
nand2 nand2(out, out_1, out_1);

endmodule