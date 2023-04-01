/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (wb_out, alu_cond, pc_inc, data, alu_res, reg_write_sel);

   output wire [15:0] wb_out;

   input wire [15:0] data, alu_res, pc_inc;
   input wire [1:0] reg_write_sel;
   input wire alu_cond;

   assign wb_out = (reg_write_sel == 2'b00) ? data     :
	   	          (reg_write_sel == 2'b01) ? alu_res  :
		             (reg_write_sel == 2'b10) ? alu_cond :
		             (reg_write_sel == 2'b11) ? pc_inc   :
                   data;


endmodule
`default_nettype wire