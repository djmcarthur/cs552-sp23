module zero_ext_5_16(out, in);

output [15:0] out;
input [4:0] in;

assign out = {11'b0, in[4:0]};

endmodule