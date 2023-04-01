`default_nettype none
module MEM_WB(
    MEM_WB_halt,
    MEM_WB_rd,
    MEM_WB_reg_dst,
    MEM_WB_data,
    MEM_WB_reg_write_en,
    MEM_WB_rs,
    MEM_WB_reg_write_data_sel,
    MEM_WB_ex_res,
    MEM_WB_alu_cond_out,
    data,
    EX_MEM_halt,
    EX_MEM_rd,
    EX_MEM_reg_dst,
    EX_MEM_reg_write_en,
    EX_MEM_rs,
    EX_MEM_reg_write_data_sel,
    EX_MEM_ex_res,
    EX_MEM_alu_cond_out,
    clk, rst);

    input wire clk, rst;

    output wire MEM_WB_halt;
    output wire [2:0] MEM_WB_rd;
    output wire [1:0] MEM_WB_reg_dst;
    output wire [15:0] MEM_WB_data;
    output wire [15:0] MEM_WB_ex_res;
    output wire MEM_WB_alu_cond_out;

    // writeback control out
    output wire MEM_WB_reg_write_en;
    output wire MEM_WB_rs;
    output wire [1:0] MEM_WB_reg_write_data_sel;

    input wire EX_MEM_halt;
    input wire [2:0] EX_MEM_rd;
    input wire [1:0] EX_MEM_reg_dst;
    input wire [15:0] data;
    input wire [15:0] EX_MEM_ex_res;
    input wire EX_MEM_alu_cond_out;

    // writeback control in
    input wire EX_MEM_reg_write_en;
    input wire EX_MEM_rs;
    input wire [1:0] EX_MEM_reg_write_data_sel;

    dff reg_dst_reg[1:0] (.q(MEM_WB_reg_dst), .d(EX_MEM_reg_dst), .clk(clk), .rst(rst));
    
    dff halt_reg(.q(MEM_WB_halt), .d(EX_MEM_halt), .clk(clk), .rst(rst));
    dff rd_reg [2:0] (.q(MEM_WB_rd), .d(EX_MEM_rd), .clk(clk), .rst(rst));
    dff alu_cond_out_reg(.q(MEM_WB_alu_cond_out), .d(EX_MEM_alu_cond_out), .clk(clk), .rst(rst));
    dff ex_res_reg[15:0] (.q(MEM_WB_ex_res), .d(EX_MEM_ex_res), .clk(clk), .rst(rst));
    dff data_reg[15:0] (.q(MEM_WB_data), .d(data), .clk(clk), .rst(rst));

    //writeback
    dff reg_write_en_reg(.q(MEM_WB_reg_write_en), .d(EX_MEM_reg_write_en), .clk(clk), .rst(rst));
    dff rs_reg(.q(MEM_WB_rs), .d(EX_MEM_rs), .clk(clk), .rst(rst));
    dff reg_write_data_sel_reg[1:0] (.q(MEM_WB_reg_write_data_sel), .d(EX_MEM_reg_write_data_sel), .clk(clk), .rst(rst));
    


endmodule
`default_nettype wire