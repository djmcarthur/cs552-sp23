/*
   CS/ECE 552 Spring '22
  
   Filename        : stall_logic.v
   Description     : This is the unit to detect necessary stall scenarios
*/
`default_nettype none
module stall_logic(ID_EX_rt, ID_EX_rs,EX_MEM_rd, MEM_WB_rd, check_rs, check_rt, stall);

   // Registers to compare
   input wire [2:0] ID_EX_rt;
   input wire [2:0] ID_EX_rs;
   input wire [2:0] EX_MEM_rd;
   input wire [2:0] MEM_WB_rd;

   // Confirm instruction has rs & rt potential
   input wire 	    check_rs, check_rt;

   output wire stall; // 1'b1 when stall is necessary, 1'b0 otherwise

   
   
   assign stall = (check_rs & check_rt) ? (((EX_MEM_rd == ID_EX_rt) | 
					   (EX_MEM_rd == ID_EX_rs) | 
					   (MEM_WB_rd == ID_EX_rt) | 
					   (MEM_WB_rd == ID_EX_rs)) ? 1'b1 : 1'b0) :
		  check_rs ? (((EX_MEM_rd == ID_EX_rs) |
			       (MEM_WB_rd == ID_EX_rs)) ? 1'b1 : 1'b0) :
		  1'b0;
endmodule
`default_nettype wire
