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
   wire [OPERAND_WIDTH -1:0] sllOut;
   wire [OPERAND_WIDTH -1:0] srlOut;
   wire [OPERAND_WIDTH -1:0] rolOut;
   wire [OPERAND_WIDTH -1:0] sraOut;

   sll sllOp(.InBS(InBS),.ShAmt(ShAmt),.OutBS(sllOut));
   srl srlOp(.InBS(InBS),.ShAmt(ShAmt),.OutBS(srlOut));
   rol rolOp(.InBS(InBS),.ShAmt(ShAmt),.OutBS(rolOut));
   sra sraOp(.InBS(InBS),.ShAmt(ShAmt),.OutBS(sraOut));

   mux4_1_4b opSel[3:0](.out(OutBS),.inputA(sllOut),.inputB(srlOut),.inputC(rolOut),.inputD(sraOut),.sel(ShiftOper));
   
endmodule
`default_nettype wire
