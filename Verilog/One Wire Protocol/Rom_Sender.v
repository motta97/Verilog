module rom_sender(
    input clk,
    output reg bus,
    input [63:0]rom,
    input en_rom_sender,
    output reg done_sending_rom
);
integer counter =0;
integer counter_num_of_bits=0;
integer index=0;

always@(posedge clk)begin

if(en_rom_sender==1'b1)begin

if(counter <6)begin
    if(bus==1'b0)begin
    counter<=counter+1;
    end
    else begin
    counter <=0;
    done_sending_rom=1'b0;
    end

end
else begin
    done_sending_rom=1'b0;
    if(rom[index]==1'b0)begin
    //send a zero
        if(counter<=60) begin
            bus<=1'b0;
            counter <= counter+1;
        end

        else begin
            bus<=1'bz;
            counter<=0;
            index=index+1;
            counter_num_of_bits<=counter_num_of_bits+1;
        end
    
        end

    else begin
    //send a one
        if(counter<60) begin
            bus<=1'bz;
            counter<=counter+1;
        end
        else begin

            counter<=0;
            index<=index+1;
            counter_num_of_bits<=counter_num_of_bits+1;

        end
        
    end

    
    if(counter_num_of_bits==64)begin
    index=0;
    counter=0;
    counter_num_of_bits=0;
    done_sending_rom=1'b1;
    end









    end


end





end






endmodule