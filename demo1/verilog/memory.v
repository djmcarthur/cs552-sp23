/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (mem_data, alu_res_out, alu_cond_out, pc_inc_out,
		alu_cond_in, alu_res_in, pc_inc_in, instr_10_2_in, clk, rst);

   // TODO: Your code here
   output wire [15:0] mem_data;
   output wire [15:0] alu_res_out;
   output wire alu_cond_out;
   output wire [15:0] pc_inc_out;

   input wire clk, rst;
   input wire alu_cond_in;
   input wire [15:0] alu_res_in;
   input wire [15:0] pc_inc_in;
   input wire [10:2] instr_10_2_in;
   
endmodule
`default_nettype wire
