`default_nettype none
module IF_ID(
    IF_ID_instr,IF_ID_pc_inc,pc_inc,
	     instr, //IF_ID_sel_pc_new, sel_pc_new,
    clk, rst);

    input wire clk, rst;

    // data
    output wire [15:0] IF_ID_instr;
    output wire [15:0]  IF_ID_pc_inc;
   //output wire		IF_ID_sel_pc_new;

    //data
    input wire [15:0] instr;
    input wire [15:0]  pc_inc;
    //input wire 	       sel_pc_new;
   

  // wire 	       rst_buffered;
  // wire 	       reset_buf;
   
   

   //dff rst_buf (.q(rst_buffered), .d(rst), .clk(clk), .rst(rst));
   //assign reset_buf = (IF_ID_instr[15:11] == 5'b00000) ? 0 : rst;
   

    // data
    dff inst_reg [15:0] (.q(IF_ID_instr), .d(rst ? {5'b00001, 11'd0} : instr), .clk(clk), .rst(1'b0));
    dff pc_reg [15:0] (.q(IF_ID_pc_inc), .d(pc_inc), .clk(clk), .rst(1'b0));
    

endmodule
`default_nettype wire
