/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (read_data1, read_data2, sign_ext_11_16, sign_ext_8_16, sign_ext_5_16, zero_ext_8_16, zero_ext_5_16, pc_inc_out, instr_10_2,
		pc_inc_in, write_data_in, clk, rst);

   // TODO: Your code here
   output wire [15:0] read_data1, read_data2;
   output wire [15:0] sign_ext_11_16;
   output wire [15:0] sign_ext_8_16;
   output wire [15:0] sign_ext_5_16;
   output wire [15:0] zero_ext_8_16;
   output wire [15:0] zero_ext_5_16;
   output wire [15:0] pc_inc_out;
   output wire [15:2] instr_10_2;

   input wire clk, rst;
   input wire [15:0] pc_inc_in;
   input wire [15:0] write_data_in;


   // register file (non-bypassing)
   rf register_file(.read1OutData(read_data1),.read2OutData(read_data2),.err(),.clk(clk),.rst(rst),.read1RegSel(),.read2RegSel(),.writeRegSel(),.writeInData(),.writeEn()); 


   // sign extend modules
   sign_ext_11_16 (.out(),.in());
   sign_ext_8_16(.out(),.in());
   sign_ext_5_16(.out(),.in()); 
   zero_ext_5_16(.out(),.in());
   zero_ext_8_16(.out(),.in());
   
endmodule
`default_nettype wire
