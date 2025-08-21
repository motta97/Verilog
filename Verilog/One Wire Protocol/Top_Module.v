module transciever(
    input mode,
    input clk,
    inout bus,
    input reset
);
reg en_master,en_slave;
wire master_pull_low, slave_pull_low;

master m1(bus,clk,master_pull_low,reset,en_master);
slave s1(bus,slave_pull_low,clk,reset,en_slave);
assign bus = (master_pull_low | slave_pull_low) ? 1'b0 : 1'bz;
pullup(bus);
always@(posedge clk)begin

case(mode)
    1'b0:
    begin
        en_master=1'b1;
        en_slave=1'b0;
    end
    1'b1:
    begin
        en_master=1'b0;
        en_slave=1'b1;
    end
    default:
    begin
        en_master=1'b0;
        en_slave=1'b0;
    end
endcase


end


endmodule