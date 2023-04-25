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


  localparam IDLE	= 4'h0;
  localparam COMPR	= 4'h1;
  localparam COMPW	= 4'h2;
  // Read new block from MEMORY
  localparam ALLOC0	= 4'h3;
  localparam ALLOC1	= 4'h4;
  localparam ALLOC2 	= 4'h5;
  localparam ALLOC3	= 4'h6;
  localparam ALLOC4	= 4'h7;
  localparam ALLOC5	= 4'h8;
  localparam ALLOC6 	= 4'h9;
  localparam ALLOC7	= 4'hA;
  // way 0 writeback
  localparam WB0	= 4'hB;
  localparam WB1	= 4'hC;
  localparam WB2	= 4'hD;
  localparam WB3	= 4'hE;


  // victimway algorithm params
  wire victim_out;
  reg victim_in;

  // define flip flops
  dff state_ff[4:0](.q(state),.d(next_state),.clk(clk),.rst(rst));
  dff victimway(.q(victim_out),.d(victim_in),.clk(clk),.rst(rst));

  always @(*) begin
	victim_out = 1'b0;
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
			enable = 1'b1;
			comp = 1'b1;
			write = 1'b0;
			// hit if either way's hit output goes high (defined
			// above in assign)
			CacheHit = (hit) ? 1'b1 : 1'b0;
			// on each read of the cache, invert the state of
			// victimway
			victim_out = ~victim_in;
		end
		COMPW: begin
			enable = 1'b1;
			comp = 1'b1;
			write = 1'b0;
			// hit if either way's hit output goes high
			CacheHit = (hit) ? 1'b1 : 1'b0;
			// on each write of the cache, invert the state of
			// victimway
			victim_out = ~victim_in;
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
		ALLOC6: begin
		end
		ALLOC7: begin
		end
		WB0: begin
		end
		WB1: begin
		end
		WB2: begin
		end
		WB3: begin
		end
	endcase

  end 
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
