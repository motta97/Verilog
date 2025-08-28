module send_frame(
    input clk,
    input en_send_frame,
    input [11:0]frame,
    output reg done_sending_frame,
    output reg data_out
);
integer counter =0;


always@(posedge clk)begin
if(en_send_frame)begin
    if(counter<12)begin
        done_sending_frame<=1'b0;
        data_out<=frame[counter];
        counter<=counter+1;
    end
    else begin
    done_sending_frame<=1'b0;
    data_out<=1'b0;
    counter<=counter+1;
    end

    if(counter==100)begin
    counter<=1'b0;
    done_sending_frame<=1'b1;
    end
    end
end







endmodule