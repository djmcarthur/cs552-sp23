`default_nettype none
module ID_EX(
    ID_EX_pc_inc,
    ID_EX_halt,
    ID_EX_rd,
    ID_EX_reg_dst,
    ID_EX_reg_write_en,
    ID_EX_rs,
    ID_EX_swap,
    ID_EX_alu_op,
    ID_EX_alu_cond_sel,
    ID_EX_alu_b_sel,
    ID_EX_invA,
    ID_EX_invB,
    ID_EX_sign,
    ID_EX_Cin,
    ID_EX_mem_write,
    ID_EX_mem_read,
    ID_EX_reg_write_data_sel,
    ID_EX_read1,
    ID_EX_read2,
    ID_EX_err,
    ID_EX_sign_ext_11_16,    
    ID_EX_sign_ext_5_16,
    ID_EX_sign_ext_8_16,
    ID_EX_zero_ext_5_16,
    ID_EX_pc_new,
    ID_EX_sel_pc_new,
    sel_pc_new,
    pc_new,
    pc_inc,
    halt,
    rd,
    reg_dst,
    reg_write_en,
    rs,
    swap,
    alu_op,
    alu_cond_sel,
    alu_b_sel,
    invA,
    invB,
    sign,
    Cin,
    mem_write,
    mem_read,
    reg_write_data_sel,
    sign_ext_11_16,
    sign_ext_5_16,
    sign_ext_8_16,
    zero_ext_5_16,    
    read1,
    read2,
    err,
    clk, rst);

    input wire clk, rst;

    output wire ID_EX_halt;
    output wire [2:0] ID_EX_rd;
    output wire [1:0] ID_EX_reg_dst;
    output wire [15:0] ID_EX_read1;
    output wire [15:0] ID_EX_read2;
    output wire ID_EX_err;
    output wire [15:0] ID_EX_sign_ext_11_16;
    output wire [15:0] ID_EX_sign_ext_5_16;
    output wire [15:0] ID_EX_sign_ext_8_16;
    output wire [15:0] ID_EX_zero_ext_5_16;

    // execute control out
    output wire ID_EX_reg_write_en;
    output wire ID_EX_swap;
    output wire [3:0] ID_EX_alu_op;
    output wire [3:0] ID_EX_alu_cond_sel;
    output wire [2:0] ID_EX_alu_b_sel;
    output wire ID_EX_invA;
    output wire ID_EX_invB;
    output wire ID_EX_sign;
    output wire ID_EX_Cin;
    // memory control out
    output wire ID_EX_mem_write;
    output wire ID_EX_mem_read;
    // writeback control out
    output wire [1:0] ID_EX_reg_write_data_sel;
    output wire ID_EX_rs;
    output wire [15:0] ID_EX_pc_inc;
   

    input wire halt;
    input wire [2:0] rd;
    input wire [1:0] reg_dst;
    input wire [15:0] read1;
    input wire [15:0] read2;
    input wire err;
    input wire [15:0] sign_ext_11_16;
    input wire [15:0] sign_ext_5_16;
    input wire [15:0] sign_ext_8_16;
    input wire [15:0] zero_ext_5_16;
    input wire [15:0] pc_inc;

    // New 4/4/23 for branches jumps
    output wire 	      ID_EX_sel_pc_new;
    input wire 		      sel_pc_new;
    input wire 	[15:0]	      pc_new;
    input wire 	[15:0]	      ID_EX_pc_new;
   
    // execute control in
    input wire reg_write_en;
    input wire swap;
    input wire [3:0] alu_op;
    input wire [3:0] alu_cond_sel;
    input wire [2:0] alu_b_sel;
    input wire invA;
    input wire invB;
    input wire sign;
    input wire Cin;
    // memory control in
    input wire mem_write;
    input wire mem_read;
    // writeback control in
    input wire [1:0] reg_write_data_sel;
    input wire rs;

   // NEW 4/4/23 for branch/jump control
   dff sel_pc_reg (.q(ID_EX_sel_pc_new), .d(sel_pc_new), .clk(clk), .rst(1'b0));
   dff next_pc_reg [15:0](.q(ID_EX_pc_new), .d(pc_new), .clk(clk), .rst(1'b0));

    
    dff rd_reg[2:0] (.q(ID_EX_rd), .d(rd), .clk(clk), .rst(rst));
    dff halt_reg(.q(ID_EX_halt), .d(halt), .clk(clk), .rst(rst));
    // execute
    dff reg_dst_reg[1:0] (.q(ID_EX_reg_dst), .d(reg_dst), .clk(clk), .rst(rst));
    dff reg_write_en_reg(.q(ID_EX_reg_write_en), .d(reg_write_en), .clk(clk), .rst(rst));
    dff swap_reg(.q(ID_EX_swap), .d(swap), .clk(clk), .rst(rst));
    dff alu_op_reg[3:0] (.q(ID_EX_alu_op), .d(alu_op), .clk(clk), .rst(rst));
    dff alu_cond_sel_reg[3:0] (.q(ID_EX_alu_cond_sel), .d(alu_cond_sel), .clk(clk), .rst(rst));
    dff alu_b_sel_reg[2:0] (.q(ID_EX_alu_b_sel), .d(alu_b_sel), .clk(clk), .rst(rst));
    dff invA_reg(.q(ID_EX_invA), .d(invA), .clk(clk), .rst(rst));
    dff invB_reg(.q(ID_EX_invB), .d(invB), .clk(clk), .rst(rst));
    dff sign_reg(.q(ID_EX_sign), .d(sign), .clk(clk), .rst(rst));
    dff Cin_reg(.q(ID_EX_Cin), .d(Cin), .clk(clk), .rst(rst));
    // memory
    dff mem_write_reg(.q(ID_EX_mem_write), .d(mem_write), .clk(clk), .rst(rst));
    dff mem_read_reg(.q(ID_EX_mem_read), .d(mem_read), .clk(clk), .rst(rst));
    //writeback
    dff reg_write_data_sel_reg[1:0] (.q(ID_EX_reg_write_data_sel), .d(reg_write_data_sel), .clk(clk), .rst(rst));
    dff rs_reg(.q(ID_EX_rs), .d(rs), .clk(clk), .rst(rst));
    dff pc_reg [15:0](.q(ID_EX_pc_inc), .d(pc_inc), .clk(clk), .rst(rst));
   

    dff read1_reg[15:0] (.q(ID_EX_read1), .d(read1), .clk(clk), .rst(rst));
    dff read2_reg[15:0] (.q(ID_EX_read2), .d(read2), .clk(clk), .rst(rst));
    dff err_reg(.q(ID_EX_err), .d(err), .clk(clk), .rst(rst));
    dff sign_ext_11_16_reg[15:0] (.q(ID_EX_sign_ext_11_16), .d(sign_ext_11_16), .clk(clk), .rst(rst));
    dff sign_ext_5_16_reg[15:0] (.q(ID_EX_sign_ext_5_16), .d(sign_ext_5_16), .clk(clk), .rst(rst));
    dff sign_ext_8_16_reg[15:0] (.q(ID_EX_sign_ext_8_16), .d(sign_ext_8_16), .clk(clk), .rst(rst));
    dff zero_ext_5_16_reg[15:0] (.q(ID_EX_zero_ext_5_16), .d(zero_ext_5_16), .clk(clk), .rst(rst));


endmodule
`default_nettype wire
