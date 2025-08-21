module data_reader(
    input clk,
    input bus,
    input en_data_read,
    output reg done_reading_data,
    output reg [63:0] memory 
);
    integer counter = 0;
    integer index=0;
    integer counter_num_of_bits=0;
    always@(posedge clk)begin

        if(en_data_read==1'b1)begin
            done_reading_data<=1'b0;
            if(counter <30)begin
            counter<=counter +1;

            end
            else if(counter==30)begin
                if(bus==1'b1)begin
                    memory[index]<=1'b1;
                end
                else begin
                    memory[index]<=1'b0;
                end
                counter<=counter+1;

            end
            else begin
                counter<=counter+1;
            end

            if(counter==60)begin
                counter<=0;
                index<=index+1;
                counter_num_of_bits<=counter_num_of_bits+1;
            end

            if(counter_num_of_bits==64)begin
                counter<=0;
                index<=0;
                counter_num_of_bits<=0;
                done_reading_data<=1'b1;


            end





        end







    end







endmodule