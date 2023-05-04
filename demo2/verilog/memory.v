`default_nettype none
module memory (data, data2, data_res, wr, en, halt, clk, rst);

   output wire [15:0] data;

   input wire [15:0] data2, data_res;
   input wire halt, clk, rst;

   input wire en, wr;

   memory2c data_mem(.data_out(data), 
                     .data_in(data2), .addr(data_res), .enable(en), .wr(wr), .createdump(halt), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire
