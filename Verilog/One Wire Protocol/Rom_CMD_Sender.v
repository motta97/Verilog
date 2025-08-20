module rom_cmd_sender(
    input clk,
    input en_rom_cmd_sender,
    output reg done_rom_cmd_sending,
    output reg bus
);
    integer counter =0;
    //33-->00110011
    always@(posedge clk)begin

        if(en_rom_cmd_sender)begin
        done_rom_cmd_sending<=1'b0;
        //send 0
        if(counter<60)begin
            bus<=1'b0;
            counter<=counter+1;
        end
        else if(counter<71)begin
            counter<=counter+1;
            bus=1'bz;
        end
        //send 0
        else if(counter<131)begin//71+60

            counter<=counter+1;
            bus=1'b0;

        end
        else if(counter<142)begin
            counter<=counter+1;
            bus=1'bz;
        end
        //send 1
        else if(counter<202)begin
            bus<=1'bz;
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
            bus=1'b0;
        end
        else if(counter<355)begin
            counter<=counter+1;
            bus=1'bz;
        end
        //send0
        else if(counter<415)begin
            counter<=counter+1;
            bus=1'b0;
        end
        else if(counter<426)begin
            counter<=counter+1;
            bus=1'bz;
        end
        //send 1
        else if(counter<486)begin
            bus<=1'bz;
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
        done_rom_cmd_sending<=1'b1;
        end

        end

    end
endmodule