module sign_ext_8_16(out, in);

output [15:0] out;
input [7:0] in;

assign out = {{8{in[7]}}, in[7:0]};

endmodule