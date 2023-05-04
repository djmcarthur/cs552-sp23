/*
   CS/ECE 552 Spring '22
  
   Filename        : stall_logic.v
   Description     : This is the unit to detect necessary stall scenarios
*/
`default_nettype none
module stall_logic(IF_ID_rt, IF_ID_rs, ID_EX_rd, EX_MEM_rd, ID_EX_stall, EX_MEM_stall, check_rs, check_rt, stall);

   // Registers to compare
   input wire [2:0] IF_ID_rt;
   input wire [2:0] IF_ID_rs;
   input wire [2:0] ID_EX_rd;
   input wire [2:0] EX_MEM_rd;
   input wire ID_EX_stall;
   input wire EX_MEM_stall;

   // Confirm instruction has rs & rt potential
   input wire 	    check_rs, check_rt;

   output wire stall; // 1'b1 when stall is necessary, 1'b0 otherwise

   
   
   assign stall = (check_rs & check_rt) ? ((((ID_EX_rd == IF_ID_rt) & ~ID_EX_stall) | 
					   ((ID_EX_rd == IF_ID_rs) & ~ID_EX_stall) | 
					   ((EX_MEM_rd == IF_ID_rt) & ~EX_MEM_stall) | 
					   ((EX_MEM_rd == IF_ID_rs) & ~EX_MEM_stall)) ? 1'b1 : 1'b0) :
		  check_rs ? ((((ID_EX_rd == IF_ID_rs) & ~ID_EX_stall) |
			       ((EX_MEM_rd == IF_ID_rs) & ~EX_MEM_stall)) ? 1'b1 : 1'b0) :
		  1'b0;
endmodule
`default_nettype wire
