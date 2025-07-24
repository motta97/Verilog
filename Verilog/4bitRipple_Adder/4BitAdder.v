`include "FullAdder.v"
module Ripple_Adder( input [3:0] a,input [3:0]b,input cin,output [3:0]sum,cout);


wire c1,c2,c3;
FullAdder fa0(.sum(sum[0]), .a(a[0]),.b(b[0]),.cin(cin),.cout(c1));
FullAdder fa1(.sum(sum[1]), .a(a[1]),.b(b[1]),.cin(c1),.cout(c2));
FullAdder fa2(.sum(sum[2]), .a(a[2]),.b(b[2]),.cin(c2),.cout(c3));
FullAdder fa3(.sum(sum[3]), .a(a[3]),.b(b[3]),.cin(c3),.cout(cout));
endmodule
