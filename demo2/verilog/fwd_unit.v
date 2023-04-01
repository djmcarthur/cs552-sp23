/*`default_nettype none
module fwd_unit(fwdA, fwdB, EX_MEM_ex_res, EX_MEM_reg_write, EX_MEM_reg_rd, ID_EX_reg_rs, ID_EX_reg_rt);

/*
    if(EX_MEM_reg_write = 1 & EX_MEM_reg_rd == ID_EX_rs)
        forwardA = 2
    
    if(EX_MEM_reg_write = 1 & EX_MEM_reg_rd == ID_EX_rt)
        forwardB = 2


    output wire [1:0] fwdA;
    output wire [1:0] fwdB;

    input wire [15:0] EX_MEM_ex_res;

endmodule
`default_nettype wire
*/
