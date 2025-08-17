module Logic_Unit(
    input [1:0]a,
    input [1:0]b,
    input [2:0] sel,
    output reg  [1:0]out
);



always@(*)begin

  case(sel)

        3'b000: out=~a;
        3'b001: out=(~b)+1;
        3'b010: out = a &b;
        3'b011: out = ~(a^b);
        3'b100: out = ~(a&b);
        3'b101: out = a^b;
        3'b110: out = a|b;
        3'b111: out = ~(a|b);
        default: out =2'b00;
    endcase

end

endmodule