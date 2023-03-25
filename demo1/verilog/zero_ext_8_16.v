module zero_ext_8_16(out, in);

    output wire [15:0] out;
    output wire [15:0] in;

    assign out = {8'b0, in[7:0]};

endmodule
