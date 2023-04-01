/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (read1, read2, reg_write, next_pc, pc_inc, err, instr, wb_out, reg_dst, write_reg_en, MEM_WB_rd,
               sign_ext_11_16, sign_ext_5_16, sign_ext_8_16, zero_ext_5_16, pc_a_sel, pc_b_sel, br, br_type, jump, rs, jal, clk, rst);

   output wire [15:0] read1, read2;
   output wire [15:0] next_pc;
   output wire err;
   output wire [15:0] sign_ext_11_16, sign_ext_5_16, sign_ext_8_16, zero_ext_5_16;
   output wire [2:0] reg_write;  // the register to be written back to


   input wire [15:0] instr, wb_out, pc_inc;
   input wire clk, rst;
   input wire [1:0] reg_dst;
   input wire write_reg_en;
   input wire pc_a_sel, pc_b_sel; // some control sigs
   input wire jump, rs, jal;
   input wire br; //if branching
   input wire [1:0] br_type; //{equal, not equal, less than, greater than}
   input wire [2:0] MEM_WB_rd;

   wire [15:0] pc_a, pc_b;
   wire [15:0] jmp_addr, rs_imm, branch_addr;
   wire [15:0] add_out;
   wire gt, lt, equals, lte, gte, overflow;
   wire [15:0] reg_in;

   assign sign_ext_11_16 = {{5{instr[10]}}, instr[10:0]};
   assign sign_ext_5_16 = {{11{instr[4]}}, instr[4:0]};
   assign sign_ext_8_16 = {{8{instr[7]}}, instr[7:0]};
   assign zero_ext_5_16 = {{11'b0}, instr[4:0]};


   assign err = 1'b0;

   // what register are we writing to?
   assign reg_write = (reg_dst == 2'b00) ? instr[10:8] :
                     (reg_dst == 2'b01) ? instr[7:5] :
                     (reg_dst == 2'b10) ? instr[4:2] :
                     (reg_dst == 2'b11) ? 3'b111 :
                     3'b111;
   assign pc_a = (pc_a_sel) ? pc_inc : read1;
   assign pc_b = (pc_b_sel) ? sign_ext_11_16 : sign_ext_8_16;

   cla_16b jmp_addr_rs(.sum(rs_imm), .c_out(), .a(read1), .b(pc_b), .c_in(1'b0));

   cla_16b jmp_addr_pc(.sum(jmp_addr), .c_out(), .a(pc_a), .b(pc_b), .c_in(1'b0));

   cla_16b branch_add(.sum(branch_addr), .c_out(), .a(pc_inc), .b(sign_ext_8_16), .c_in(1'b0));

   //br is the enable for branching  [1:0] br_type =  {equal, not equal, less than, greater than}
   // also need to incorperate this into the next_pc assign statement
   /* br ? br_type[0] ? equals ? branch_addr : pc_inc : 
            br_type[1] ? ~equals ? branch_addr : pc_inc :
            br_type[2] ? lt ? branch_addr : pc_inc :  
            br_type[3] ? gt ? branch_addr : pc_inc : 
            pc_inc
   */



   assign next_pc = (jump) ? rs ? rs_imm : jmp_addr : 
                     br ? 
                        br_type == 2'b00 ? equals ? branch_addr : pc_inc :
                        br_type == 2'b01 ? ~equals ? branch_addr : pc_inc :
                        br_type == 2'b10 ? lt ? branch_addr : pc_inc :
                        br_type == 2'b11 ? gte ? branch_addr : pc_inc :
                        pc_inc : pc_inc;

   assign reg_in = (jal) ? pc_inc : wb_out;

   regFile_bypass regFile0(.read1Data(read1), .read2Data(read2), .err(), .clk(clk), .rst(rst), .read1RegSel(instr[10:8]), .read2RegSel(instr[7:5]), 
            .writeRegSel(MEM_WB_rd), .writeData(reg_in), .writeEn(write_reg_en));

   cla_16b adder(.sum(add_out), .c_out(), .a(read1), .b('0), .c_in('0));

   assign overflow = (add_out[15] & ~read1[15]);

   // Condition codes

   assign lt = (read1[15] & (read1 != '0)); //CHANGE WONT PASS VCHECK
   //(add != 16'h0000) & (add_out[15] == ~overflow);

   assign equals = (read1 == 16'b0);

   assign lte = lt | equals;

   assign gt = (~read1[15] & read1 != '0); //CHANGE WONT PASS VCHECK
   //(add != 16'h0000) & (add_out[15] == 1'b0);

   assign gte = gt | equals;

endmodule
`default_nettype wire
