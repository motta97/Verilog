module adder(co,sum,a0,a1,ci);
parameter N =4 ;

input [N-1:0] a0,a1;
input ci;
output [N-1:0] sum;
output co;


generate
    case (N)
        1: adder1bit adder1(co,sum,a0,a1,ci);
        2: adder2bit adder1(co,sum,a0,a1,ci);
        default: adder_cla (#N) adder1(co,sum,a0,a1,ci);
endgenerate
