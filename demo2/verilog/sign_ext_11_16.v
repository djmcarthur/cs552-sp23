module sign_ext_11_16(out, in);

output [15:0] out;
input [10:0] in;

assign out = {{5{in[10]}}, in[10:0]};

endmodule