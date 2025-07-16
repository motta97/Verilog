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
module stiumuls_to_mux;
reg IN0, IN1, IN2, IN3, S0, S1;
wire OUT;



mux4_to_1 my_mux(.in0(IN0), .in1(IN1), .in2(IN2), .in3(IN3), .s0(S0), .s1(S1), .out(OUT));


initial begin
IN0 = 1;
IN1 = 0;
IN2 = 1;
IN3 = 0;

S0= 0; S1=1;
S0= 0;
S1=1;
//choose IN0
  #1 $display ("S1 = %b, S0 = %b, OUTPUT  = %b",S1 ,S0,OUT);
 // choose IN1 
  S1 = 0; S0 = 1; 
  #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT); 
  // choose IN2 
  S1 = 1; S0 = 0; 
  #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT); 
  // choose IN3 
  S1 = 1; S0 = 1; 
  #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT); 

end

endmodule
