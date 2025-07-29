module eight_bit_shift_left_reg(input clk, input serial_in, output serial_out);
reg [7:0] tmp;
always@(posedge clk)begin
tmp[0]<=serial_in;
tmp<=tmp<<1;



end
assign serial_out=tmp[7];


endmodule
