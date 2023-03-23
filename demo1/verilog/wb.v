/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (reg_write_data, pc_inc_in, alu_res_in, mem_data, alu_cond_in, clk, rst);

   // TODO: Your code here
   output wire [15:0] reg_write_data;

   input wire clk, rst;
   input wire [15:0] pc_inc_in;
   input wire [15:0] alu_res_in;
   input wire [15:0] mem_data;
   input wire alu_cond_in;
   
endmodule
`default_nettype wire
