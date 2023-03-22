/*
    CS/ECE 552 Spring '23
    Homework #2, Problem 2

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
`default_nettype none
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

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

    /* YOUR CODE HERE */
    wire [OPERAND_WIDTH -1:0] inAOp;
    wire [OPERAND_WIDTH -1:0] inBOp;
    wire [OPERAND_WIDTH -1:0] opRes;
    wire [OPERAND_WIDTH -1:0] shiftOut;
    wire [OPERAND_WIDTH -1:0] addOut;
    wire [OPERAND_WIDTH -1:0] andOut;
    wire [OPERAND_WIDTH -1:0] orOut;
    wire [OPERAND_WIDTH -1:0] xorOut;
    wire of;
    wire cOut;

    assign Zero = ~(|Out);

    // overflow logic
    assign of = (Oper != 3'b100) ? (1'b0) : ((sign) ? ((opRes[15] & ~inAOp[15] & ~inBOp[15])
    		| (~opRes[15] & inAOp[15] & inBOp[15])) : cOut);

    assign Ofl = (Oper[2]) ? (of) : (1'b0);

    // define our AND, OR, XOR logic outs
    assign andOut = inAOp & inBOp;
    assign orOut  = inAOp | inBOp;
    assign xorOut = inAOp ^ inBOp;

    // USE THESE VALUES for A and B
    assign inAOp = (invA) ? (~InA) : (InA);
    assign inBOp = (invB) ? (~InB) : (InB);

    // instantiate a shifter
    shifter aluShifter(.InBS(inAOp),.ShAmt(inBOp[3:0]),.ShiftOper(Oper[1:0]),.OutBS(shiftOut));

    // ADD
    cla16b aluAdder(.sum(addOut),.cOut(cOut),.inA(inAOp),.inB(inBOp),.cIn(Cin));

    // All operations are done in parallel -- here we select which one we are
    // interested in.
    mux4_1_4b aluOpMux[3:0](.out(opRes),.inputA(addOut),.inputB(andOut),.inputC(orOut),.inputD(xorOut),.sel(Oper[1:0]));

    // one more mux... 
    mux2_1 aluOutMux[15:0](.out(Out),.inputA(shiftOut),.inputB(opRes),.sel(Oper[2]));
    
endmodule
`default_nettype wire
