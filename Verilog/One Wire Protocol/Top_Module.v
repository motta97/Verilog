module transciever(
    input mode,
    input clk,
    inout bus,
    input reset
);
reg en_master,en_slave;
master m1(bus,clk,reset,en_master);
slave s1(bus,clk,reset,en_slave);

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