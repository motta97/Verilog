`timescale 1ps/1ps
module mux_tb;

reg [1:0] a_in;
reg [2:0] b_in;
reg sel;
wire [2:0] out;

MUX mux(a_in,b_in,sel,out);


initial begin
     a_in=2'b11;
     b_in=2'b01;
    sel=1'b0;
    #10 sel=1'b1;
    #10 sel=1'bz;
    #10
    $finish;


end







endmodule