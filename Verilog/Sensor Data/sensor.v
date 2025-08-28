module sensor(
    input reset,
    input clk,
    input [7:0 ]data_in,
    output reg data_out,
    output reg data_valid
);
reg [11:0]frame;
integer counter =0;
integer counter2=0;
always@(posedge clk or posedge reset)begin

    if(reset)begin
     
        counter <=0;
        frame[2:0]<=3'b101;
        frame[10:3]<=data_in;
        frame[11]<=^data_in;
    end
    else begin

        if(counter==100)begin
            frame[2:0]<=3'b101;
            frame[10:3]<=data_in;
            frame[11]<=^data_in;
            counter<=0;
        end
        else begin
            counter<=counter+1;
        end

    end

end
always@(posedge clk)begin

if(counter2<12)begin
    counter2<=counter2+1;
    data_out<=frame[counter2];
    data_valid<=1'b1;
end

else begin
counter2<=counter2+1;
data_valid<=1'b0;
end

if(counter2==100)begin
counter2<=1'b0;
end




end










endmodule
