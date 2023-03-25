/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (instr, pc_inc, pc_new, clk, rst);

   // TODO: Your code here
   output wire instr[15:0];
   output wire pc_inc[15:0];

   input wire pc_new[15:0];
   input wire clk, rst;
   input      halt; // Need halt input for mux to pc      

   wire       pc_current[15:0];
   wire       next_pc;
   

   // PC Counter
   dff pc [15:0](.q(instr), .d(pc_current), .clk(clk), .rst(rst));

   // Instruction memory instantiation
   memory2c instr_mem(.data_out(instr),.data_in(16'b0),.addr(pc_current),.enable(1'b1),.wr(1'b0),.createdump(halt),.clk(clk),.rst(rst));

   // mux to determine next pc value we take
   assign next_pc = (halt & (~rst)) ? pc_current : pc_new;

   cla16b add_pc(.sum(pc_inc), .c_out(), .a(pc_current), .b(16'd2), .c_in(1'b0));

   
endmodule
`default_nettype wire
