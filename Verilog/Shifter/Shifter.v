module shifter(
    input clk,
    input load,
    input right,
    input left,
    input [4:0] in_value,
    input rst_n,
    output reg [4:0] out_value
    );



always @(posedge clk) begin
if(rst_n) begin 
        if(!load)
            begin
            if(right) out_value <=in_value>>1;
            else if (left) out_value <=in_value<<1;

            end
        else out_value <= in_value;


        end
else out_value = 5'b00000;
end





endmodule
