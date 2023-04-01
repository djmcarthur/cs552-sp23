/*
    module describes a 16 bit register
*/

module register(read_data, write_data, write_en, clk, rst);

input [15:0] write_data;
input write_en, clk, rst;
output [15:0] read_data;

wire [15:0] dff_in;

dff ff0(.q(read_data[0]),  .d(dff_in[0]),  .clk(clk), .rst(rst));
dff ff1(.q(read_data[1]),  .d(dff_in[1]),  .clk(clk), .rst(rst));
dff ff2(.q(read_data[2]),  .d(dff_in[2]),  .clk(clk), .rst(rst));
dff ff3(.q(read_data[3]),  .d(dff_in[3]),  .clk(clk), .rst(rst));
dff ff4(.q(read_data[4]),  .d(dff_in[4]),  .clk(clk), .rst(rst));
dff ff5(.q(read_data[5]),  .d(dff_in[5]),  .clk(clk), .rst(rst));
dff ff6(.q(read_data[6]),  .d(dff_in[6]),  .clk(clk), .rst(rst));
dff ff7(.q(read_data[7]),  .d(dff_in[7]),  .clk(clk), .rst(rst));
dff ff8(.q(read_data[8]),  .d(dff_in[8]),  .clk(clk), .rst(rst));
dff ff9(.q(read_data[9]),  .d(dff_in[9]),  .clk(clk), .rst(rst));
dff ffA(.q(read_data[10]), .d(dff_in[10]), .clk(clk), .rst(rst));
dff ffB(.q(read_data[11]), .d(dff_in[11]), .clk(clk), .rst(rst));
dff ffC(.q(read_data[12]), .d(dff_in[12]), .clk(clk), .rst(rst));
dff ffD(.q(read_data[13]), .d(dff_in[13]), .clk(clk), .rst(rst));
dff ffE(.q(read_data[14]), .d(dff_in[14]), .clk(clk), .rst(rst));
dff ffF(.q(read_data[15]), .d(dff_in[15]), .clk(clk), .rst(rst));

assign dff_in = write_en ? write_data : read_data;

endmodule