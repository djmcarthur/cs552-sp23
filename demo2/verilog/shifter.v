/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

    wire  [OPERAND_WIDTH -1:0] rol_out   ;
    wire  [OPERAND_WIDTH -1:0] sll_out   ;
    wire  [OPERAND_WIDTH -1:0] ror_out   ;
    wire  [OPERAND_WIDTH -1:0] srl_out   ;

   rol rol0(.In(In), .ShAmt(ShAmt), .Out(rol_out));
   sll sll1(.In(In), .ShAmt(ShAmt), .Out(sll_out));
   ror ror2(.In(In), .ShAmt(ShAmt), .Out(ror_out));
   srl srl3(.In(In), .ShAmt(ShAmt), .Out(srl_out));

   mux4_1 op_sel[15:0](.out(Out), .inA(rol_out), .inB(sll_out), .inC(ror_out), .inD(srl_out), .s(Oper));
   
endmodule
