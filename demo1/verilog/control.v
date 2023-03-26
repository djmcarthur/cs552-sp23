/*
 *  Control logic for cs552 sp23 project
 */
`default_nettype none
module control (alu_op, alu_src, halt, invA, invB, jal, writeRegSel, writeDataSel, pc_add_sel, pc_imm_sel, mem_en, mem_wr, pc_sel, instr);

   output reg [3:0]  alu_op;                      // alu operation code
   output reg [2:0]  alu_src;                     // choose operand B for alu
   output reg 	     halt, invA, invB, jal;      
   output reg [1:0]  writeRegSel;                 // write register select for rf
   output reg [1:0]  writeDataSel;                // write data for rf
   output reg 	     pc_add_sel, pc_imm_sel;      // Selects for new PC calc operands
   output reg 	     mem_en, mem_wr;              // Controls for mem
   output reg 	     pc_sel;                      // PC+2 or branch address
   
   
   input wire [15:0] instr;


    always @ (*) begin

        /* fetch control
        halt = 0;
        //decode control
        reg_write_en = 0;
        reg_write_reg_sel = 2'b00;
        rs = 1'b0;
        jump = 1'b0;
        // execute control
        swap = 1'b0;
        alu_op = 4'b0000;
        alu_cond_sel = 4'b0000;
        alu_b_sel = 3'b000;
        invA = 1'b0;
        invB = 1'b0;
        sign = 1'b0;
        Cin = 1'b0;
        br = 1'b0;
        br_type = 2'b00;
        pc_a_sel = 1'b1;
        pc_b_sel = 1'b0;
        // memory control
        mem_write = 1'b0;
        mem_read = 1'b0;
        // writeback control
        reg_write_data_sel = 2'b00;
	 */
    
	casex(instr[15:11])
            5'b00000: begin // HALT
	       // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b00001: begin // NOP 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

	     5'b01000: begin // ADDI ✅
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;          
	    end

            5'b01001: begin // SUBI ✅
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b01010: begin // XORI ✅
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b01011: begin // ANDNI  ✅
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b10100: begin // ROLI ✅
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end
            5'b10101: begin // SLLI ✅
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end
            5'b10110: begin // RORI 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end
            5'b10111: begin // SRLI 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b10000: begin // ST 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0; 
            end

            5'b10001: begin // LD 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b10011: begin // STU 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b11001: begin // BTR 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b11011: begin // ADD, SUB, XOR, ANDN
                casex(instr[1:0])
                    2'b00: begin //ADD 
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                    2'b01: begin //SUB 
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                    2'b10: begin //XOR 
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                    2'b11: begin //ANDN 
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                endcase
            end

            5'b11010: begin 
                casex(instr[1:0]) 
                    2'b00: begin // SLL ✅
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                    2'b01: begin // SRL ✅
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                    2'b10: begin // ROL ✅
                        // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                    2'b11: begin // ROR ✅
                       // fetch control
		       halt = 1'b1;
		       pc_sel = 1'b0;
		       // decode control
		       writeRegSel = 2'd0;
		       // execute control
		       pc_add_sel = 1'b0;
		       pc_imm_sel = 1'b0;
		       invA = 1'b0;
		       invB = 1'b0;
		       alu_op = 4'd0;
		       alu_src = 4'd0;
		       jal = 1'b0;
		       // mem control
		       mem_en = 1'b0;
		       mem_wr = 1'b0;
		       // wb control
		       writeDataSel = 2'd0;
                    end
                endcase
            end

            5'b11100: begin // SEQ 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b11101: begin // SLT 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b11110: begin // SLE 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b11111: begin // SCO 
               // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b01100: begin // BEQZ 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b01101: begin // BNEZ 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b01110: begin // BLTZ 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b01111: begin // BGEZ 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b11000: begin // LBI 
                // fetch control
               halt = 1'b0;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd2;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd3;
            end

            5'b10010: begin // SLBI 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b00100: begin // J disp 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b00101: begin // JR 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b00110: begin // JAL 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

            5'b00111: begin // JALR 
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

	    5'b00010: begin // siic (Do nothing)
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
	    end

            5'b00011: begin // nop/rti (Do nothing)
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

	    default: begin
                // fetch control
               halt = 1'b1;
               pc_sel = 1'b0;
	       // decode control
	       writeRegSel = 2'd0;
	       // execute control
               pc_add_sel = 1'b0;
	       pc_imm_sel = 1'b0;
	       invA = 1'b0;
	       invB = 1'b0;
	       alu_op = 4'd0;
	       alu_src = 4'd0;
	       jal = 1'b0;
	       // mem control
	       mem_en = 1'b0;
	       mem_wr = 1'b0;
	       // wb control
	       writeDataSel = 2'd0;
            end

	endcase
    end
   


endmodule
`default_nettype wire
