/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (instr, pc_inc, next_pc, halt, clk, rst, sel_pc_new, stall);

   output wire [15:0] instr;
   output wire [15:0] pc_inc;

   input wire [15:0] next_pc;  
   input wire halt, clk, rst;

   wire [15:0] instr_addr;
   wire [15:0] nxt_pc;
   input wire  sel_pc_new, stall;
   

   assign nxt_pc = ((halt & (~rst)) | (stall & ~sel_pc_new)) ? instr_addr : 
		   sel_pc_new ? next_pc : pc_inc;

   cla_16b add_pc(.sum(pc_inc), .c_out(), .a(instr_addr), .b(16'd2), .c_in(1'b0));
   
   memory2c instr_mem(.data_out(instr), 
         .data_in(16'b0), .addr(instr_addr), .enable(~rst), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));

   dff pc_reg [15:0] (.q(instr_addr), .d(nxt_pc), .clk(clk), .rst(rst));

endmodule
`default_nettype none
