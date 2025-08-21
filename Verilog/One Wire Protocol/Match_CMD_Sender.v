module match_cmd_sender(
    input clk,
    input en_match_rom,
    output reg master_pull_low,
    output reg done_matching_rom,
    input bus
);
integer counter =0;
//55-->01010101

always@(posedge clk)begin

if(en_match_rom)begin
done_matching_rom<=1'b0;
//send 0
if(counter<60)begin
    master_pull_low<=1'b1;
    counter<=counter+1;
end
else if(counter<71)begin
    counter<=counter+1;
   master_pull_low<=1'b0;
end
//send 1
else if(counter<131)begin//71+60

    counter<=counter+1;
   master_pull_low<=1'b0;

end
else if(counter<142)begin
    counter<=counter+1;
    master_pull_low<=1'b0;
end
//send 0
else if(counter<202)begin
    master_pull_low<=1'b1;
    counter<=counter+1;
end
else if(counter<213)begin
    master_pull_low<=1'bz;
    counter<=counter+1;
end
//send 1
else if(counter<273)begin
    master_pull_low<=1'b0;
    counter<=counter+1;
end
else if(counter<284)begin
    master_pull_low<=1'b0;
    counter<=counter+1;
end
//send0
else if(counter<344)begin
    counter<=counter+1;
    master_pull_low<=1'b0;
end
else if(counter<355)begin
    counter<=counter+1;
    master_pull_low<=1'b0;
end
//send1
else if(counter<415)begin
    counter<=counter+1;
    master_pull_low<=1'b0;
end
else if(counter<426)begin
    counter<=counter+1;
    master_pull_low<=1'b0;
end
//send 0
else if(counter<486)begin
    master_pull_low<=1'b1;
    counter<=counter+1;
end
else if(counter<497)begin
    master_pull_low<=1'b0;
    counter<=counter+1;
end
//send1
else if(counter<557)begin
    master_pull_low<=1'b0;
    counter<=counter+1;
end
else if(counter<568)begin
    master_pull_low<=1'b0;
    counter<=counter+1;
end
else begin
counter<=counter+1;
end
if(counter==568)begin
counter<=0;
done_matching_rom<=1'b1;
end

end








end








endmodule
