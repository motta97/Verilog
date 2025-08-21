module precence_replier(
    input clk,
     input bus,
     output reg slave_pull_low,
    input en_precence,
    output reg done_precence
);
integer counter = 0;
always@(posedge clk)begin
if(en_precence==1'b1)begin

if(counter <=15) begin
slave_pull_low<=1'b0;

counter<=counter +1;
done_precence<=1'b0;
end
else if(counter <=85)begin //85 =60+15
slave_pull_low<=1'b0;
counter<=counter +1;
done_precence=1'b0;
end
else begin
counter=0;
done_precence=1'b1;
end







end






end






endmodule