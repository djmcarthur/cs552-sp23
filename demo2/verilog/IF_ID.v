`default_nettype none
module IF_ID(
    IF_ID_instr,IF_ID_pc_inc,pc_inc, IF_ID_halt, halt,
	     instr, //IF_ID_sel_pc_new, sel_pc_new,
    clk, rst, stall);

    input wire clk, rst, stall, halt;

    // data
    output wire [15:0] IF_ID_instr;
    output wire [15:0]  IF_ID_pc_inc;
    output wire 		IF_ID_halt;
   //output wire		IF_ID_sel_pc_new;

    //data
    input wire [15:0] instr;
    input wire [15:0]  pc_inc;
    //input wire 	       sel_pc_new;
   

    // data
    dff halt_reg(.q(IF_ID_halt), .d(stall ? 1'b0 : halt), .clk(clk), .rst(rst));
    dff inst_reg [15:0](.q(IF_ID_instr), .d(rst ? {5'b00001, 11'd0} : stall ? IF_ID_instr : instr), .clk(clk), .rst(1'b0));
    dff pc_reg [15:0] (.q(IF_ID_pc_inc), .d(stall ? IF_ID_pc_inc : pc_inc), .clk(clk), .rst(1'b0));
    

endmodule
`default_nettype wire
