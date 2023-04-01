module or2(out, in1, in2);

output out;
input in1;
input in2;

wire out_1;

nor2 nor1(out_1, in1, in2);
nor2 nor2(out, out_1, out_1);

endmodule