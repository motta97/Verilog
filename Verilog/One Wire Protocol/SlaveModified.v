
module slave(
    input bus,
    output reg slave_pull_low,
    input clk,
    input reset,
    input en_slave
);

parameter S_IDLE = 3'b000,
          S_PRESENCE = 3'b001,
          S_CMD_RECV = 3'b010,
          S_CMD_DECODE = 3'b011,
          S_MATCH_ROM = 3'b100,
          S_WAIT_READ = 3'b101,
          S_READ_DATA = 3'b110;

        reg [55:0] ROM_ID;
        wire [63:0] ROM_ID_WITH_CRC;
        wire [63:0] Received_ROM;
        wire [63:0] memory;
        wire [7:0]frame;
        reg [2:0]current_state, next_state;
        reg[7:0]data;
        
        reg en_check_reset;
        wire reset_found;
        reg en_precence;
        wire done_precence;
        reg en_cmd_recieve;
        wire done_recieving;
        reg en_rom_sender;
        wire done_sending_rom;
        reg en_rom_reciever;
        wire done_recieving_rom;
        reg en_data_read;
        wire done_reading_data;
        wire slave_pull_low_wire,
        slave_pull_low_wire1,
        slave_pull_low_wire2,
        slave_pull_low_wire3;

        reset_checker reset_checker0(clk,bus,en_check_reset,reset_found);
        precence_replier p(clk,bus,slave_pull_low_wire1,en_precence,done_precence);
        cmd_reciever c(clk,bus,frame,en_cmd_recieve,done_recieving);
        rom_sender rom_sender0(clk,bus,slave_pull_low_wire2,ROM_ID_WITH_CRC,en_rom_sender,done_sending_rom);
        rom_reciever rom_reciever0(clk,bus,slave_pull_low_wire3,Received_ROM,done_recieving_rom);
        data_reader d(clk,bus,en_data_read,done_reading_data,memory);
        crc8_address crc(ROM_ID,ROM_ID_WITH_CRC);

        assign slave_pull_low_wire = (slave_pull_low_wire1|slave_pull_low_wire1|slave_pull_low_wire2|slave_pull_low_wire3)?1'b1:1'b0;
always@(*)begin
    slave_pull_low<=slave_pull_low_wire;

end
always@(posedge clk)begin

 if(reset)begin
        next_state<=S_IDLE;
        current_state <= next_state;
    end
end
always@(posedge clk)begin
   
    
    case(current_state) 
      
        S_IDLE: begin 
            if(en_slave)begin
                en_check_reset<=1'b1;
                if(reset_found==1'b1)begin
                en_check_reset<=1'b0;
                next_state<=S_PRESENCE;
                current_state <= next_state;
            end
            else begin
                next_state<=S_IDLE;
                current_state <= next_state;
            end
        end

        end
        S_PRESENCE: begin
            //wait for 15useconds
           
            en_precence<=1'b1;
            if(done_precence==1'b1)begin
                en_precence<=1'b0;
                next_state<=S_CMD_RECV;
                current_state<=next_state;
            end
        end
        S_CMD_RECV: begin
           
           en_cmd_recieve<=1'b1;
          if(done_recieving==1'b1)begin
            en_cmd_recieve<=1'b0;
            next_state<=S_CMD_DECODE;
            current_state<=next_state;
          end

        end
        S_CMD_DECODE: begin
            //assuming we have only the Read ROM command, SKIP ROM, MATCH ROM
            //if match rom command, you read the rom being sent, if not yours, you get back to the idle state, if yours receive data
            //if SKIP rom command, just move to the next state
            //if read rom command, send your rom on the bus
            if(frame==8'b00110011)begin
                //make the CRC of the ROM
                    en_rom_sender<=1'b1;
                    if(done_sending_rom==1'b1)begin
                        en_rom_sender<=1'b0;
                        next_state<=S_READ_DATA;
                        current_state <= next_state;
                    end
                
            end
            else if(frame ==8'b11001100) begin
                //move to the next state
                next_state<=S_READ_DATA;
                current_state <= next_state;
            end
            else if(frame ==8'b01010101) begin
                // move to the state of matching rom
                next_state<=S_MATCH_ROM;
                current_state<=next_state;
            end
            else begin
                //The command is not valid
                next_state<=S_IDLE;
                current_state<=next_state;


            end
        end
        S_MATCH_ROM: begin
            en_rom_reciever<=1'b1;
            if(done_recieving_rom==1'b1)begin
                en_rom_reciever<=1'b0;
                if(Received_ROM==ROM_ID_WITH_CRC)begin
                     next_state<=S_READ_DATA;
                    current_state <= next_state;
                end
                else begin
                 next_state<=S_IDLE;
                current_state <= next_state;

                end


            end
          
        end
      
        S_READ_DATA: begin
            en_data_read<=1'b1;
            //what's the next state?
            //it should stay here untill reset happens
            if(done_reading_data)begin
                en_data_read<=1'b0;
                next_state<=S_IDLE;
                current_state<= next_state;
            end
            else begin
                next_state<=S_READ_DATA;
                current_state<=next_state;
            end
            

        end

  default: begin

                            next_state=S_IDLE;
                            current_state=next_state;
                end
    endcase
    
   
    
end



 endmodule


