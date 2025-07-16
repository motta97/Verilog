module mux4_to_1(out,in0,in1,in2,in3,s0,s1)


input in0,in1,in2,in3,s0,s1;
output out;

wire y0,y1,y2,y3;
wire s0n,s1n;

//logic

not (s0n,s0);
not (s1n,s1);


and (y0,in0,s0n,s1n);
and (y1, in1, s0,s1n);
and (y2, in2, s1, s0n);
and (y3, in3, s1, s0);

or(out, y0, y1, y2, y3);


endmodule
