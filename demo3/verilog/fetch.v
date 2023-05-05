/*
   CS/ECE 552 Spring '23
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (instr, pc_inc, next_pc, halt, clk, rst, sel_pc_new, stall, err);

   output wire [15:0] instr;
   output wire [15:0] pc_inc;

   input wire [15:0] next_pc; // branch/jump PC
   input wire halt, clk, rst;

   wire [15:0] instr_addr;
   wire [15:0] nxt_pc; // Into FF
   input wire  sel_pc_new, stall;

   // New signals for Phase 3
   output wire err;
   wire        done;
   wire        stall_fetch_check;
   wire [15:0]  instr_check;
   wire [15:0]	imem_addr;

   wire 	ICacheHit;
   wire 	ICacheRead;
   
   assign ICacheRead = ~rst;
   
   

   assign instr = (~done | (instr_addr !== imem_addr))  ? 16'h0800 : instr_check; // Don't want to send halts

   // Probably more of a mem_system.v problem, but tries to stall one too many cycles
   //assign stall_fetch = stall_fetch_check & ~done ? 1'b1 : 1'b0;

   assign nxt_pc = ((halt & (~rst)) | (stall & ~sel_pc_new) | (~done & ~sel_pc_new) | (done & (instr_addr !== imem_addr))) ? instr_addr : 
		   (sel_pc_new) ? next_pc : pc_inc;

   cla_16b add_pc(.sum(pc_inc), .c_out(), .a(instr_addr), .b(16'd2), .c_in(1'b0));

   // New for Phase 3
   // Inspect connections
   mem_system instr_mem(
   // Outputs
   .DataOut(instr_check), .Done(done), .Stall(stall_fetch_check), .CacheHit(ICacheHit), .err(err), .addr_out(imem_addr),
   // Inputs
   .Addr(instr_addr), .DataIn(16'b0), .Rd(~rst), .Wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));
   
   //memory2c instr_mem(.data_out(instr), 
   //      .data_in(16'b0), .addr(instr_addr), .enable(~rst), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));

   dff pc_reg [15:0] (.q(instr_addr), .d(nxt_pc), .clk(clk), .rst(rst));

endmodule
`default_nettype none
