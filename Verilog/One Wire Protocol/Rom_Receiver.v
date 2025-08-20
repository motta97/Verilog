module rom_reciever(
    input clk,
    input bus,
    input en_rom_reciever,
    output reg [63:0] Received_ROM,
    output reg done_recieving_rom
);
integer counter =0;
integer counter_num_of_bits=0;
integer index=0;
always@(posedge clk)begin

if(en_rom_reciever==1'b1)begin
    done_recieving_rom=1'b0;
    if(counter<30)begin
    counter<=counter+1;
    end
    else if(counter==30)begin
        if(bus==1'b0)begin
        Received_ROM[index]=0;
        end
        else begin
        Received_ROM[index]=1;
        end
    end
    else begin
        counter<=counter+1;
    end
    if(counter==60)begin
    counter <=0;
    index<=index+1;
    counter_num_of_bits=counter_num_of_bits+1;
    end
    if(counter_num_of_bits==64)begin
    counter <=0;
    index<=0;
    counter_num_of_bits=0;
    done_recieving_rom=1'b1;
    end





end

end








endmodule