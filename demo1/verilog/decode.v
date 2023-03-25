/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (read_data1, read_data2, se_11_16, se_8_16, se_5_16, ze_8_16, ze_5_16, pc_inc_out,
		pc_inc_in, write_data_in, clk, rst, err, writeEn, instr);

   // TODO: Your code here
   output wire [15:0] read_data1, read_data2;
   output wire [15:0] se_11_16;
   output wire [15:0] se_8_16;
   output wire [15:0] se_5_16;
   output wire [15:0] ze_8_16;
   output wire [15:0] ze_5_16;
   output wire [15:0] pc_inc_out;
   // output wire [15:2] instr_10_2; // Not sure on purpose
   output wire 	      err;

   input wire clk, rst, RegWrite;
   input wire [2:0] writeRegSel;
   input wire [15:0] pc_inc_in;
   input wire [15:0] write_data_in;
   input wire [15:0] instr;

   assign pc_inc_out = pc_inc_in;

   // register file (non-bypassing)
   rf register_file(.read1OutData(read_data1),.read2OutData(read_data2),.err(err),.clk(clk),.rst(rst),.read1RegSel(inst[10:8]),.read2RegSel(instr[7:5]),.writeRegSel(writeRegSel),.writeInData(write_data_in),.writeEn(RegWrite)); 

   // sign extend modules
   sign_ext_11_16 se11_16(.out(se_11_16),.in(instr));
   sign_ext_8_16 se8_16(.out(se_8_16),.in(instr));
   sign_ext_5_16 se5_16(.out(se_5_16),.in(instr)); 
   zero_ext_5_16 ze5_16(.out(ze_5_16),.in(instr));
   zero_ext_8_16 ze8_16(.out(ze_8_16),.in(instr));
   
endmodule
`default_nettype wire
