/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;
   output wire err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines

   wire [15:0] instr, next_pc, pc_inc, read1, read2, alu_res, wb_out, sign_ext_11_16, sign_ext_5_16, zero_ext_5_16, sign_ext_8_16, mem_data, jmp_addr;
   wire [3:0] alu_cond_sel, alu_opcode;
   wire [2:0] alu_sel_b;
   wire halt, invA, invB, Cin, swap, sign, alu_cond_out, mem_write, mem_read, write_reg_en;
   wire [1:0] reg_write_data_sel;
   wire [1:0] reg_dst;
   wire [1:0] br_type;
   wire [2:0] rd;
   wire jump, rs, jal, br, pc_a_sel, pc_b_sel, sel_pc_new;

   // pipeline wires

   // pipeline control
     // NEW 4/4/23
   wire        ID_EX_sel_pc_new;
   wire [15:0] ID_EX_pc_new;
   wire        stall, check_rs, check_rt, flush;

   // IF/ID
   wire [15:0] IF_ID_instr;
   wire [15:0] IF_ID_pc_inc;
   wire        IF_ID_halt;

   // ID/EX
   wire [15:0] ID_EX_pc_inc;
   wire ID_EX_halt;
   wire [2:0] ID_EX_rd;
   wire [1:0] ID_EX_reg_dst;
   wire ID_EX_reg_write_en;
   wire ID_EX_rs;
   wire ID_EX_swap;
   wire [3:0] ID_EX_alu_op;
   wire [3:0] ID_EX_alu_cond_sel;
   wire [2:0] ID_EX_alu_b_sel;
   wire ID_EX_invA;
   wire ID_EX_invB;
   wire ID_EX_sign;
   wire ID_EX_Cin;
   wire ID_EX_mem_write;
   wire ID_EX_mem_read;
   wire [1:0] ID_EX_reg_write_data_sel;
   wire [15:0] ID_EX_read1;
   wire [15:0] ID_EX_read2;
   wire ID_EX_err;
   wire [15:0] ID_EX_sign_ext_11_16;   
   wire [15:0] ID_EX_sign_ext_5_16;
   wire [15:0] ID_EX_sign_ext_8_16;
   wire [15:0] ID_EX_zero_ext_5_16;

   // EX/MEM
   wire [15:0] EX_MEM_pc_inc;
   
   wire EX_MEM_halt;
   wire [2:0] EX_MEM_rd;
   wire [1:0] EX_MEM_reg_dst;
   wire [15:0] EX_MEM_ex_res;
   wire EX_MEM_rs;
   wire EX_MEM_reg_write_en;
   wire EX_MEM_alu_cond_out;
   wire EX_MEM_mem_write;
   wire EX_MEM_mem_read;
   wire [1:0] EX_MEM_reg_write_data_sel;
   wire [15:0] EX_MEM_read2;

   // MEM/WB
   wire [15:0] MEM_WB_pc_inc;
   wire MEM_WB_halt;
   wire [2:0] MEM_WB_rd;
   wire [1:0] MEM_WB_reg_dst;
   wire [15:0] MEM_WB_data;
   wire MEM_WB_reg_write_en;
   wire MEM_WB_rs;
   wire [1:0] MEM_WB_reg_write_data_sel;
   wire [15:0] MEM_WB_ex_res;
   wire MEM_WB_alu_cond_out;
   
    control proc_cntrl(.halt(halt), .Cin(Cin), .pc_a_sel(pc_a_sel), .pc_b_sel(pc_b_sel), .br(br), .br_type(br_type), .sign(sign), .reg_write_reg_sel(reg_dst), 
    .reg_write_data_sel(reg_write_data_sel), .invA(invA), .invB(invB), .swap(swap), .reg_write_en(write_reg_en), .alu_b_sel(alu_sel_b), 
    .alu_cond_sel(alu_cond_sel), .alu_op(alu_opcode), .mem_read(mem_read), .mem_write(mem_write), .instr(IF_ID_instr), .jump(jump), .rs(rs), .jal(jal), .rst(rst), 
    .check_rs(check_rs), .check_rt(check_rt), .stall(stall));
   
   fetch fetch0(.instr(instr), .pc_inc(pc_inc), .next_pc(ID_EX_pc_new), .halt(MEM_WB_halt), .clk(clk), .rst(rst), .sel_pc_new(ID_EX_sel_pc_new), .stall(stall));

   IF_ID IF_ID_reg(
    .IF_ID_instr(IF_ID_instr), .pc_inc(pc_inc), .IF_ID_pc_inc(IF_ID_pc_inc), .IF_ID_halt(IF_ID_halt),
    .instr(instr), 
    .clk(clk), .rst(rst), .stall(stall), .halt(halt));
   
   stall_logic stall0(.ID_EX_rs(IF_ID_instr[10:8]), .ID_EX_rt(IF_ID_instr[7:5]),.EX_MEM_rd(EX_MEM_rd), .MEM_WB_rd(ID_EX_rd), .check_rs(check_rs), .check_rt(check_rt), .stall(stall));

   decode decode0(.read1(read1), .read2(read2), .reg_write(rd), .next_pc(next_pc), .pc_inc(IF_ID_pc_inc), .err(err), .instr(IF_ID_instr), 
   .wb_out(wb_out), .reg_dst(reg_dst), .clk(clk), .rst(rst), .write_reg_en(MEM_WB_reg_write_en), .sign_ext_11_16(sign_ext_11_16),
   .sign_ext_8_16(sign_ext_8_16), .sign_ext_5_16(sign_ext_5_16), .zero_ext_5_16(zero_ext_5_16), .pc_a_sel(pc_a_sel), 
   .pc_b_sel(pc_b_sel), .br(br), .br_type(br_type), .jump(jump), .rs(rs), .jal(jal), .MEM_WB_rd(MEM_WB_rd), .sel_pc_new(sel_pc_new), .stall(stall), .flush(flush));

   ID_EX ID_EX_reg(
    .pc_inc(IF_ID_pc_inc),
    .ID_EX_pc_inc(ID_EX_pc_inc),
    .ID_EX_halt(ID_EX_halt),
    .ID_EX_rd(ID_EX_rd),
    .ID_EX_reg_dst(ID_EX_reg_dst),
    .ID_EX_reg_write_en(ID_EX_reg_write_en),
    .ID_EX_rs(ID_EX_rs),
    .ID_EX_swap(ID_EX_swap),
    .ID_EX_alu_op(ID_EX_alu_op),
    .ID_EX_alu_cond_sel(ID_EX_alu_cond_sel),
    .ID_EX_alu_b_sel(ID_EX_alu_b_sel),
    .ID_EX_invA(ID_EX_invA),
    .ID_EX_invB(ID_EX_invB),
    .ID_EX_sign(ID_EX_sign),
    .ID_EX_Cin(ID_EX_Cin),
    .ID_EX_mem_write(ID_EX_mem_write),
    .ID_EX_mem_read(ID_EX_mem_read),
    .ID_EX_reg_write_data_sel(ID_EX_reg_write_data_sel),
    .ID_EX_read1(ID_EX_read1),
    .ID_EX_read2(ID_EX_read2),
    .ID_EX_err(ID_EX_err),
    .ID_EX_sign_ext_11_16(ID_EX_sign_ext_11_16),    
    .ID_EX_sign_ext_5_16(ID_EX_sign_ext_5_16),
    .ID_EX_sign_ext_8_16(ID_EX_sign_ext_8_16),
    .ID_EX_zero_ext_5_16(ID_EX_zero_ext_5_16),
    .ID_EX_sel_pc_new(ID_EX_sel_pc_new),
    .ID_EX_pc_new(ID_EX_pc_new),
    .pc_new(next_pc),
    .sel_pc_new(sel_pc_new),
    .halt(IF_ID_halt),
    .reg_dst(reg_dst),
    .reg_write_en(write_reg_en),
    .rd(rd),
    .rs(rs),
    .swap(swap),
    .alu_op(alu_opcode),
    .alu_cond_sel(alu_cond_sel),
    .alu_b_sel(alu_sel_b),
    .invA(invA),
    .invB(invB),
    .sign(sign),
    .Cin(Cin),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .reg_write_data_sel(reg_write_data_sel),
    .sign_ext_11_16(sign_ext_11_16),
    .sign_ext_5_16(sign_ext_5_16),
    .sign_ext_8_16(sign_ext_8_16),
    .zero_ext_5_16(zero_ext_5_16),    
    .read1(read1),
    .read2(read2),
    .err(err),
    .clk(clk), .rst(rst), .stall(stall), .flush(flush));

   execute execute0(.ex_res(alu_res), .alu_cond_out(alu_cond_out), .data1(ID_EX_read1), .data2(ID_EX_read2), .invA(ID_EX_invA), .invB(ID_EX_invB), .Cin(ID_EX_Cin), 
   .Oper(ID_EX_alu_op), .alu_sel_b(ID_EX_alu_b_sel), .swap(ID_EX_swap), .alu_cond_sel(ID_EX_alu_cond_sel), .zero_ext_5_16(ID_EX_zero_ext_5_16), 
   .sign_ext_8_16(ID_EX_sign_ext_8_16), .sign_ext_5_16(ID_EX_sign_ext_5_16), .sign(ID_EX_sign), .clk(clk), .rst(rst));

   EX_MEM EX_MEM_reg(
    .pc_inc(ID_EX_pc_inc),
    .EX_MEM_pc_inc(EX_MEM_pc_inc),
    .EX_MEM_halt(EX_MEM_halt),
    .EX_MEM_rd(EX_MEM_rd),
    .EX_MEM_reg_dst(EX_MEM_reg_dst),
    .EX_MEM_ex_res(EX_MEM_ex_res),
    .EX_MEM_rs(EX_MEM_rs),
    .EX_MEM_reg_write_en(EX_MEM_reg_write_en),
    .EX_MEM_alu_cond_out(EX_MEM_alu_cond_out),
    .EX_MEM_mem_write(EX_MEM_mem_write),
    .EX_MEM_mem_read(EX_MEM_mem_read),
    .EX_MEM_reg_write_data_sel(EX_MEM_reg_write_data_sel),
    .EX_MEM_read2(EX_MEM_read2),
    .alu_cond_out(alu_cond_out),
    .ex_res(alu_res),
    .ID_EX_halt(ID_EX_halt),
    .ID_EX_rd(ID_EX_rd),
    .ID_EX_reg_dst(ID_EX_reg_dst),
    .ID_EX_rs(ID_EX_rs),
    .ID_EX_reg_write_en(ID_EX_reg_write_en),
    .ID_EX_mem_write(ID_EX_mem_write),
    .ID_EX_mem_read(ID_EX_mem_read),
    .ID_EX_reg_write_data_sel(ID_EX_reg_write_data_sel),
    .ID_EX_read2(ID_EX_read2),
    .clk(clk), .rst(rst), .stall(stall), .flush(flush));

   memory memory0(.data(mem_data), .data2(EX_MEM_read2), .data_res(EX_MEM_ex_res), .wr(EX_MEM_mem_write), .en(EX_MEM_mem_read), 
   .halt(EX_MEM_halt), .clk(clk), .rst(rst));

   MEM_WB MEM_WB_reg(
    .pc_inc(EX_MEM_pc_inc),
    .MEM_WB_pc_inc(MEM_WB_pc_inc),
    .MEM_WB_halt(MEM_WB_halt),
    .MEM_WB_rd(MEM_WB_rd),
    .MEM_WB_reg_dst(MEM_WB_reg_dst),
    .MEM_WB_data(MEM_WB_data),
    .MEM_WB_reg_write_en(MEM_WB_reg_write_en),
    .MEM_WB_rs(MEM_WB_rs),
    .MEM_WB_reg_write_data_sel(MEM_WB_reg_write_data_sel),
    .MEM_WB_ex_res(MEM_WB_ex_res),
    .MEM_WB_alu_cond_out(MEM_WB_alu_cond_out),
    .data(mem_data),
    .EX_MEM_halt(EX_MEM_halt),
    .EX_MEM_rd(EX_MEM_rd),
    .EX_MEM_reg_dst(EX_MEM_reg_dst),
    .EX_MEM_reg_write_en(EX_MEM_reg_write_en),
    .EX_MEM_rs(EX_MEM_rs),
    .EX_MEM_reg_write_data_sel(EX_MEM_reg_write_data_sel),
    .EX_MEM_ex_res(EX_MEM_ex_res),
    .EX_MEM_alu_cond_out(EX_MEM_alu_cond_out),
    .clk(clk), .rst(rst), .flush(flush));

   wb wb0(.wb_out(wb_out), .alu_cond(MEM_WB_alu_cond_out), .pc_inc(MEM_WB_pc_inc), .data(MEM_WB_data), .alu_res(MEM_WB_ex_res), 
         .reg_write_sel(MEM_WB_reg_write_data_sel));
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
