module fsm(
    input clk,
    input reset,
    output reg [2:0] out
);
//moore fsm means the out depends only on the current state

localparam green = 2'b00,
            yellow = 2'b01,
            red =2'b10;
reg [1:0]current_state;
reg[1:0] next_state;
integer counter=0;
always@(posedge clk)begin
    if(reset)begin
        counter=0;
        next_state=green;
        current_state=next_state;
    end
    case(current_state)
    green: 
        begin
            
            if(counter==5)begin
                next_state=yellow;
                current_state=next_state;
            end
            else begin
                next_state=green;
                current_state=next_state;

            end
            counter<=counter+1;
        end
    yellow:
        begin
            
            if(counter==7)begin
                next_state=red;
                current_state=next_state;
            end
            else begin
                next_state=yellow;
                current_state=next_state;
            end
            counter<=counter+1;
            
        end
    red:
        begin
            
            if(counter==12)begin
                counter=0;
                next_state=green;
                current_state=next_state;
            end
            else begin
                next_state=red;
                current_state=next_state;
            end
            counter<=counter+1;

        end
    default:
        begin
            counter=0;
            next_state=green;
            current_state=next_state;
        end



    endcase





end
always@(*)begin
case(next_state)
    green: out=3'b100;
    yellow:out=3'b010;
    red: out=3'b001;
    default: out=3'b000;
endcase

end


endmodule
