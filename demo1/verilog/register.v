/*
 * This module describes a 16 bit register.
 */

`default_nettype none
module register(readDat, writeDat, writeEn, clk, rst);

   input wire [15:0] writeDat;
   input wire writeEn, clk, rst;
   output wire [15:0] readDat;

   wire [15:0] dffIn;

   assign dffIn = (writeEn) ? (writeDat) : (readDat);

   dff flop0(.q(readDat[0]), .d(dffIn[0]), .clk(clk),.rst(rst)); 
   dff flop1(.q(readDat[1]), .d(dffIn[1]), .clk(clk),.rst(rst));
   dff flop2(.q(readDat[2]), .d(dffIn[2]), .clk(clk),.rst(rst));
   dff flop3(.q(readDat[3]), .d(dffIn[3]), .clk(clk),.rst(rst));
   dff flop4(.q(readDat[4]), .d(dffIn[4]), .clk(clk),.rst(rst));
   dff flop5(.q(readDat[5]), .d(dffIn[5]), .clk(clk),.rst(rst));
   dff flop6(.q(readDat[6]), .d(dffIn[6]), .clk(clk),.rst(rst));
   dff flop7(.q(readDat[7]), .d(dffIn[7]), .clk(clk),.rst(rst));
   dff flop8(.q(readDat[8]), .d(dffIn[8]), .clk(clk),.rst(rst));
   dff flop9(.q(readDat[9]), .d(dffIn[9]), .clk(clk),.rst(rst));
   dff flopA(.q(readDat[10]),.d(dffIn[10]),.clk(clk),.rst(rst));
   dff flopB(.q(readDat[11]),.d(dffIn[11]),.clk(clk),.rst(rst));
   dff flopC(.q(readDat[12]),.d(dffIn[12]),.clk(clk),.rst(rst));
   dff flopD(.q(readDat[13]),.d(dffIn[13]),.clk(clk),.rst(rst));
   dff flopE(.q(readDat[14]),.d(dffIn[14]),.clk(clk),.rst(rst));
   dff flopF(.q(readDat[15]),.d(dffIn[15]),.clk(clk),.rst(rst));

   

endmodule
`default_nettype wire
