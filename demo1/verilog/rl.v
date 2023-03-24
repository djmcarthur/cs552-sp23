/*
 Rotate left  module for HW2 ECE 552
*/
`default_nettype none
module rl (InBS, ShAmt, OutBS);

   // declare constant for size of inputs, outputs, and # bits to shift
   parameter OPERAND_WIDTH = 16;
   parameter SHAMT_WIDTH   =  4;

   input wire [OPERAND_WIDTH -1:0] InBS;  // Input operand
   input wire [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
   output wire [OPERAND_WIDTH -1:0] OutBS;  // Result of shift/rotate

   // intermediate wires
   wire [OPERAND_WIDTH -1:0] 	    sh0_result;
   wire [OPERAND_WIDTH -1:0] 	    sh1_result;
   wire [OPERAND_WIDTH -1:0] 	    sh2_result; 

   // Assign statements for each bit in shift amount to do proper shift
   assign sh0_result = ShAmt[0] ? {InBS[14:0], InBS[15]} : InBS;
   assign sh1_result = ShAmt[1] ? {sh0_result[13:0], sh0_result[15:14]} : sh0_result;
   assign sh2_result = ShAmt[2] ? {sh1_result[11:0], sh1_result[15:12]} : sh1_result;
   assign OutBS = ShAmt[3] ? {sh2_result[7:0], sh2_result[15:8]}: sh2_result; 

endmodule
`default_nettype wire   
