/*
   CS/ECE 552, Spring '23
   Homework #3, Problem #1
  
   This module creates a 16-bit register file.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
`default_nettype none
module rf (
           // Outputs
           read1OutData, read2OutData, err,
           // Inputs
           clk, rst, read1RegSel, read2RegSel, writeRegSel, writeInData, writeEn
           );
   parameter N = 16;

   input wire       clk, rst;
   input wire [2:0] read1RegSel;
   input wire [2:0] read2RegSel;
   input wire [2:0] writeRegSel;
   input wire [N-1:0] writeInData;
   input wire        writeEn;

   output wire [N-1:0] read1OutData;
   output wire [N-1:0] read2OutData;
   output wire        err;
   
   wire [7:0]   regWriteEn;
   wire [N-1:0] regDatOut[7:0];

   // write enable signals
   assign regWriteEn[0] = (writeRegSel == 0) & (writeEn);
   assign regWriteEn[1] = (writeRegSel == 1) & (writeEn);
   assign regWriteEn[2] = (writeRegSel == 2) & (writeEn);
   assign regWriteEn[3] = (writeRegSel == 3) & (writeEn);
   assign regWriteEn[4] = (writeRegSel == 4) & (writeEn);
   assign regWriteEn[5] = (writeRegSel == 5) & (writeEn);
   assign regWriteEn[6] = (writeRegSel == 6) & (writeEn);
   assign regWriteEn[7] = (writeRegSel == 7) & (writeEn);


   // declare 8 16-bit registers
   
   register r0(.readDat(regDatOut[0]),.writeDat(writeInData),.writeEn(regWriteEn[0]),.clk(clk),.rst(rst));
   register r1(.readDat(regDatOut[1]),.writeDat(writeInData),.writeEn(regWriteEn[1]),.clk(clk),.rst(rst));
   register r2(.readDat(regDatOut[2]),.writeDat(writeInData),.writeEn(regWriteEn[2]),.clk(clk),.rst(rst));
   register r3(.readDat(regDatOut[3]),.writeDat(writeInData),.writeEn(regWriteEn[3]),.clk(clk),.rst(rst));
   register r4(.readDat(regDatOut[4]),.writeDat(writeInData),.writeEn(regWriteEn[4]),.clk(clk),.rst(rst));
   register r5(.readDat(regDatOut[5]),.writeDat(writeInData),.writeEn(regWriteEn[5]),.clk(clk),.rst(rst));
   register r6(.readDat(regDatOut[6]),.writeDat(writeInData),.writeEn(regWriteEn[6]),.clk(clk),.rst(rst));
   register r7(.readDat(regDatOut[7]),.writeDat(writeInData),.writeEn(regWriteEn[7]),.clk(clk),.rst(rst));

   // which reg are we interested in?
   assign read1OutData = (read1RegSel == 0) ? regDatOut[0] :
                         (read1RegSel == 1) ? regDatOut[1] :
		 	 (read1RegSel == 2) ? regDatOut[2] :
			 (read1RegSel == 3) ? regDatOut[3] :
			 (read1RegSel == 4) ? regDatOut[4] :
			 (read1RegSel == 5) ? regDatOut[5] :
			 (read1RegSel == 6) ? regDatOut[6] :
			 regDatOut[7];

   assign read2OutData = (read2RegSel == 0) ? regDatOut[0] :
                         (read2RegSel == 1) ? regDatOut[1] :
		 	 (read2RegSel == 2) ? regDatOut[2] :
			 (read2RegSel == 3) ? regDatOut[3] :
			 (read2RegSel == 4) ? regDatOut[4] :
			 (read2RegSel == 5) ? regDatOut[5] :
			 (read2RegSel == 6) ? regDatOut[6] :
			 regDatOut[7];


   assign err = ((^writeInData === 1'bX) | (writeEn === 1'bX));

endmodule
`default_nettype wire
