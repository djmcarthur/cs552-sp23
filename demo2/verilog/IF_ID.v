`default_nettype none
module IF_ID(
    IF_ID_instr,
    instr,
    clk, rst);

    input wire clk, rst;

    // data
    output wire [15:0] IF_ID_instr;

    //data
    input wire [15:0] instr;


    // data
    dff inst_reg [15:0] (.q(IF_ID_instr), .d(rst ? {5'b00001, 11'b0} : instr), .clk(clk), .rst('0));


endmodule
`default_nettype wire
