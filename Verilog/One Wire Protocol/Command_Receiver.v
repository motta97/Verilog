module cmd_reciever(
    input clk,
    inout bus,
    output reg [7:0] frame,
    input en_cmd_recieve,
    output reg done_recieving
);    
//each bit takes70us with 1us margin
integer counter =0;
always@(posedge clk)begin
if(en_cmd_recieve)begin
    if(counter==30)begin
        counter<=counter+1;
        frame <= {bus,frame[7:1]};
    end
    else if(counter==101) begin 
        frame <= {bus,frame[7:1]};
        counter <=counter+1;
    end
    else if(counter==172)begin
        frame <= {bus,frame[7:1]};
        counter <=counter+1;

    end
    else if(counter==243)begin
        frame <= {bus,frame[7:1]};
        counter <=counter+1;

    end
    else if(counter==314)begin
        frame <= {bus,frame[7:1]};
        counter <=counter+1;

    end
    else if(counter==385)begin
        frame <= {bus,frame[7:1]};
        counter <=counter+1;

    end
    else if(counter==456)begin
        frame <= {bus,frame[7:1]};
        counter <=counter+1;

    end
    else if(counter==527)begin
        frame <= {bus,frame[7:1]};
        counter <=counter+1;

    end
    else begin
        counter<=counter+1;
        
    end
    //last bit will end at 588
    if(counter ==568) begin
        counter =0;
        done_recieving=1'b1;
    end








end









end



endmodule