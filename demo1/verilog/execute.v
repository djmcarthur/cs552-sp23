/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (pc_inc_in, pc_new, alu_res, instr_10_2_out, alu_cond,
		read_data1_in, read_data2_in, sign_ext_11_16, sign_ext_8_16, sign_ext_5_16, zero_ext_5_16, zero_ext_8_16, instr_10_2_in, clk, rst);

   // TODO: Your code here
   output wire [15:0] pc_inc_in;
   output wire [15:0] pc_new;
   output wire [15:0] alu_res;
   output wire [10:2] instr_10_2_out;
   output wire alu_cond;

   input wire clk, rst;
   input wire [15:0] read_data1_in, read_data2_in;
   input wire [15:0] sign_ext_11_16;
   input wire [15:0] sign_ext_8_16;
   input wire [15:0] sign_ext_5_16;
   input wire [15:0] zero_ext_5_16;
   input wire [15:0] zero_ext_8_16;
   input wire [10:2] instr_10_2_in;
   
endmodule
`default_nettype wire
