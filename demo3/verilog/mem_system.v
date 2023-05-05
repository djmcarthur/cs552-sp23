/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst, addr_out
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

   // wires for addr contorl
   output wire [15:0] addr_out;
   reg [15:0] 	     addr_in;
 

   // ADDR flop
   dff addr_ff[15:0](.q(addr_out), .d(addr_in), .clk(clk), .rst(rst));
   


   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   
   /* state machine control vars */
   wire [3:0] state;
   reg [3:0] next_state;

   /* CACHE0 INPUTS */
   reg 	     enable0, comp0, write0;
   
   /* CACHE0 OUPUTS */
   wire      cache_err0, dirty0, hit0, valid0;
   wire [4:0] tag_out0;
   wire [15:0] cache_data_out0;

   /* CACHE1 INPUTS */
   reg 	     enable1, comp1, write1;

   /* CACHE1 OUTPUTS */
   wire      cache_err1, dirty1, hit1, valid1;
   wire [4:0] tag_out1;
   wire [15:0] cache_data_out1;
   
   /* UNIVERSAL CACHE INPUTS */
   reg [15:0] cache_data_in;
   reg [2:0]  cache_offset;
   reg 	      valid_in;
   reg 	      cache_sel;
   
   /* MEMORY INPUTS */
   reg [15:0] mem_in;
   wire [15:0] mem_addr;
   reg        wr, rd;
   reg [2:0]   mem_off;
   reg [4:0]   mem_tag;

   /* MEMORY OUTPUTS */
   wire [3:0] busy;
   wire [15:0] mem_out;
   wire        mem_err;
   wire        mem_stall;


   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out0),
                          .data_out             (cache_data_out0),
                          .hit                  (hit0),
                          .dirty                (dirty0),
                          .valid                (valid0),
                          .err                  (cache_err0),
                          // Inputs
                          .enable               (enable0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (addr_out[15:11]),
                          .index                (addr_out[10:3]),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp0),
                          .write                (write0),
                          .valid_in             (valid_in));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (cache_data_out1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (cache_err1),
                          // Inputs
                          .enable               (enable1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (addr_out[15:11]),
                          .index                (addr_out[10:3]),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp1),
                          .write                (write1),
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
                     .data_in           (mem_in),
                     .wr                (wr),
                     .rd                (rd));
   
   // your code here

   assign mem_addr = {mem_tag, addr_out[10:3], mem_off}; // Change tag and off in states
   
 /*   assign hit = (hitW0 & validW0) | (hitW1 & validW1);

   assign cache_sel = (hitW0 & validW0) ? 1 : (hitW1 & validW1) ? 0 : victim_out;

   assign tag_out = cache_sel ? tag_outW1 : tag_outW0;
   assign valid = cache_sel ? validW1 : validW0;
   assign dirty = cache_sel ? dirtyW1 : dirtyW0;

   assign DataOut = cache_sel ? data_outW1 : data_outW0;*/


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
  // Writeback *victim* to MEMORY
  localparam WB0	= 4'hB;
  localparam WB1	= 4'hC;
  localparam WB2	= 4'hD;
  localparam WB3	= 4'hE;


  // victimway algorithm params
  wire victim_out;
  reg victim_in;


  // define flip flops
  dff state_ff[3:0](.q(state),.d(next_state),.clk(clk),.rst(rst));

  // victimway flop
  dff victimway(.q(victim_out),.d(victim_in),.clk(clk),.rst(rst));

  always @(*) begin
        DataOut = cache_sel ? cache_data_out1 : cache_data_out0;     
	victim_in = victim_out; // Want to invert in almost all cases
        mem_tag = addr_out[15:11];
        mem_off = 3'b000;
        err = mem_err | cache_err1 | cache_err0;
  	Done = 1'b0;
	Stall = 1'b1;
	write0 = 1'b0;
        write1 = 1'b0;
        valid_in = 1'b0;
	rd = 1'b0;
	wr = 1'b0;
	enable0 = 1'b0;
        enable1 = 1'b0;
	comp0 = 1'b0;
        comp1 = 1'b0;
	CacheHit = 1'b0;
	cache_offset = addr_out[2:0];
        cache_data_in = DataIn;
        mem_in = cache_sel ? cache_data_out1 : cache_data_out0;
        addr_in = addr_out;

	case(state)
		IDLE: begin
		        addr_in = Addr;
           		cache_sel = 1'b0;
         		enable0 = 1'b0;
		        enable1 = 1'b0;
			next_state = Wr ? COMPW :
				     Rd ? COMPR :
				     IDLE;
			cache_offset = Addr[2:0];
			Stall = 1'b0;
		        victim_in = (Wr | Rd) ? ~victim_out : victim_out;
		end
		COMPR: begin
       		        enable0 = 1'b1;
		        enable1 = 1'b1;
		        // Cache controls
			comp0 = 1'b1;
    		        comp1 = 1'b1;
			write0 = 1'b0;
		        write1 = 1'b0;
		   
		        // Controls needed if a hit & valid
			CacheHit = ((hit1 & valid1) | (hit0 & valid0)) ? 1'b1 : 1'b0;
		        Done = ((hit1 & valid1) | (hit0 & valid0)) ? 1'b1 : 1'b0;
		        DataOut = (hit1 & valid1) ? cache_data_out1 : cache_data_out0;

		       // Controls if a miss
		       cache_offset = ((~hit1 & dirty1 & valid1) & (~hit0 & dirty0 & valid0)) ? 3'b000 : addr_out[2:0];

		       next_state = ((hit1 & valid1) | (hit0 & valid0)) ? IDLE :
			            ((~valid1) | (~valid0) ) ? ALLOC0 : // Choose invalid (default to 0)
			            ((victim_out == 0) & dirty0) ? WB0 : // Victim is 0 and its dirty & valid
			            ((victim_out == 1) & dirty1) ? WB0 : // Victim is 1 an its dirty & valid
			            ALLOC0; // Both valid and ~dirty, choose victimway but go to ALLOC

		       // Select appropriate cache for whatever comes next
		       cache_sel = (hit0 & valid0) ? 1'b0 : // Choose hit if possible
				   (hit1 & valid1) ? 1'b1 :
				   (~valid0) ? 1'b0 :
				   (~valid1) ? 1'b1 :
				   victim_out;
		end
		COMPW: begin
       		        enable0 = 1'b1;
		        enable1 = 1'b1;   
		        // Cache controls
		        comp0 = 1'b1;
    		        comp1 = 1'b1;
		        write0 = 1'b1;
		        write1 = 1'b1;

		        // Control needed if a hit & valid
			CacheHit = ((hit1 & valid1) | (hit0 & valid0)) ? 1'b1 : 1'b0;
		        Done = ((hit1 & valid1) | (hit0 & valid0)) ? 1'b1 : 1'b0;

                        // Control need if a miss
		        cache_offset = ((~hit1 & dirty1 & valid1) & (~hit0 & dirty0 & valid0)) ? 3'b000 : addr_out[2:0];

		        next_state = ((hit1 & valid1) | (hit0 & valid0)) ? IDLE :
			            ((~hit1 & ~valid1) | (~hit0 & ~valid0) ) ? ALLOC0 : // Choose invalid (default to 0)
			            ((victim_out == 0) & dirty0) ? WB0 : // Victim is 0 and its dirty & valid
			            ((victim_out == 1) & dirty1) ? WB0 : // Victim is 1 an its dirty & valid
			            ALLOC0; // Both valid and ~dirty, choose victimway but go to ALLOC
		   
		       // Select appropriate cache for whatever comes next
		       cache_sel = (hit0 & valid0) ? 1'b0 : // Choose hit if possible
				   (hit1 & valid1) ? 1'b1 :
				   (~valid0) ? 1'b0 :
				   (~valid1) ? 1'b1 :
				   victim_out;    
		end
		ALLOC0: begin
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
	                rd = 1'b1;
		        mem_off = 3'b000;
		        next_state = mem_stall ? ALLOC0 : ALLOC1;
		end
		ALLOC1: begin
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
	                rd = 1'b1;
		        mem_off = 3'b010;
		        next_state = mem_stall ? ALLOC1 : ALLOC2;
		end
		ALLOC2: begin
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
		        write0 = mem_stall ? 1'b0 :1'b1; // Since only one cache enabled, set signals for both
			write1 = mem_stall ? 1'b0 :1'b1;
			cache_offset = 3'b000;
			cache_data_in = mem_out;
	                rd = 1'b1;
		        mem_off = 3'b100;
		        next_state = mem_stall ? ALLOC2 : ALLOC3;
		end
		ALLOC3: begin
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
		        write0 = mem_stall ? 1'b0 :1'b1; // Since only one cache enabled, set signals for both
			write1 = mem_stall ? 1'b0 :1'b1;
			cache_offset = 3'b010;
		        cache_data_in = mem_out;
	                rd = 1'b1;
		        mem_off = 3'b110;
		        next_state = mem_stall ? ALLOC3 : ALLOC4;
		end
		ALLOC4: begin
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
		        write0 = mem_stall ? 1'b0 :1'b1; // Since only one cache enabled, set signals for both
			write1 = mem_stall ? 1'b0 :1'b1;
			cache_offset = 3'b100;  
			cache_data_in = mem_out;
		        next_state = mem_stall ? ALLOC4 : ALLOC5;
		end
		ALLOC5: begin
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
		        write0 = mem_stall ? 1'b0 :1'b1; // Since only one cache enabled, set signals for both
			write1 = mem_stall ? 1'b0 :1'b1;
			cache_offset = 3'b110;
			cache_data_in = mem_out;
		        valid_in = 1'b1;
		        next_state = mem_stall ? ALLOC5 :
			     	     Wr ? ALLOC6 :
				     ALLOC7;
		end  
		ALLOC6: begin // Writeback new data into cache
		        enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		        enable1 = (cache_sel) ? 1'b1 : 1'b0;
		        write0 = 1'b1;
		        write1 = 1'b1;
		        comp0 = 1'b1;
		        comp1 = 1'b1;
		        Done = 1'b1;
		        valid_in = 1'b1;
		        next_state = IDLE;
		        DataOut = 16'd0;
		end
		ALLOC7: begin // Read requested offset out of cache
                     enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		     enable1 = (cache_sel) ? 1'b1 : 1'b0;
		     cache_offset = addr_out[2:0];
		     Done = 1'b1;
                     next_state = IDLE;
		     //valid_in = 1'b1;
		end
		WB0: begin
		   enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		   enable1 = (cache_sel) ? 1'b1 : 1'b0;
		   wr = 1'b1;
		   next_state = mem_stall ? WB0 : WB1;
		   cache_offset = 3'b000;
		   mem_off = 3'b000;
		   mem_tag = (cache_sel) ? tag_out1 : tag_out0;
		end
		WB1: begin
		   enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		   enable1 = (cache_sel) ? 1'b1 : 1'b0;
		   wr = 1'b1;
		   next_state = mem_stall ? WB1 : WB2;
		   cache_offset = 3'b010;
		   mem_off = 3'b010;
		   mem_tag = (cache_sel) ? tag_out1 : tag_out0;		   
		end
		WB2: begin
		   enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		   enable1 = (cache_sel) ? 1'b1 : 1'b0;
		   wr = 1'b1;
		   next_state = mem_stall ? WB2 : WB3;
		   cache_offset = 3'b100;
		   mem_off = 3'b100;
		   mem_tag = (cache_sel) ? tag_out1 : tag_out0;
		end
		WB3: begin
		   enable0 = (~cache_sel) ? 1'b1 : 1'b0;
		   enable1 = (cache_sel) ? 1'b1 : 1'b0;
		   wr = 1'b1;
		   next_state = mem_stall ? WB3 : ALLOC0;
		   cache_offset = 3'b110;
		   mem_off = 3'b110;
		   mem_tag = (cache_sel) ? tag_out1 : tag_out0;
		end
	endcase

  end 
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
