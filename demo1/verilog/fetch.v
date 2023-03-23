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
   input      clk;
   input      rst;
   input      halt; // Need halt input for mux to pc      

   wire       pc_current[15:0];
   

   // PC Counter
   dff pc[15:0](.q(pc_new), .d(pc_current), .clk(clk), .rst(rst));

   // Instruction memory instantiation
   // TODO: Fill in ??? spots (data_in, enable, wr, createdump)
   memory2c instr_mem(.data_out(instr), .data_in( ??? ), .addr(pc_current), .enable( ??? ), .wr( ??? ), .createdump( ??? ), .clk(clk), .rst(rst));

   
   
endmodule
`default_nettype wire
