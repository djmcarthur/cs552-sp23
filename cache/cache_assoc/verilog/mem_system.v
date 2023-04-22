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

   wire [3:0] state;
   reg [3:0] next_state;

   reg		enable, comp, write, valid_in, rd, wr;
   reg [15:0]	cache_data_in, mem_in;
   reg [2:0]	offset, mem_off;
   reg [4:0]	mem_tag;
   wire [15:0]  mem_addr;

   wire 	cache_err, mem_err, hit, dirty, valid, mem_stall;
   // need to differentiate way outputs
   wire 	hitW0, hitW1, dirtyW0, dirtyW1, validW0, validW1, errW0, errW1;
   wire [15:0] 	data_out, data_outW0, data_outW1, mem_out;
   wire [4:0]   tag_out, tag_outW0, tag_outW1;
   wire [3:0]   busy;


   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_outW0),
                          .data_out             (data_outW0),
                          .hit                  (hitW0),
                          .dirty                (dirtyW0),
                          .valid                (validW0),
                          .err                  (errW0),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (1'b1));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_outW1),
                          .data_out             (data_outW1),
                          .hit                  (hitW1),
                          .dirty                (dirtyW1),
                          .valid                (validW1),
                          .err                  (errW1),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (1'b1));

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

  assign cache_err = errW0 | errW1;
  assign hit = (hitW0 & validW0) | (hitW1 & validW1);

  assign cache_sel = (hitW0 & validW0) ? 1 : (hitW1 & validW1) ? 0 : victim_out;

  assign tag_out = cache_sel ? tag_outW1 : tag_outW0;
  assign valid = cache_sel ? validW1 : validW0;
  assign dirty = cache_sel ? dirtyW1 : dirtyW0;

  assign DataOut = cache_sel ? data_outW1 : data_outW0;


  localparam IDLE	= 4'd0;
  localparam COMPR	= 4'd1;
  localparam COMPW	= 4'd2;
  // Read new block from MEMORY
  localparam ALLOC0	= 4'd3;
  localparam ALLOC1	= 4'd4;
  localparam ALLOC2 	= 4'd5;
  localparam ALLOC3	= 4'd6;
  localparam ALLOC4	= 4'd7;
  localparam ALLOC5	= 4'd8;
  // way 0 writeback
  localparam WB0_0	= 4'd9;
  localparam WB1_0	= 4'd10;
  localparam WB2_0	= 4'd11;
  localparam WB3_0	= 4'd12;
  // way 1 writeback
  localparam WB0_1	= 4'd13;
  localparam WB1_1	= 4'd14;
  localparam WB2_1	= 4'd15;
  localparam WB3_1 	= 4'd16;


  dff state_ff[4:0](.q(state),.d(next_state),.clk(clk),.rst(rst));

  always @(*) begin
	Done = 1'b0;
	Stall = 1'b1;
	write = 1'b0;
	rd = 1'b0;
	wr = 1'b0;
	enable = 1'b0;
	comp = 1'b0;
	CacheHit = 1'b0;

	offset = Addr[2:0];

	

	case(state)
		IDLE: begin
			enable = (Wr | Rd) ? 1'b1 : 1'b0;
			next_state = Wr ? COMPW :
				     Rd ? COMPR :
				     IDLE;
			comp = (Wr | Rd) ? 1'b1 : 1'b0;
			offset = Addr[2:0];
			write = (Wr) ? 1'b1 : 1'b0;
			Stall = 1'b0;
		end
		COMPR: begin
			comp = 1'b1;
		end
		COMPW: begin
			comp = 1'b1;
		end
		ALLOC0: begin
		end
		ALLOC1: begin
		end
		ALLOC2: begin
		end
		ALLOC3: begin
		end
		ALLOC4: begin
		end
		ALLOC5: begin
		end
		WB0_0: begin
		end
		WB1_0: begin
		end
		WB2_0: begin
		end
		WB3_0: begin
		end
		WB0_1: begin
		end
		WB1_1: begin
		end
		WB2_1: begin
		end
		WB3_1: begin
		end
	endcase

  end 
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
