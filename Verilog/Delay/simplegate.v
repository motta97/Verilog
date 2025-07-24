`timescale 1ps/1ps
module simple_gate(input a, input b,input c, output o);

wire w;
and #(5,7)  (w, a, b);
or #(4,5) (o,c,w);

endmodule
