module FullAdder(a,b,cin,sum,cout);


input a, b, cin;
output sum, cout;

wire s1,s2, c1;

xor(s1,a,b);
xor(sum,s1,cin);
and(c1,a,b);
and(s2,s1,cin);
or(cout,s2,c1);


endmodule
