module cache_controller #(parameter address_width = 32, parameter data_width =32)(
    input clk,
    input reset,
    input read_enable,
    input write_enable,
    output reg ram_en_read,
    output reg ram_en_write,
    input ram_done,
    input cache_done,
    input dirty_data,
    output reg cache_en_read,
    output reg cache_en_write,
    input cache_found,
    

    output reg done
);
//I am going to implement it as FSM
reg [2:0] current_state;
reg [2:0] next_state;
localparam idle=3'b000,
            check_cache=3'b001,
            did_cache_find=3'b010,
            done_reading_writing=3'b011,
            ram_read=3'b100,
            cache_write=3'b101,
            ram_write=3'b110;
always @(posedge clk) begin
       if(reset==1'b1) begin
            next_state=idle;
            current_state= next_state;
       end
       
       
end
always@(posedge clk)begin
case(current_state) 

    idle: begin
        done=1'b0;
        ram_en_read=1'b0;
        ram_en_write=1'b0;
        cache_en_read=1'b0;
        cache_en_write=1'b0;
        if(read_enable)begin
            next_state=check_cache;
            current_state=next_state;
            
        end
        else if(write_enable)begin
            next_state=cache_write;
           current_state=next_state;
        end
        else begin
            next_state=idle;
            current_state=next_state;
        end 
    end
    check_cache:begin
        done=1'b0;
        ram_en_read=1'b0;
        ram_en_write=1'b0;
        cache_en_read=1'b1;//changed
        cache_en_write=1'b0;
        if(cache_done==1'b1)begin
            next_state=did_cache_find;
           current_state=next_state;
        end
        else begin
            next_state=check_cache;
            current_state=next_state;
        end
    end
    did_cache_find: begin
        done=1'b0;
        ram_en_read=1'b0;
        ram_en_write=1'b0;
        cache_en_read=1'b0;
        cache_en_write=1'b0;
        if(cache_found==1'b1)begin
        next_state=done_reading_writing;
        current_state=next_state;
        end
        else begin 
        next_state=ram_read;
        current_state=next_state;
        end
    end
    ram_read:begin
        done=1'b0;
        ram_en_read=1'b1;//changed
        ram_en_write=1'b0;
        cache_en_read=1'b0;
        cache_en_write=1'b0;
        if(ram_done==1'b1)begin
            next_state=done_reading_writing;
            current_state=next_state;
        end
        else begin
            next_state=ram_read;
            current_state=next_state;
        end
    end
    done_reading_writing: begin
        done=1'b1;//changed
        ram_en_read=1'b0;
        ram_en_write=1'b0;
        cache_en_read=1'b0;
        cache_en_write=1'b0;

        next_state=idle;
        current_state=next_state;
        
    end

    cache_write: begin
        done=1'b0;
        ram_en_read=1'b0;
        ram_en_write=1'b0;
        cache_en_read=1'b0;
        cache_en_write=1'b1;//changed

    //we want to apply write back technique here
    //the proper operation is to do the following
    //once enable write, ask the cache to tell you wheather the black going to be replaced is dirty or not
    //if dirty, you enable RAM read, and the cache put its data and address on the bus for one cycle and then do the replacement operation
        if(dirty_data==1'b1) begin
            next_state=ram_write;
            current_state=next_state;
        end

        else begin
            if(cache_done==1'b1) begin
            next_state=done_reading_writing;
            current_state=next_state;
            end
            else begin
                next_state=cache_write;
                current_state=next_state;
            end
        end
    end
    ram_write: begin
        done=1'b0;
        ram_en_read=1'b0;
        ram_en_write=1'b1;//changed
        cache_en_read=1'b0;
        cache_en_write=1'b0;

        if(ram_done==1'b1)begin
            next_state=done_reading_writing;
           current_state=next_state;
        end
        else begin
            next_state=ram_write;
           current_state=next_state;
        end
    end

    

endcase





end




endmodule