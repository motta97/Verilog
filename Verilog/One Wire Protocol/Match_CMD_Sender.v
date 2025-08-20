module match_cmd_sender(
    input clk,
    input en_match_rom,
    output reg done_matching_rom,
    output reg bus
);
integer counter =0;
//55-->01010101
always@(posedge clk)begin

if(en_match_rom)begin
done_matching_rom<=1'b0;
//send 0
if(counter<60)begin
    bus<=1'b0;
    counter<=counter+1;
end
else if(counter<71)begin
    counter<=counter+1;
    bus=1'bz;
end
//send 1
else if(counter<131)begin//71+60

    counter<=counter+1;
    bus=1'bz;

end
else if(counter<142)begin
    counter<=counter+1;
    bus=1'bz;
end
//send 0
else if(counter<202)begin
    bus<=1'b0;
    counter<=counter+1;
end
else if(counter<213)begin
    bus<=1'bz;
    counter<=counter+1;
end
//send 1
else if(counter<273)begin
    bus<=1'bz;
    counter<=counter+1;
end
else if(counter<284)begin
    bus<=1'bz;
    counter<=counter+1;
end
//send0
else if(counter<344)begin
    counter<=counter+1;
    bus=1'b1;
end
else if(counter<355)begin
    counter<=counter+1;
    bus=1'bz;
end
//send1
else if(counter<415)begin
    counter<=counter+1;
    bus=1'bz;
end
else if(counter<426)begin
    counter<=counter+1;
    bus=1'bz;
end
//send 0
else if(counter<486)begin
    bus<=1'b0;
    counter<=counter+1;
end
else if(counter<497)begin
    bus<=1'bz;
    counter<=counter+1;
end
//send1
else if(counter<557)begin
    bus<=1'bz;
    counter<=counter+1;
end
else if(counter<568)begin
    bus<=1'bz;
    counter<=counter+1;
end
else begin
counter<=counter+1;
end
if(counter==568)begin
counter<=0;
done_matching_rom=1'b1;
end

end








end








endmodule