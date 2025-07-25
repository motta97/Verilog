module serializer (
    input clk,
    input load,
    input [7:0]in_value,
    output reg o_bit
);

    reg [7:0] internal_reg;

    always@(posedge clk)
    begin
        if(load)
            begin
                internal_reg =in_value;
            end
        else
            begin
                o_bit = internal_reg[7];
                internal_reg = internal_reg<<1;
            end

    end

endmodule
