module FSM(input clk,input reset, input x1, output reg outp);

parameter s1 = 2'b00;
parameter s2 = 2'b01;
parameter s3 = 2'b10;
parameter s4 = 2'b11;

reg[1:0]next_state;

reg [1:0]state;

initial begin
    state = s1;
 end
//we want to do one for next state and one for reset
 always @(posedge clk)begin

if(reset) begin 
    
    state= s1;
end
else begin
state = next_state;
end
 end

 always @(*)begin

case (state)

s1: begin
    
    if(x1)  begin
                next_state <=s2;
                        
                        end
    else begin
            next_state<=s3;
            
        end
    
    end
s2: begin
        next_state<=s4;
       
    end
s3: 
        next_state<=s4;
       
s4: begin
        next_state<=s1;
       
    end
endcase
 end
//output
always @(posedge clk)begin
case(state)
s1: outp<=1'b1;
s2: outp<=1'b1;
s3: outp<=1'b0;
s4:  outp<=1'b0;
endcase
end

endmodule
