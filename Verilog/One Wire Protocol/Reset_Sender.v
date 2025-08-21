module reset_sender(
    input clk,
    input en_send_reset,
    output reg master_pull_low,
    output reg done_sending_reset,
    input bus
);

integer counter =0;
//it simply should hold the bus low for 480us, then wait for 15us
always@(posedge clk)begin
    if(en_send_reset)begin
        done_sending_reset<=1'b0;
        if(counter<480)begin
            master_pull_low<=1'b1;
           counter<=counter+1;
        end

        else begin
            done_sending_reset<=1'b1;
            counter<=0;
         
        end

    end
end





















endmodule
