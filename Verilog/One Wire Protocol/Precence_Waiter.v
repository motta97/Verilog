module precence_waiter(
    input clk,
    inout bus,
    input en_wait_precence,
    output reg done_wait_precence,
    output reg found_precence
);
reg drive_bus;

integer counter = 0;
reg decided_about_precence;
initial begin
assign drive_bus=bus;

end

always@(posedge clk)begin

    if(en_wait_precence)begin
        //wait for 15us
        if(counter<15)begin
            drive_bus<=1'bz;
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