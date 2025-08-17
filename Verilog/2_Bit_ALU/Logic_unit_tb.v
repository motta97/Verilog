`timescale 1ps/1ps
module logic_tb;

reg [1:0] a_in;
reg [1:0] b_in;
reg [2:0]sel;
wire [1:0] out;

Logic_Unit log(a_in,b_in,sel,out);


initial begin
    a_in=2'b00;
    b_in=2'b00;
    sel=3'b000;
    #10 sel=3'b001;
    #10 sel=3'b010;
    #10 sel=3'b011;
    #10 sel=3'b100;
    #10 sel=3'b101;
    #10 sel=3'b110;
    #10 sel=3'b111;
    #10 sel=3'bzzz;
    $finish;


end







endmodule