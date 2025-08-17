module MUX(
    input [1:0]a,
    input [2:0]b,
    input sel,
    output reg signed [2:0] out
);

always@(*)begin

    case(sel)
        
        1'b0: out =b;
        1'b1: out = a;
        default: out = 3'b000;
    endcase

end
endmodule