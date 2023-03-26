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

   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   wire [15:0] instr, pc_inc, pc_new, read_data1, read_data2, alu_res;
   wire mem_read, mem_write;
   wire halt;

   fetch proc_f(.instr(instr),.pc_inc(pc_inc),.pc_new(pc_new),.halt(halt),.clk(clk),.rst(rst));

   decode proc_d(.read_data1(read_data1),.read_data2(read_data2),.se_11_16(),.se_8_16(),.se_5_16(),.ze_8_16(),.ze_5_16(),.pc_inc_out(pc_inc),.pc_inc_in(pc_inc),.write_data_in(),.clk(clk),.rst(rst),.err(err),.writeEn(),.instr(instr));

   execute proc_x(.pc_inc_in(pc_inc),.pc_new(),.alu_res(alu_res),.alu_cond(),.read_data1_in(),.read_data2_in(),.se_11_16(),.se_8_16(),.se_5_16(),.ze_5_16(),.ze_8_16(),.clk(clk),.rst(rst),.PCAddSel(),.PCImmSel(), aluSrc());

   memory proc_m(mem_data(),.alu_res_out(),.alu_cond_out(),.pc_inc_out(),.mem_read(),.mem_write(),.alu_cond_in(),.alu_res_in(),.pc_inc_in(),.data_in(),.instr(),.halt(),.writeDataSel(),.clk(clk),.rst(rst));

   wb proc_wb(.reg_write_data(),.pc_inc_in(),.alu_res_in(),.mem_data(),.alu_cond_in(),.clk(clk),.rst(rst));
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
