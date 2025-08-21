module reset_checker(
    input clk,
    input bus,
    input en_check,
    output reg reset_found
);
integer counter =0;
reg decided_about_reset=0;
//checks at the middle of the 480us
always @(posedge clk)begin

if(en_check==1'b1) begin
    if(counter==240)begin
        if(bus==1'b0)begin
            decided_about_reset=1'b1;
        end
        else begin
            decided_about_reset=1'b0;
        end
        counter<=counter+1;
    end
    else begin
        counter<=counter+1;
    end

    if(counter==480)begin
        if(decided_about_reset)begin
            reset_found<=1'b1;
        end
        else begin
            reset_found<=1'b0;
        end
        counter<=0;
        decided_about_reset<=0;
    end

end



end









endmodule