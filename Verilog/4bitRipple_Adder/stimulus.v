`timescale 1ps/1ps
`include "4BitAdder.v"
module stimulus;

reg [3:0] A,B;
reg C_IN;
wire [3:0] Sum;
wire C_out;
Ripple_Adder r0(A,B,C_IN,Sum,C_out);
initial begin
    
#5 A = 4'd0; B = 4'd0; C_IN = 4'b0;
#5 A = 4'd3; B = 4'd4; C_IN = 4'b0;
#5 A = 4'd2; B = 4'd5; C_IN = 4'b0;
#5 A = 4'd9; B = 4'd9; C_IN = 4'b1;

end




endmodule
