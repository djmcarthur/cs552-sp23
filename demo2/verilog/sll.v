module sll(In, ShAmt, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

    wire [OPERAND_WIDTH-1:0] shift_0;
    wire [OPERAND_WIDTH-1:0] shift_1;
    wire [OPERAND_WIDTH-1:0] shift_2;

    mux2_1 mux0[15:0](.out(shift_0), .inA(In),      .inB({In[14:0], 1'b0}),      .s(ShAmt[0])); // shift by 0
    mux2_1 mux1[15:0](.out(shift_1), .inA(shift_0), .inB({shift_0[13:0], 2'b0}), .s(ShAmt[1])); // shift by 2
    mux2_1 mux2[15:0](.out(shift_2), .inA(shift_1), .inB({shift_1[11:0], 4'b0}), .s(ShAmt[2])); // shift by 4
    mux2_1 mux3[15:0](.out(Out),     .inA(shift_2), .inB({shift_2[7:0],  8'b0}), .s(ShAmt[3])); // shift by 8

endmodule