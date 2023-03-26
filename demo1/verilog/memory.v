/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (mem_data, alu_res_out, alu_cond_out, pc_inc_out, mem_read, mem_write,
		alu_cond_in, alu_res_in, pc_inc_in, data_in, instr, halt, clk, rst);

   output wire [15:0] mem_data;
   output wire [15:0] alu_res_out;
   output wire alu_cond_out;
   output wire [15:0] pc_inc_out;

   input wire clk, rst;
   input wire mem_read, mem_write;
   input wire alu_cond_in;
   input wire [15:0] alu_res_in;
   input wire [15:0] pc_inc_in;
   input wire [15:0] data_in;
   input wire [15:0] instr;
   input wire [1:0]  writeDataSel;
   input wire halt;

   memory2c d_mem(.data_out(mem_data),.data_in(data_in),.addr(alu_res_in),.enable(mem_read),.wr(mem_write),.createdump(halt),.clk(clk),.rst(rst));

   assign reg_write = (writeDataSel == 2'b00) ? instr[7:5] :
	              (writeDataSel == 2'b01) ? instr[4:2] :
		      (writeDataSel == 2'b10) ? instr[10:8] :
		      (writeDataSel == 2'b11) ? 3'b111 :
		      3'b111;
   
endmodule
`default_nettype wire
