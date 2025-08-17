module top_module (
    input [1:0] a_in,
    input [1:0] b_in,
    input [3:0] sel,
    output reg signed [2:0] y_out 
);

 wire [1:0] logic_unit_out;
 wire [2:0] arith_unit_out;
wire [2:0] y_out_wire;

Logic_Unit logic1(a_in,b_in,sel[2:0],logic_unit_out);
Arith_unit ar1(a_in,b_in,sel[2:0],arith_unit_out);
MUX mux(logic_unit_out,arith_unit_out,sel[3],y_out_wire);
always@(*)begin
y_out=y_out_wire;

end

endmodule
