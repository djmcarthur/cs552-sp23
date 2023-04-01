/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (ex_res, alu_cond_out, data1, data2, invA, invB, Cin, Oper, alu_sel_b, swap, alu_cond_sel, zero_ext_5_16, 
sign_ext_8_16, sign_ext_5_16, sign, clk, rst);

   output wire [15:0] ex_res;
   output wire alu_cond_out;

   input wire [15:0] data1, data2, sign_ext_8_16, sign_ext_5_16, zero_ext_5_16;
   input wire clk, rst, invA, invB, sign, Cin;
   input wire [2:0] alu_sel_b;
   input wire swap;
   input wire [3:0] Oper, alu_cond_sel;

   wire [15:0] b_mux;
   wire [15:0] InA, InB;
   wire Cout, gt, gte, lt, lte, Ofl, Zero, equals;


   assign alu_cond_out = (
            (alu_cond_sel == 4'd0) ? 1'b1     :
	   		(alu_cond_sel == 4'd1) ? lt       : 
	   		(alu_cond_sel == 4'd2) ? lte      : 
	   		(alu_cond_sel == 4'd3) ? gte      : 
	   		(alu_cond_sel == 4'd4) ? equals   : 
	   		(alu_cond_sel == 4'd5) ? ~equals  : 
	   		(alu_cond_sel == 4'd6) ? Zero     : 
	   		(alu_cond_sel == 4'd7) ? Cout     : 
			      1'b0);

   assign InA = swap ? b_mux : data1;
   assign InB = swap ? data1 : b_mux;

   assign b_mux = (
      (alu_sel_b == 3'b000) ? 16'h0000      :
	   (alu_sel_b == 3'b001) ? data2         :
	   (alu_sel_b == 3'b010) ? sign_ext_8_16 :
	   (alu_sel_b == 3'b011) ? sign_ext_5_16 :
	   zero_ext_5_16);



   alu ex_alu(.InA(InA), .InB(InB), .Cin(Cin), .Cout(Cout), .Oper(Oper), .invA(invA), .invB(invB), .equals(equals), 
            .gt(gt), .gte(gte), .lt(lt), .lte(lte), .sign(sign), .Out(ex_res), .Zero(Zero), .Ofl(Ofl));

            // sub_out, slbi_out, btr_out, sco_out, slt_out, lbi_out, sle_out, seq_out;

            //InA, InB, Cin, Cout, Oper, invA, invB, equals, gt, gte, lt, lte, sign, Out, Zero, Ofl)
endmodule
`default_nettype wire