`default_nettype none
module EX_MEM(
    EX_MEM_pc_inc,
    EX_MEM_halt,
    EX_MEM_rd,
    EX_MEM_reg_dst,
    EX_MEM_ex_res,
    EX_MEM_rs,
    EX_MEM_reg_write_en,
    EX_MEM_alu_cond_out,
    EX_MEM_mem_write,
    EX_MEM_mem_read,
    EX_MEM_reg_write_data_sel,
    EX_MEM_read2,
    alu_cond_out,
    ex_res,
    pc_inc,
    ID_EX_halt,
    ID_EX_rd,
    ID_EX_reg_dst,
    ID_EX_rs,
    ID_EX_reg_write_en,
    ID_EX_mem_write,
    ID_EX_mem_read,
    ID_EX_reg_write_data_sel,
    ID_EX_read2,
    clk, rst, stall, flush);

    input wire clk, rst;

    output wire EX_MEM_halt;
    output wire [2:0] EX_MEM_rd;

   input wire [15:0]  pc_inc;
   output wire [15:0] EX_MEM_pc_inc;
   
   
    // pipe alu res out
    output wire [1:0] EX_MEM_reg_dst;
    output wire [15:0] EX_MEM_ex_res;
    // pipe alu cond out
    output wire EX_MEM_alu_cond_out;
    output wire [15:0] EX_MEM_read2;

    // memory control out
    output wire EX_MEM_mem_write;
    output wire EX_MEM_mem_read;
    // writeback control out
    output wire EX_MEM_reg_write_en;
    output wire EX_MEM_rs;
    output wire [1:0] EX_MEM_reg_write_data_sel;

    input wire ID_EX_halt;
    input wire [2:0] ID_EX_rd;
    // alu res
    input wire [15:0] ex_res;
    // alu cond out
    input wire alu_cond_out;
    input wire [15:0] ID_EX_read2;

    input wire [1:0] ID_EX_reg_dst;
    // memory control in
    input wire ID_EX_mem_write;
    input wire ID_EX_mem_read;
    // writeback control in
    input wire ID_EX_reg_write_en;
    input wire ID_EX_rs;
    input wire [1:0] ID_EX_reg_write_data_sel;


    input wire 	     stall;
    input wire       flush;


    dff halt_reg(.q(EX_MEM_halt), .d(ID_EX_halt), .clk(clk), .rst(rst));
    dff rd_reg[2:0] (.q(EX_MEM_rd), .d(ID_EX_rd), .clk(clk), .rst(rst));
    dff reg_dst_reg[1:0] (.q(EX_MEM_reg_dst), .d(ID_EX_reg_dst), .clk(clk), .rst(rst));
    // memory
    dff mem_write_reg(.q(EX_MEM_mem_write), .d(flush ? 1'b0 : ID_EX_mem_write), .clk(clk), .rst(rst));
    dff mem_read_reg(.q(EX_MEM_mem_read), .d(flush ? 1'b0 : ID_EX_mem_read), .clk(clk), .rst(rst));
    //writeback
    dff reg_write_data_sel_reg[1:0] (.q(EX_MEM_reg_write_data_sel), .d(ID_EX_reg_write_data_sel), .clk(clk), .rst(rst));
    dff rs_reg(.q(EX_MEM_rs), .d(ID_EX_rs), .clk(clk), .rst(rst));
    dff reg_write_en_reg(.q(EX_MEM_reg_write_en), .d(flush ? 1'b0 : ID_EX_reg_write_en), .clk(clk), .rst(rst));
    dff pc_reg [15:0](.q(EX_MEM_pc_inc), .d(pc_inc), .clk(clk), .rst(rst));

    // alu res
    dff ex_res_reg[15:0] (.q(EX_MEM_ex_res), .d(ex_res), .clk(clk), .rst(rst));
    //alu cond out
    dff alu_cond_out_reg(.q(EX_MEM_alu_cond_out), .d(alu_cond_out), .clk(clk), .rst(rst));
    dff read2_reg[15:0] (.q(EX_MEM_read2), .d(ID_EX_read2), .clk(clk), .rst(rst));



endmodule
`default_nettype wire
