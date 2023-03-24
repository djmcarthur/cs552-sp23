/*
    CS/ECE 552 Spring '23
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
`default_nettype none
module shifter (InBS, ShAmt, ShiftOper, OutBS);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input wire [OPERAND_WIDTH -1:0] InBS;  // Input operand
    input wire [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input wire [NUM_OPERATIONS-1:0] ShiftOper;  // Operation type
    output wire [OPERAND_WIDTH -1:0] OutBS;  // Result of shift/rotate

   /* YOUR CODE HERE */
   // Intermediate wires to hold different shift results
   wire [OPERAND_WIDTH -1:0] 	     sl_result;
   wire [OPERAND_WIDTH -1:0] 	     srl_result;
   wire [OPERAND_WIDTH -1:0] 	     rl_result;
   wire [OPERAND_WIDTH -1:0] 	     sra_result;
  
   // Istantiate sub-modules to do different shift operations
   sl sl0(.OutBS(sl_result), .ShAmt(ShAmt), .InBS(InBS));
   srl srl0(.OutBS(srl_result), .ShAmt(ShAmt), .InBS(InBS));
   rl rl0(.OutBS(rl_result), .ShAmt(ShAmt), .InBS(InBS));
   sra sra0(.OutBS(sra_result), .ShAmt(ShAmt), .InBS(InBS));

   assign OutBS = ShiftOper[1] ? (ShiftOper[0] ? sra_result : rl_result) : (ShiftOper[0] ? srl_result : sl_result); 	     
   
endmodule
`default_nettype wire
