/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (data, data2, data_res, mem_write, mem_read, halt, clk, rst);

   output wire [15:0] data;

   input wire [15:0] data2, data_res;
   input wire mem_write, mem_read, halt, clk, rst;

   wire en, wr;

   assign en = mem_read;
   assign wr = (mem_write);
   // mem_write | mem_read);
   // assign wr = (mem_write & mem_read);

   memory2c data_mem(.data_out(data), 
                     .data_in(data2), .addr(data_res), .enable(en), .wr(wr), .createdump(halt), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire