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
   wire [3:0] 	     state;
   reg [3:0] 	     next_state;

   /* state machine signals */

   // going in to mem or cache
   reg 		     enable, comp, write, valid_in;
   reg [15:0]        cache_data_in;
   reg [2:0] 	     offset;
   reg 		     rd,wr;
   reg [4:0] 	     mem_tag;
   reg [2:0] 	     mem_off;
   reg [15:0] 	     mem_in;
   wire [15:0] 	     mem_addr;

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
                          .data_in              (cache_data_in),
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
                     .data_in           (mem_in),
                     .wr                (wr),
                     .rd                (rd));
   
   // your code here
   assign mem_addr = {mem_tag, Addr[10:3], mem_off};

   localparam IDLE	= 4'd0;
   localparam COMPR  	= 4'd1;
   localparam COMPW  	= 4'd2;
   localparam ALLOC0 	= 4'd3;
   localparam ALLOC1 	= 4'd4;
   localparam ALLOC2 	= 4'd5;
   localparam ALLOC3 	= 4'd6;
   localparam ALLOC4	= 4'd7;
   localparam ALLOC5 	= 4'd8;
   localparam WB0	= 4'd9;
   localparam WB1  	= 4'd10;
   localparam WB2    	= 4'd11;
   localparam WB3	= 4'd12;
   localparam ALLOC6    = 4'd13;   
   localparam ALLOC7	= 4'd14;
   dff state_ff[3:0](.q(state),.d(next_state),.clk(clk),.rst(rst));

   always @(*) begin
      mem_tag = Addr[15:11];
      mem_off = 3'b000;
      err = mem_err | cache_err;
      cache_data_in = DataIn;
      enable = 1'b0;
      offset = Addr[2:0];
      comp = 1'b0;
      write = 1'b0;
      valid_in = 1'b0;
      wr = 1'b0;
      rd = 1'b0;
      Done = 1'b0;
      Stall = 1'b1;
      CacheHit = 1'b0;
      DataOut = data_out;
      mem_in = data_out;

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
		      comp = 1'b0;
		      wr = (~hit & dirty & valid) ? 1'b1 : 1'b0;
		      mem_tag = (~hit & dirty & valid) ? tag_out : Addr[15:11];
		      offset = (~hit & dirty & valid) ? 3'b000 : Addr[2:0]; 
		      next_state = (~hit & dirty & valid) ? WB0 :
		                   (hit & valid) ? IDLE:
				   ALLOC0;		   
		      Done = (hit & valid) ? 1'b1 : 1'b0; 
		      //Stall = (hit & valid) ? 1'b0:1'b1;
	              CacheHit = (hit & valid) ? 1'b1 : 1'b0;
		      DataOut = data_out;
		      mem_off = 3'b000;
		      offset = ((~hit & ~dirty) | ~valid) ? 3'b000 : Addr[2:0];
		      cache_data_in = mem_out;
	     end
	     COMPW: begin
		     enable = 1'b1;
		     comp = 1'b0;
		     write = 1'b0;
		     next_state = (hit & valid) ? IDLE :
				  (dirty & valid) ? WB0 :
				  //mem_stall:
				  ALLOC0;
		     Done = (hit & valid) ? 1'b1 : 1'b0;
		     rd = ((~hit & ~dirty) | ~valid) ? 1'b1 : 1'b0;
		     //write = (hit & valid) ? 1'b1 : 1'b0;
		     cache_data_in = (hit & valid) ? DataIn : mem_out;
		     mem_off = 3'b000;
		     valid_in = 1'b1;
		     CacheHit = (hit & valid) ? 1'b1 : 1'b0;
		     mem_tag = (~hit & dirty & valid) ? tag_out : Addr[15:11];
		     wr = (dirty & valid) ? 1'b1 : 1'b0;
		     offset = (dirty & valid) ? 3'b000 : Addr[2:0];
	     end
	     ALLOC0: begin
		     enable = 1'b1;
		     rd = 1'b1;
		     write = 1'b1;
		     cache_data_in = mem_out;
		     mem_off = 3'b000;
		     
//		     next_state = mem_stall ? ALLOC0 : ALLOC1;
		    // next_state = mem_stall ? ALLOC0 : ALLOC1;
		    next_state = ALLOC1;
	     end
	     ALLOC1: begin
                     enable = 1'b1;
		     rd = 1'b1;
		     write = 1'b1;
		     cache_data_in = mem_out;
		     offset = 3'b000;
		     mem_off = 3'b010;
                     next_state = mem_stall ? ALLOC0 : ALLOC2;
             end
	     ALLOC2: begin
                     enable = 1'b1;
		     rd = 1'b1;
		     write = mem_stall ? 1'b0 :1'b1;
		     cache_data_in = mem_out;
		     offset = 3'b000;
		     mem_off = 3'b100;
                     next_state = mem_stall ? ALLOC2 : ALLOC3;
             end
             ALLOC3: begin
                     enable = 1'b1;
		     rd = 1'b1;
		     write = 1'b1;
		     cache_data_in = mem_out;
		     mem_off = 3'b110;
		     offset = 3'b010;
                     next_state = mem_stall ? ALLOC3 : ALLOC4;
		     valid_in = 1'b1;	
             end
	     ALLOC4: begin
                     enable = 1'b1;
                     //rd = 1'b1;
		     write = 1'b1;
                     cache_data_in = mem_out;
 //                  mem_off = 3'b10;
                     next_state = ALLOC6;
		     offset = 3'b100;
		     //`Done = mem_stall | Wr ? 1'b0 : 1'b1;
		     valid_in = 1'b1;
		     DataOut = data_out;
             end
             ALLOC5: begin // For writing new data after allocating
                     enable = 1'b1;
		     //rd = 1'b1;
		     Done = 1'b1;
                     next_state = IDLE;
		     valid_in = 1'b1;
                     write = 1'b1;
		     //Stall = 1'b0;
		     comp =1'b1;
             end
	    ALLOC6: begin //for writing to the cache
	    	     enable = 1'b1;
		     offset = 3'b110;
		     cache_data_in = mem_out;
		     write = 1'b1;
		     valid_in = 1'b1;
		     next_state = mem_stall ? ALLOC4 :
			     	  Wr ? ALLOC5 :
				  ALLOC7;
	     end
	    ALLOC7: begin  // For reading out data after allocating
                     enable = 1'b1;
		     offset = Addr[2:0];
		     //rd = 1'b1;
	             //comp = 1'b1;
		     Done = 1'b1;
                     next_state = IDLE;
	    end
	   /*  WB0: begin
		     enable = 1'b1;
		     wr = 1'b1;
		     next_state = WB1;
		     offset = 3'b010;
		     mem_tag = tag_out;
	    end	     
	    WB1: begin
		     enable = 1'b1;
		     wr = 1'b1;
		     next_state = WB2;
		     offset = 3'b100;
	             mem_tag = tag_out;
	    end
	    WB2: begin
		     enable = 1'b1;
		     wr = 1'b1;
		     next_state = WB3;
		     offset = 3'b110;
	             mem_tag = tag_out;
	    end
	    WB3: begin
		     enable = 1'b1;
		     rd = 1'b1;
		     next_state = ALLOC0;
		     offset = 3'b000;
	             valid_in = 1'b1;
	      
	    end*/
	     WB0: begin
		     enable = 1'b1;
		     wr = 1'b1;
		     next_state = WB1;
		     mem_off = 3'b010;
		     offset = 3'b010;
		     mem_tag = tag_out;
	    end	     
	    WB1: begin
		     enable = 1'b1;
		     offset = 3'b100;
		     wr = 1'b1;
		     next_state = WB2;
		     mem_off = 3'b100;
	             mem_tag = tag_out;
	    end
	    WB2: begin
		     enable = 1'b1;
		     offset = 3'b110;
		     wr = 1'b1;
		     next_state = WB3;
		     mem_off = 3'b110;
	             mem_tag = tag_out;
	    end
	    WB3: begin
		     enable = 1'b1;
		     offset = 3'b000;
		     rd = 1'b1;
		     next_state = ALLOC1;
		     mem_off = 3'b000;
	             valid_in = 1'b1;
	    end 
	default: begin
	   end
      endcase // case (state)
      end
endmodule // mem_system
`default_nettype wire
// DUMMY LINElocalparam FOR REV CONTROL :9:
