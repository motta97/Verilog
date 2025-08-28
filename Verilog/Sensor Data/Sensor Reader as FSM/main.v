module sensorfsm(
    input reset,
    input clk,
    input [7:0 ]data_in,
    output reg data_out,
    output reg data_valid
);
localparam S_RESET=3'B000,
            S_ACCEPT_DATA=3'B001,
            S_PARITY_CALC=3'B010,
            S_FRAME_CONSTRCT=3'B011,
            S_FRAME_SEND=3'B100,
            S_WAIT=3'B101;
reg [11:0]frame;
reg [2:0]current_state;
reg [2:0]next_state;
reg en_send_frame;
wire done_sending_frame;
reg en_rate_matching_check;
wire done_rate_matching;
send_frame s1(clk,en_send_frame,frame,done_sending_frame);
rate_match r1(clk,en_rate_matching_check,done_rate_matching);
always@(posedge clk, posedge reset)begin

if(reset)begin
    next_state=S_RESET;
    current_state=next_state;

end

else begin

    case(current_state)

        S_RESET: begin
            next_state=S_ACCEPT_DATA;
            current_state=next_state;
        end
        S_ACCEPT_DATA:begin
            frame[10:3]<=data_in;
            next_state=S_PARITY_CALC;
            current_state=next_state;
        end
        S_PARITY_CALC:begin
            frame[11]=^data_in;
            next_state=S_FRAME_CONSTRCT;
            current_state=next_state;
        end
        S_FRAME_CONSTRCT:begin
            frame[2:0]=3'b101;
            next_state=S_FRAME_SEND;
            current_state=next_state;
        end
        S_FRAME_SEND:begin
            en_send_frame=1'b1;
            if(done_sending_frame)begin
                en_send_frame=1'b0;
                next_state=S_WAIT;
                current_state=next_state;
            end
            else begin
                next_state=S_FRAME_SEND;
                current_state=next_state;
            end
        end
        S_WAIT:begin
                en_rate_matching_check=1'b1;
                if(done_rate_matching)begin
                    en_rate_matching_check=1'b0;
                    next_state=S_ACCEPT_DATA;
                    current_state=next_state;
                end
                else begin
                    next_state=S_WAIT;
                    current_state=next_state;
                end
        end
        default: begin
                     next_state=S_RESET;
                    current_state=next_state;
        end
    
    endcase

        end


end
always@(*)begin
case(next_state)
    S_RESET:begin
        data_out=1'b0;
        data_valid=1'b0;
    end
    S_ACCEPT_DATA:begin
        data_out=1'b0;
        data_valid=1'b0;
    end
    S_PARITY_CALC:begin
        data_out=1'b0;
        data_valid=1'b0;
    end
    S_FRAME_CONSTRCT:begin
        data_out=1'b0;
        data_valid=1'b0;
    end
    S_FRAME_SEND:begin
        data_valid=1'b1;
    end
    S_WAIT:begin
        data_out=1'b0;
        data_valid=1'b0;
    end
    default: begin
        data_out=1'b0;
        data_valid=1'b0;
    end
endcase

end

endmodule
