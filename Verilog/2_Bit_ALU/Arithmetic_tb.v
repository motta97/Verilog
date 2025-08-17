`timescale 1ps/1ps
module Arithmetic_tb;

reg [1:0] a_in;
reg [1:0] b_in;
reg [2:0]sel;
wire signed [2:0] out;

Arith_unit a1(a_in,b_in,sel,out);


initial begin
    a_in=2'b10;
    b_in=2'b10;
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