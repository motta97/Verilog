module d_ff(input clk, input D,input rst, output reg Q, output reg Q_bar);


always @(*) Q_bar = ~ Q;
always @(posedge clk) begin

    if(rst) Q <=1'b0;
    else Q<=D;



end








endmodule
