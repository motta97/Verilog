module precence_waiter(
    input clk,
    input bus,
    input en_wait_precence,
    output reg master_pull_low,
    output reg done_wait_precence,
    output reg found_precence
);


integer counter = 0;
reg decided_about_precence;

always@(posedge clk)begin

    if(en_wait_precence)begin
        //wait for 15us
        if(counter<15)begin
            master_pull_low<=1'b0;
            counter<=counter+1;
        end
        else if(counter==45)begin
            if(bus==1'b0)begin
                decided_about_precence<=1'b1;
            end
            else begin
                decided_about_precence<=1'b0;
                
            end
        end

        if(counter==86)begin//60+15+1(margin)
            if(decided_about_precence)begin
                found_precence<=1'b1;
            end
            else begin
                found_precence<=1'b0;
            end
            counter<=0;
            done_wait_precence<=1'b1;
        end
    end

    end

endmodule
