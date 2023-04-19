/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;
   
   output reg [15:0] DataOut;
   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output reg        err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;

   /* state machine control vars */
   wire [4:0] 	     state;
   reg [4:0] 	     next_state;

   /* state machine signals */

   // going in to mem or cache
   reg 		     enable, comp, write, valid_in;
   reg [3:0] 	     offset;
   reg 		     rd,wr;
   reg [4:0] 	     mem_tag;
   reg [2:0] 	     mem_off;
   reg [15:0] 	     mem_in;

   // coming out out mem or cache
   wire 	     cache_err,mem_err, hit, dirty, valid;
   wire [4:0] 	     tag_out;
   wire [15:0] 	     data_out;
   wire 	     mem_stall;
   wire [3:0] 	     busy;
   wire [15:0] 	     mem_out;
   
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (data_out),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr[15:11]),
                          .index                (Addr[10:3]),
                          .offset               (offset),
                          .data_in              (DataIn),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_out),
                     .stall             (mem_stall),
                     .busy              (busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (data_out),
                     .wr                (wr),
                     .rd                (rd));
   
   // your code here
   assign mem_addr = {mem_tag, Addr[10:3], mem_offset};

   always @(*) begin
      err = mem_err | cache_err;
      enable = 1'b0;
      offset = Addr[2:0];
      comp = 1'b0;
      write = 1'b0;
      valid_in = 1'b0;
      wr = 1'b0;
      rd = 1'b0;
      Done = 1'b0;
      Stall = 1'b0;
      CacheHit = 1'b0;
      err = mem_err | cache_err;
      
   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
