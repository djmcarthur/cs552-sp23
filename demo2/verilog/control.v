/*
   CS/ECE 552 Spring '20
  
   Filename        : control.v
   Description     : This is the module for decoding the opcode of the processor instruction.
*/
`default_nettype none
module control(halt, Cin, br, br_type, sign, reg_write_data_sel, reg_write_reg_sel, invA, invB, swap, pc_a_sel, pc_b_sel, alu_b_sel, alu_cond_sel, 
                alu_op, mem_read, mem_write, reg_write_en, instr, jump, rs, jal, rst, sel_pc_new);

    output reg halt, br, sign, Cin, invA, invB, swap, pc_a_sel, pc_b_sel, rs, jal, sel_pc_new;
    /*
        halt: 1 halt, 0 else
        br: 1 to branch, 0 not
        sign: 1 if signed? 0 if not
        Cin: 1 if theres carry in, 0 else
        invA: 1 to invert A, 0 else
        invB; same as above
        swap: 1 to swap operands, 0 else
        pc_a_sel: 1 = read data 1 from pc_inc, 0 if data 1 from rf
        pc_b_sel: 1 = sign_ext_11_16 : 0 = sign_ext_8_16

    */
    output reg mem_read, mem_write, reg_write_en; //mem_read 1 for x 0 for x
    output reg [1:0] reg_write_data_sel; // 00: memory data  01: alu_res   10: alu_cond   11: pc_inc
    output reg [1:0] reg_write_reg_sel; // 00: [10:8]  01: [7:5]   10: [4:2]   11: R7
    output reg [1:0] br_type;   // 00 : equal  01: not equal  10: less than  11: greater than
    output reg [2:0] alu_b_sel; // 000 : 16'0 001: read dateR7a 2 010 : SE_8_16 011 : SE_5_16 100 : ZE_5_16
    output reg [3:0] alu_op;    /* See below
        (Oper == 4'd0) ? shift_out  :  rol
	    (Oper == 4'd1) ? shift_out  :
		(Oper == 4'd2) ? shift_out  :
		(Oper == 4'd3) ? shift_out  :
		(Oper == 4'd4) ? add_out    :
		(Oper == 4'd5) ? and_out    :
		(Oper == 4'd6) ? or_out     :
		(Oper == 4'd7) ? xor_out    :
		(Oper == 4'd8) ? sco_out    :
		(Oper == 4'd9) ? slbi_out   :
		(Oper == 4'd10) ? btr_out   :
		(Oper == 4'd11) ? slt_out   :
		(Oper == 4'd12) ? lbi_out   :
		(Oper == 4'd13) ? sle_out   :
		(Oper == 4'd14) ? seq_out   :
		(Oper == 4'd15) ? sub_out   :
		InA;
    */
    output reg [3:0] alu_cond_sel;  // comparator conditions
    output reg jump;

    input wire [15:0] instr;
    input wire 	      rst;
   

//halt, Cin, br, br_type, sign, reg_write_data_sel, reg_write_reg_sel, invA, invB, swap, pc_a_sel, pc_b_sel, alu_b_sel, alu_cond_sel, 
        //        alu_op, mem_read, mem_write, reg_write_en, instr, jump, rs);
    always @(*) begin

        // fetch control
        sel_pc_new = 1'b0;
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
        jal = 0;
    
	casex(instr[15:11])
            5'b00000: begin // HALT ✅
                halt = rst ? 1'b0 : 1'b1;
                br = 1'b0;
                pc_a_sel = 1'b0;
                reg_write_data_sel = 1'b0;
                alu_op = 4'b0000;
                mem_read = 1'b0;
                mem_write = 1'b0;
                Cin = 1'b0;
                alu_b_sel = 3'b000;
                alu_cond_sel = 4'b0000;
            end

            5'b00001: begin // NOP ✅
                halt = 1'b0;
                br = 1'b0;
                pc_a_sel = 1'b0;
                reg_write_data_sel = 1'b0;
                alu_op = 4'b0000;
                mem_read = 1'b0;
                mem_write = 1'b0;
                Cin = 1'b0;
                alu_b_sel = 3'b000;
                alu_cond_sel = 4'b0000;
                reg_write_data_sel = 2'b01;
            end

	       5'b01000: begin // ADDI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd4;   // add
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b01; //instr[7:5]
                alu_b_sel = 3'b011;  // sign extend 5 16
                alu_cond_sel = 4'b0000; // dont care 
                reg_write_en = 1'b1;             
	       end

            5'b01001: begin // SUBI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd4;   // add
                mem_read = 1'b0;
                Cin = 1;
                swap = 1;
                invB = 1;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b01; //instr[7:5]
                alu_b_sel = 3'b011;  // zero extend 5 16
                alu_cond_sel = 4'b0000; // dont care 
                reg_write_en = 1;

            end

            5'b01010: begin // XORI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd7;   // xor
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b01; //instr[7:5]
                alu_b_sel = 3'b111;  // zero extend 5 16
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1;
            end

            5'b01011: begin // ANDNI  ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd5;   // and
                invB = 1; // not imm
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b01; //instr[7:5]
                alu_b_sel = 3'b111;  // zero extend 5 16
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1;
            end

            5'b10100: begin // ROLI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd0; // rol
                mem_read = 1'b0; // we aint readin or writin
                mem_write = 1'b0;
                reg_write_reg_sel = 2'b01; // instr[7:5]
                alu_b_sel = 3'b100; // zero ex imm
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1;
            end

            5'b10101: begin // SLLI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd1; // sll
                mem_read = 1'b0; // we aint readin or writin
                mem_write = 1'b0;
                reg_write_reg_sel = 2'b01; // instr[7:5]
                alu_b_sel = 3'b100; // zero ex imm
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1;
            end

            5'b10110: begin // RORI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd2; // ror
                mem_read = 1'b0; // we aint readin or writin
                mem_write = 1'b0;
                reg_write_reg_sel = 2'b01; // instr[7:5]
                alu_b_sel = 3'b100; // zero ex imm
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1;
            end
            5'b10111: begin // SRLI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd3; // srl
                mem_read = 1'b0; // we aint readin or writin
                mem_write = 1'b0;
                reg_write_reg_sel = 2'b01; // instr[7:5]
                alu_b_sel = 3'b100; // zero ex imm
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1;
            end

            5'b10000: begin // ST ✅
                reg_write_data_sel = 2'b00; // alu res
                mem_read = 1'b1; //read
                mem_write = 1'b1; //write too
                alu_op = 4'd4;   // add
                sign = 1;
                reg_write_reg_sel = 2'b01; //instr[7:5]
                alu_b_sel = 3'b011;  // sign extend 5 16
                alu_cond_sel = 4'b0000; // dont care 
            end

            5'b10001: begin // LD ✅
                reg_write_data_sel = 2'b00; // memory data
                mem_read = 1'b1; //read
                mem_write = 1'b0; //don't write
                alu_op = 4'd4;   // add
                reg_write_reg_sel = 2'b01; //instr[7:5]
                sign = 1;
                alu_b_sel = 3'b011;  // sign extend 5 16
                alu_cond_sel = 4'b0000; // dont care 
                reg_write_en = 1;   //write back
            end

            5'b10011: begin // STU ✅
                reg_write_data_sel = 2'b01; // alu res
                mem_read = 1'b1; //read
                mem_write = 1'b1; //write too
                alu_op = 4'd4;   // add
                sign = 1;
                alu_b_sel = 3'b011;  // sign extend 5 16
                alu_cond_sel = 4'b0000; // dont care 
                reg_write_en = 1; 
            end

            5'b11001: begin // BTR ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd10; // btr
                mem_read = 1'b0; // we aint readin or writin
                mem_write = 1'b0;
                reg_write_en = 1; //write
                reg_write_reg_sel = 2'b10; // instr[4:2]
            end

            5'b11011: begin // ADD, SUB, XOR, ANDN
                casex(instr[1:0])
                    2'b00: begin //ADD ✅
                        reg_write_data_sel = 2'b01; //alu res
                        alu_op = 4'b0100; //add
                        mem_read = 1'b0; //don't read or write
                        mem_write = 1'b0;
                        reg_write_en = 1; //write to reg
                        Cin = 1'b0;
                        reg_write_reg_sel = 2'b10; //instr[4:2]
                        alu_b_sel = 3'b001; //take reg 2 as alu in
                        alu_cond_sel = 4'b0000; //dont care
                    end
                    2'b01: begin //SUB ✅
                        reg_write_data_sel = 2'b01; //alu res
                        swap = 1; //swap for sub
                        alu_op = 4'b1111; //SUB
                        mem_read = 1'b0; //don't read or write
                        mem_write = 1'b0;
                        reg_write_en = 1; //write to reg
                        invB = 1;
                        Cin = 1; 
                        reg_write_reg_sel = 2'b10; //instr[4:2]
                        alu_b_sel = 3'b001; //take reg 2 as alu in
                        alu_cond_sel = 4'b0000; //dont care
                    end
                    2'b10: begin //XOR ✅
                        reg_write_data_sel = 2'b01; //alu res
                        alu_op = 4'b0111; //XOR
                        mem_read = 1'b0; //don't read or write
                        mem_write = 1'b0;
                        reg_write_en = 1; //write to reg
                        reg_write_reg_sel = 2'b10; //instr[4:2]
                        alu_b_sel = 3'b001; //take reg 2 as alu in
                        alu_cond_sel = 4'b0000; //dont care
                    end
                    2'b11: begin //ANDN ✅
                        reg_write_data_sel = 2'b01; //alu res
                        alu_op = 4'b0101; //and
                        mem_read = 1'b0; //don't read or write
                        mem_write = 1'b0;
                        invB = 1; //not b
                        reg_write_en = 1; //write to reg
                        reg_write_reg_sel = 2'b10; //instr[4:2]
                        alu_b_sel = 3'b001; //take reg 2 as alu in
                        alu_cond_sel = 4'b0000; //dont care
                    end
                endcase
            end

            5'b11010: begin 
                casex(instr[1:0]) 
                    2'b10: begin // ROL ✅
                        reg_write_data_sel = 2'b01; // alu res
                        alu_op = 4'd0; // rol
                        mem_read = 1'b0; // we aint readin or writin
                        mem_write = 1'b0;
                        reg_write_reg_sel = 2'b10; // instr[4:2]
                        alu_b_sel = 3'b001; // read data
                        alu_cond_sel = 4'b0000; // dont care
                        reg_write_en = 1;
                    end
                    2'b00: begin // SLL ✅
                        reg_write_data_sel = 2'b01; // alu res
                        alu_op = 4'd1;   // sll
                        mem_read = 1'b0;
                        mem_write = 1'b0; // no read or write
                        reg_write_reg_sel = 2'b10; //instr[4:2]
                        alu_b_sel = 3'b001;  // read data
                        alu_cond_sel = 4'b0000; // dont care
                        reg_write_en = 1;
                    end
                    2'b11: begin // ROR ✅
                        reg_write_data_sel = 2'b01; // alu res
                        alu_op = 4'd2; // ror
                        mem_read = 1'b0; // we aint readin or writin
                        mem_write = 1'b0;
                        reg_write_reg_sel = 2'b10; // instr[4:2]
                        alu_b_sel = 3'b001; // read data
                        alu_cond_sel = 4'b0000; // dont care
                        reg_write_en = 1;
                    end
                    2'b01: begin // SRL ✅
                        reg_write_data_sel = 2'b01; // alu res
                        alu_op = 4'd3; // srl
                        mem_read = 1'b0; // we aint readin or writin
                        mem_write = 1'b0;
                        reg_write_reg_sel = 2'b10; // instr[4:2]
                        alu_b_sel = 3'b001; // read data
                        alu_cond_sel = 4'b0000; // dont care
                        reg_write_en = 1;
                    end
                endcase
            end

            5'b11100: begin // SEQ ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd14;   // eq
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b10; //instr[4:2]
                alu_b_sel = 3'b001;  // read data
                alu_cond_sel = 4'b0000; // no
                sign = 1'b1; // sign matters
                reg_write_en = 1;
            end

            5'b11101: begin // SLT ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd11;   // slt
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b10; //instr[4:2]
                alu_b_sel = 3'b001;  // read data
                alu_cond_sel = 4'b0000; // no
                sign = 1'b1; // sign matters
                Cin = 1; //subtract
                //invB = 1; //subtract
                reg_write_en = 1;
            end

            5'b11110: begin // SLE ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd13;   // sle
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b10; //instr[4:2]
                alu_b_sel = 3'b001;  // read data
                alu_cond_sel = 4'b0000; // no
                Cin = 1; //subtract
                //invB = 1; //subtract
                reg_write_en = 1;
            end

            5'b11111: begin // SCO ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd8;   // sco
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                reg_write_reg_sel = 2'b10; //instr[4:2]
                alu_b_sel = 3'b001;  // read data
                alu_cond_sel = 4'b0000; // no
                sign = 1'b1; // sign matters
                reg_write_en = 1;
            end

            5'b01100: begin // BEQZ ✅
                br = 1'b1; // take branch
                br_type = 2'b00; //equal to
            end

            5'b01101: begin // BNEZ ✅
                br = 1'b1; // take branch
                br_type = 2'b01; //not equal to
            end

            5'b01110: begin // BLTZ ✅
                br = 1'b1; // take branch
                br_type = 2'b10; //less than
            end

            5'b01111: begin // BGEZ ✅
                br = 1'b1; // take branch
                br_type = 2'b11; //greater than
            end

            5'b11000: begin // LBI ✅
                reg_write_data_sel = 2'b01;// alu res
                alu_op = 4'b1100; // s
                mem_read = 1'b0;
                mem_write = 1'b0;
                Cin = 1'b0;
                alu_b_sel = 3'b010;
                alu_cond_sel = 4'b0000;
                reg_write_en = 1'b1;
            end

            5'b10010: begin // SLBI ✅
                reg_write_data_sel = 2'b01; // alu res
                alu_op = 4'd9; // slbi
                mem_read = 1'b0;
                mem_write = 1'b0; // no read or write
                alu_b_sel = 3'b010;  // dont care here
                alu_cond_sel = 4'b0000; // dont care
                reg_write_en = 1; //write
            end

            5'b00100: begin // J disp ✅
	       sel_pc_new = 1'b1;
                jump = 1; // we jump
                pc_a_sel = 1'b1; // pc_inc
                pc_b_sel = 1'b1; // se 11 bit imm
                reg_write_data_sel = 2'b00; // dont care
                alu_op = 3'b000; // dont care
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_b_sel = 3'b110; // dont care
                alu_cond_sel = 4'b0000;
            end

            5'b00101: begin // JR ✅
	       sel_pc_new = 1'b1;
                halt = 1'b0;
                br = 1'b0;
                jump = 1; // jumping
                pc_a_sel = 1'b0;
                reg_write_data_sel = 1'b0;
                alu_op = 3'b000;
                mem_read = 1'b0;
                mem_write = 1'b0;
                Cin = 1'b0;
                alu_b_sel = 3'b010;
                alu_cond_sel = 4'b0000;
            end

            5'b00110: begin // JAL ✅
	       sel_pc_new = 1'b1;
                jal = 1;
                jump = 1;
                reg_write_en = 1; // write reg
                pc_a_sel = 1'b1;
                pc_b_sel = 1;
                reg_write_data_sel = 2'b11; // PC + 2
                alu_op = 3'b000; // X
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write_reg_sel = 2'b11; // R7
                alu_b_sel = 3'b000; // X
                alu_cond_sel = 4'b0000; // X
            end

            5'b00111: begin // JALR ✅
	       sel_pc_new = 1'b1;
                jal = 1;
                jump = 1; // we jump
                rs = 1;
                reg_write_en = 1; // write reg
                pc_a_sel = 1'b1; // pc_inc
                pc_b_sel = 1'b0; // 8 bit sign extend
                reg_write_data_sel = 2'b11; // pc + 2
                alu_op = 4'd4; // add
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write_reg_sel = 2'b11; // R7
                alu_b_sel = 3'b010; // sign ext 8_16
                alu_cond_sel = 4'b0000;
            end

	    5'b00010: begin // siic (Do nothing)
                br = 1'b0;
                pc_a_sel = 1'b0;
                reg_write_data_sel = 1'b0;
                alu_op = 3'b000;
                mem_read = 1'b0;
                mem_write = 1'b1;
                Cin = 1'b0;
                alu_b_sel = 3'b000;
                alu_cond_sel = 4'b0000;
	    end

            5'b00011: begin // nop/rti (Do nothing)
                br = 1'b0;
                pc_a_sel = 1'b0;
                reg_write_data_sel = 1'b0;
                alu_op = 3'b000;
                mem_read = 1'b0;
                mem_write = 1'b0;
                Cin = 1'b0;
                alu_b_sel = 3'b000;
                alu_cond_sel = 4'b0000;
            end

	    default: begin
                halt = 1'b0;
                br = 1'b0;
                pc_a_sel = 1'b0;
                reg_write_data_sel = 1'b0;
                alu_op = 3'b000;
                mem_read = 1'b0;
                mem_write = 1'b0;
                Cin = 1'b0;
                reg_write_reg_sel = 2'b00;
                alu_b_sel = 3'b000;
                alu_cond_sel = 4'b0000;
            end

	endcase
    end

endmodule
`default_nettype wire
