module rate_match(
    input clk,
    input en_rate_matching_check,
    output reg done_rate_matching
);
integer counter=0;


always@(posedge clk)begin

if(en_rate_matching_check)begin

    if(counter<88)begin
        done_rate_matching<=1'b0;
        counter<=counter+1;
    end
    else begin
        done_rate_matching<=1'b1;
        counter<=0;
    end





end






end
endmodule