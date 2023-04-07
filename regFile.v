/*
   CS/ECE 552, Spring '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   parameter N = 16;

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [N-1:0] writeData;
   input        writeEn;

   output [N-1:0] read1Data;
   output [N-1:0] read2Data;
   output        err;

   wire [7:0] write_en;
   wire [N-1:0] reg_out[7:0];

   // check write enable
   assign write_en[0] = (writeRegSel == 0) & writeEn;
   assign write_en[1] = (writeRegSel == 1) & writeEn;
   assign write_en[2] = (writeRegSel == 2) & writeEn;
   assign write_en[3] = (writeRegSel == 3) & writeEn;
   assign write_en[4] = (writeRegSel == 4) & writeEn;
   assign write_en[5] = (writeRegSel == 5) & writeEn;
   assign write_en[6] = (writeRegSel == 6) & writeEn;
   assign write_en[7] = (writeRegSel == 7) & writeEn;

   // declare 8 registers
   register reg1(.read_data(reg_out[0]), .write_data(writeData), .write_en(write_en[0]), .clk(clk), .rst(rst));
   register reg2(.read_data(reg_out[1]), .write_data(writeData), .write_en(write_en[1]), .clk(clk), .rst(rst));
   register reg3(.read_data(reg_out[2]), .write_data(writeData), .write_en(write_en[2]), .clk(clk), .rst(rst));
   register reg4(.read_data(reg_out[3]), .write_data(writeData), .write_en(write_en[3]), .clk(clk), .rst(rst));
   register reg5(.read_data(reg_out[4]), .write_data(writeData), .write_en(write_en[4]), .clk(clk), .rst(rst));
   register reg6(.read_data(reg_out[5]), .write_data(writeData), .write_en(write_en[5]), .clk(clk), .rst(rst));
   register reg7(.read_data(reg_out[6]), .write_data(writeData), .write_en(write_en[6]), .clk(clk), .rst(rst));
   register reg8(.read_data(reg_out[7]), .write_data(writeData), .write_en(write_en[7]), .clk(clk), .rst(rst));

   // register file characteristic: select specified register
   assign read1Data = 
            (read1RegSel == 0) ? reg_out[0] :
		      (read1RegSel == 1) ? reg_out[1] :
		      (read1RegSel == 2) ? reg_out[2] :
		      (read1RegSel == 3) ? reg_out[3] :
		      (read1RegSel == 4) ? reg_out[4] :
	   	   (read1RegSel == 5) ? reg_out[5] :
		      (read1RegSel == 6) ? reg_out[6] :
		       reg_out[7];

   assign read2Data = 
            (read2RegSel == 0) ? reg_out[0] :
		      (read2RegSel == 1) ? reg_out[1] :
		      (read2RegSel == 2) ? reg_out[2] :
      	  	(read2RegSel == 3) ? reg_out[3] :
		      (read2RegSel == 4) ? reg_out[4] :
		      (read2RegSel == 5) ? reg_out[5] :
	         (read2RegSel == 6) ? reg_out[6] :
		       reg_out[7];
             
assign err = ((^writeData === 1'bX) | (writeEn === 1'bX));

endmodule
