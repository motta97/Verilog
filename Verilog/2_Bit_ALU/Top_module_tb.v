`timescale 1ps/1ps
module top_tb;

reg [1:0] a_in;
reg [1:0] b_in;
reg [3:0]sel;
wire signed [2:0] out;

top_module  t1(a_in,b_in,sel,out);


initial begin
    a_in=2'b10;
    b_in=2'b10;
    sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10

a_in = 2'b00; b_in = 2'b00;
   sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10
a_in = 2'b00; b_in = 2'b01;
    sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10
a_in = 2'b00; b_in = 2'b10;
   sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10
a_in = 2'b00; b_in = 2'b11;
    sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10

a_in = 2'b01; b_in = 2'b00;

   sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10
a_in = 2'b01; b_in = 2'b01;

    sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10
a_in = 2'b01; b_in = 2'b10;

    sel=4'b000;
    #10 sel=4'b001;
    #10 sel=4'b010;
    #10 sel=4'b011;
    #10 sel=4'b100;
    #10 sel=4'b101;
    #10 sel=4'b110;
    #10 sel=4'b111;#10
a_in = 2'b01; b_in = 2'b11;

    sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10

a_in = 2'b10; b_in = 2'b00;

     sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10
a_in = 2'b10; b_in = 2'b01;
     sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10
a_in = 2'b10; b_in = 2'b10;

    sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10
a_in = 2'b10; b_in = 2'b11;

     sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10

a_in = 2'b11; b_in = 2'b00;

    sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10
a_in = 2'b11; b_in = 2'b01;

     sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10
a_in = 2'b11; b_in = 2'b10;

     sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10
a_in = 2'b11; b_in = 2'b11;

    sel=4'b1000;
    #10 sel=4'b1001;
    #10 sel=4'b1010;
    #10 sel=4'b1011;
    #10 sel=4'b1100;
    #10 sel=4'b1101;
    #10 sel=4'b1110;
    #10 sel=4'b1111;#10

    $finish;


end







endmodule