/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (reg_write_data, pc_inc_in, alu_res_in, mem_data, alu_cond_in, clk, rst);

   output wire [15:0] reg_write_data;

   input wire [15:0] pc_inc_in;
   input wire [15:0] alu_res_in;
   input wire [15:0] mem_data;
   input wire [1:0] reg_write;
   input wire alu_cond_in;

   assign reg_write_data = (reg_write == 2'b00) ? pc_inc_in :
	                    (reg_write == 2'b01) ? {{15'b0}, alu_cond} :
			    (reg_write == 2'b10) ? mem_data :
			    (reg_write == 2'b11) ? alu_res_in :
			    mem_data;
   
endmodule
`default_nettype wire
