/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (instr, pc_inc, pc_new, halt, clk, rst);

   // TODO: Your code here
   output wire [15:0] instr;
   output wire [15:0] pc_inc;

   input wire [15:0] pc_new;
   input wire clk, rst;
   input      halt; // Need halt input for mux to pc      

   wire       [15:0] pc_current;
   wire       next_pc;
   

   // PC
   dff pc [15:0](.q(pc_current), .d(next_pc), .clk(clk), .rst(rst));

   // Instruction memory instantiation
   memory2c instr_mem(.data_out(instr),.data_in(16'b0),.addr(pc_current),.enable(1'b1),.wr(1'b0),.createdump(halt),.clk(clk),.rst(rst));

   // mux to determine next pc value we take
   assign next_pc = (halt & (~rst)) ? pc_current : pc_new;

   // Adder to increment PC
   cla16b add_pc(.sum(pc_inc), .cOut(), .inA(pc_current), .inB(16'd2), .cIn(1'b0), .sub(1'b0));
   
endmodule
`default_nettype wire
