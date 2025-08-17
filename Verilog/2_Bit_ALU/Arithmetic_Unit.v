module Arith_unit(
    input [1:0]a,
    input [1:0]b,
    input [2:0] sel,
    output reg signed [2:0]out
);

always@(*)begin

  
        case(sel)

        3'b000: out=a;
        3'b001: out=a+b;
        3'b010: out = b-1;
        3'b011: out= a>b? (a-b) :(b-a);
        3'b100: out = b*2;
        3'b101: out = a/2;
        3'b110: out = a+1;
        3'b111: out = b;
        default: out=3'b000;
    endcase


end

endmodule