module rom_reader(
    input clk,
    inout bus,
    input en_read_rom,
    output reg done_reading_rom,
    output reg [63:0]rom_mem
);
integer counter =0;
integer index2=0;
reg drive_bus;
initial begin
    assign drive_bus=bus;
end
always@(posedge clk)begin

if(en_read_rom)begin

    if(counter<6)begin
        counter<=counter+1;
        drive_bus<=1'b0;
    end
    else if(counter ==15) begin
        if(bus==1'b1)begin
            rom_mem[index2]<=1'b1;
        end
        else begin
            rom_mem[index2]<=1'b0;
        end
    end
    else begin
        counter<=counter+1;
    end

    if(counter==70)begin

        counter<=0;
        index2<=index2+1;
    end
    if(index2==64)begin
        index2<=0;
        counter<=0;
        done_reading_rom=1'b1;
    end

    end




end














endmodule