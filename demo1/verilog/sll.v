
`default_nettype none
module sll(InBS, ShAmt, OutBS);

    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH = 4;

    input wire  [OPERAND_WIDTH -1:0] InBS;
    input wire  [SHAMT_WIDTH -1:0]   ShAmt;
    output wire [OPERAND_WIDTH -1:0] OutBS;

    wire [OPERAND_WIDTH -1:0] sh0;
    wire [OPERAND_WIDTH -1:0] sh1;
    wire [OPERAND_WIDTH -1:0] sh2;

    mux2_1 m0[OPERAND_WIDTH -1:0](.out(sh0),  .inputA(InBS),.inputB({InBS[14:0],1'b0}),.sel(ShAmt[0])); // shift 0
    mux2_1 m1[OPERAND_WIDTH -1:0](.out(sh1),  .inputA(sh0), .inputB({sh0[13:0],2'b0}), .sel(ShAmt[1])); // shift 2
    mux2_1 m2[OPERAND_WIDTH -1:0](.out(sh2),  .inputA(sh1), .inputB({sh1[11:0],4'b0}), .sel(ShAmt[2])); // shift 4
    mux2_1 m3[OPERAND_WIDTH -1:0](.out(OutBS),.inputA(sh2), .inputB({sh2[7:0],8'b0}),  .sel(ShAmt[3])); // shift 8


endmodule
`default_nettype wire
