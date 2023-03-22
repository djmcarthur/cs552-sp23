/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (instr, pc_inc, pc_new);

   // TODO: Your code here
   output wire instr[15:0];
   output wire pc_inc[15:0];

   input wire pc_new[15:0];
   
endmodule
`default_nettype wire
