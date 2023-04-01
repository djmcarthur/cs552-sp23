/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 2

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
    (.InA(InA), .InB(InB), .Cin(Cin), .Cout(Cout), .Oper(Oper), .invA(invA), .invB(invB), .equals(equals), 
            .gt(gt), .gte(gte), .lt(lt), .lte(lte), .sign(sign), .Out(ex_res), .Zero(Zero), .Ofl(Ofl));
*/
`default_nettype none
module alu (InA, InB, Cin, Cout, Oper, invA, invB, equals, gt, gte, lt, lte, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 4;
       
    input wire  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input wire  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input wire                       Cin ; // Carry in
    input wire  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input wire                       invA; // Signal to invert A
    input wire                       invB; // Signal to invert B
    input wire                       sign; // Signal for signed operation
    output wire [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output wire                      Ofl ; // Signal if overflow occured
    output wire                     Zero; // Signal if Out is 0
    output wire gt, gte, lt, lte, equals, Cout;


    wire  [OPERAND_WIDTH -1:0] shift_out ;
    wire  [OPERAND_WIDTH -1:0] and_out ;
    wire  [OPERAND_WIDTH -1:0] add_out ;
    wire  [OPERAND_WIDTH -1:0] or_out ;
    wire  [OPERAND_WIDTH -1:0] xor_out ;
    wire  [OPERAND_WIDTH -1:0] op_out ;
    wire  [OPERAND_WIDTH -1:0] inA_op ;
    wire  [OPERAND_WIDTH -1:0] inB_op ;
    wire  overflow;
    wire  c_out;
    wire [15:0] sub_out, slbi_out, btr_out, sco_out, slt_out, lbi_out, sle_out, seq_out;

    shifter shift_ops(.In(inA_op), .ShAmt(inB_op[3:0]), .Oper(Oper[1:0]), .Out(shift_out));

    mux2_1 inv_A[15:0](.out(inA_op), .inA(InA), .inB(~InA), .s(invA));
    mux2_1 inv_B[15:0](.out(inB_op), .inA(InB), .inB(~InB), .s(invB));

    cla_16b adder(.sum(add_out), .c_out(c_out), .a(inA_op), .b(inB_op), .c_in(Cin));

    assign and_out = inA_op & inB_op;
    assign or_out  = inA_op | inB_op;
    assign xor_out = inA_op ^ inB_op;

    assign Zero = ~(|Out);

    mux4_1 alu_op_mux[15:0](.out(op_out), .inA(add_out), .inB(and_out), .inC(or_out), .inD(xor_out), .s(Oper[1:0]));

    //assign overflow = (Oper != 4'b0100) ? (1'b0) : ((sign) ? ((op_out[15] & ~inA_op[15] & ~inB_op[15]) 
     //                   | (~op_out[15] & inA_op[15] & inB_op[15])) : c_out);
     assign overflow = (sign) ? (add_out[15]^inA_op[15]^inB_op[15]^c_out) : c_out;

    mux2_1 overflow_mux(.out(Ofl), .inA(1'b0), .inB(overflow), .s(Oper[2]));

    assign Out = 
        (Oper == 4'd0) ? shift_out  : 
	    (Oper == 4'd1) ? shift_out  :
		(Oper == 4'd2) ? shift_out  :
		(Oper == 4'd3) ? shift_out  :
		(Oper == 4'd4) ? add_out    :
		(Oper == 4'd5) ? and_out    :
		(Oper == 4'd6) ? or_out     :
		(Oper == 4'd7) ? xor_out    :
		(Oper == 4'd8) ? sco_out    :
		(Oper == 4'd9) ? slbi_out   :
		(Oper == 4'd10) ? btr_out   :
		(Oper == 4'd11) ? slt_out   :
		(Oper == 4'd12) ? lbi_out   :
		(Oper == 4'd13) ? sle_out   :
		(Oper == 4'd14) ? seq_out   :
		(Oper == 4'd15) ? sub_out   :
		InA;

       // sub_out, slbi_out, btr_out, sco_out, slt_out, lbi_out, sle_out, seq_out


    assign sub_out = add_out;

    //SLBI
    assign slbi_out = {inA_op[7:0], 8'h00} | {8'h00, inB_op[7:0]};

    //BTR
    assign btr_out = {inA_op[0], inA_op[1], inA_op[2], inA_op[3], inA_op[4], inA_op[5], inA_op[6], inA_op[7], inA_op[8], inA_op[9],
     inA_op[10], inA_op[11], inA_op[12], inA_op[13], inA_op[14], inA_op[15]};
    
    //SCO((add_out != 16'h0000) & (add_out[15] == ~overflow)) ? 1'b1 : 1'b0;
    assign sco_out = (c_out) ? 16'h0001 : 16'h0000;

    // Condition codes
    //assign lt = {~inA_op[15], inA_op[14:0]} < {~inB_op[15], inB_op[14:0]}; //CHANGE WONT PASS VCHECK
    assign lt = {~inA_op[15], inA_op[14:0]} < {~inB_op[15], inB_op[14:0]};
    //((add_out != 16'h0000) & (add_out[15] == ~overflow)) ? 1'b1 : 1'b0;

    assign equals = inA_op == inB_op;

    assign lte = lt | equals;

    //assign gt = {~inA_op[15], inA_op[14:0]} > {~inB_op[15], inB_op[14:0]}; //CHANGE WONT PASS VCHECK
    assign gt = ((add_out != 16'h0000) & (add_out[15] == 1'b0)) ? 1'b1 : 1'b0;

    assign gte = gt | equals;

    //SLT
    assign slt_out = lt ? 16'h0001 : 16'h0000;

    //LBI
    assign lbi_out = inB_op;

    //SLE
    assign sle_out = lte ? 16'h0001 : 16'h0000;

    //SEQ
    assign seq_out = equals ? 16'h0001 : 16'h0000;
    
endmodule
`default_nettype wire