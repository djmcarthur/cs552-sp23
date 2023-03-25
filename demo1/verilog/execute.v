/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (pc_inc_in, pc_new, alu_res, alu_cond,
		read_data1_in, read_data2_in, se_11_16, se_8_16, se_5_16, ze_5_16, ze_8_16, clk, rst. PCAddSel, PCImmSel, aluSrc);

   // TODO: Your code here
   output wire [15:0] pc_inc_in;
   output wire [15:0] pc_new;
   output wire [15:0] alu_res;
   //output wire [10:2] instr_10_2_out;
   output wire alu_cond;

   input wire clk, rst;
   input wire [15:0] read_data1_in, read_data2_in;
   input wire [15:0] se_11_16;
   input wire [15:0] se_8_16;
   input wire [15:0] se_5_16;
   input wire [15:0] ze_5_16;
   input wire [15:0] ze_8_16;
   input wire 	     PCAddSel;
   input wire 	     PCImmSel;
   input wire [2:0] 	 aluSrc;
 
   //input wire [10:2] instr_10_2_in; // Not sure on purpose

   // Intermediate wires to pass to pc adder
   wire [15:0] 	     pc_add_A;
   wire [15:0] 	     pc_add_B;

   // Intermediate wire for InB of alu
   wire [15:0] 	     InB;

   // Mux to choose inB for alu
   assign InB = aluSrc[2] ?  (aluSrc[0] ? ze_8_16 : ze_5_16) : (aluSrc[1] ? (aluSrc[0] ? se_5_16 : 16'b0) : (aluSrc[0] ? read_data2_in : se_8_16));

   // Muxes and adder for PC
   assign pc_add_A = PCAddSel ? read_data1_in : pc_inc_in;
   assign pc_add_B = PCImmSel ? se_8_16 : se_11_16;
   cla16b pc_add(.sum(pc_new), .cOut(), .inA(pc_add_A), .inB(pc_add_B), .cIn(1'b0), .sub(1'b0));
   
   alu ex_alu(.InA(read_data1_in), .InB(InB), .Cin(1'b0), .Oper(), .invA(1'b0), .invB(1'b0), .sign(1'b0), .Out(alu_res), .Zero(), .Ofl(), .equal(), .lt(), .lte(), .cOut()); 
   
endmodule
`default_nettype wire
