module RAM(input clk,
input we,
input [3:0]a,
input [3:0]di,
output reg [310]do;

);
    reg [3:0] ram[31:0];
    reg [3:0]read;
    always @(posedge clk)
    begin

        if(we)ram[a]=di;
        read=a;

    end
    assign do = ram[read];








endmodule
