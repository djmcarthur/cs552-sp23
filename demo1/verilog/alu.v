/*
    CS/ECE 552 Spring '23
    ALU for project

   
*/
`default_nettype none
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl, equal, lt, lte, cOut);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input wire  [OPERAND_WIDTH -1:0] InA ; // Input wire operand A
    input wire  [OPERAND_WIDTH -1:0] InB ; // Input wire operand B
    input wire                       Cin ; // Carry in
    input wire  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input wire                       invA; // Signal to invert A
    input wire                       invB; // Signal to invert B
    input wire                       sign; // Signal for signed operation
    output wire [OPERAND_WIDTH -1:0] Out ; // Result of comput wireation
    output wire                      Ofl ; // Signal if overflow occured
    output wire                      Zero; // Signal if Out is 0
    output wire 			     equal, lt, lte;
   

    /* YOUR CODE HERE */
    // Wires for inverted version of signals
    wire [OPERAND_WIDTH -1:0] nInA;
    wire [OPERAND_WIDTH -1:0] nInB;

    // Wires for operands being used (Either A and B or inversions)
    wire [OPERAND_WIDTH -1:0] opA;
    wire [OPERAND_WIDTH -1:0] opB;

    // Intermediate wires to hold results of all different operations
    wire [OPERAND_WIDTH -1:0] 	     sl_result;
    wire [OPERAND_WIDTH -1:0] 	     srl_result;
    wire [OPERAND_WIDTH -1:0] 	     rl_result;
    wire [OPERAND_WIDTH -1:0] 	     rr_result;
    wire [OPERAND_WIDTH -1:0] 	     add_result;
    wire [OPERAND_WIDTH -1:0] 	     sub_result; 
    wire [OPERAND_WIDTH -1:0] 	     xor_result; 
    wire [OPERAND_WIDTH -1:0] 	     andn_result;
    output wire 			     cOut;
    wire 				     cOut_sub; 				     
   
    // Inversion operations (NOT gates in hardware)
    assign nInA = ~InA;
    assign nInB = ~InB;

    // 2:1 MUXes to select between inverted and noninverted operands
    assign opA = invA ? nInA : InA;
    assign opB = invB ? nInB : InB;
  
    // Istantiate sub-modules to do different shift operations
    sl sl0(.OutBS(sl_result), .ShAmt(opB[3:0]), .InBS(opA));
    srl srl0(.OutBS(srl_result), .ShAmt(opB[3:0]), .InBS(opA));
    rl rl0(.OutBS(rl_result), .ShAmt(opB[3:0]), .InBS(opA));
    rr rr0(.OutBS(rr_result), .ShAmt(opB[3:0]), .InBS(opA));
    cla16b cla_add(.sum(add_result), .cOut(cOut), .inA(opB), .inB(opA), .cIn(Cin), .sub(1'b0)); // opA and opB flipped since sub and subi subtract Rs
    cla16b cla_sub(.sum(sub_result), .cOut(cOut_sub), .inA(opB), .inB(opA), .cIn(Cin), .sub(1'b1)); // opA and opB flipped since sub and subi subtract Rs

    // AND operation (16 AND gates in hardware)
    assign andn_result = opA & ~opB;

    // XOR operation (16 XOR gates in hardware)
    assign xor_result = opA ^ opB;

    // Assign output based on Oper
    // Would be 8:1 Mux in hardware
    assign Out = Oper[2] ? (Oper[1] ? (Oper[0] ? andn_result : xor_result) : (Oper[0] ? sub_result : add_result)) : (Oper[1] ? (Oper[0] ? rr_result : rl_result) : (Oper[0] ? srl_result : sl_result));

    // Assign Ofl
    assign Ofl = sign ? ((~opA[15] & ~ opB[15] & add_result[15]) | (opA[15] & opB[15] & ~add_result[15])) : cOut;

    // Nor reduction to set Zero if Out = 16'b0
    assign Zero = ~|Out;

    // set equal flag
    assign equal = (InA == InB) ? 1'b1 : 1'b0;

    // assign lt flag
    assign lt = sub_result[15] ? 1'b0 : 1'b1;

    // assign lt flag
    assign lte = lt | equal;
   
endmodule
`default_nettype wire
