module master(
    inout bus,
    input clk,
    output reg master_pull_low,
    input reset,
    input en_master
);

parameter 
            S_IDLE=3'b000,
            S_RESET=3'b001,
            S_WIAT_PRESENCE=3'b010,
            S_ROM_CMD=3'b011,
            S_RECV_DATA_ROM=3'b100,
            S_SEND_DATA=3'b101,
            S_RESET_HIGH=3'b110,
            rom_command=8'b00110011,
            index_Rom_match=0;
reg [63:0] data_mem;
reg [2:0]current_state;
reg  [2:0]next_state;

wire 
            done_sending_reset,
            done_wait_precence,
            found_precence,
            done_reading_rom,
            done_matching_rom,
            done_match_cmd_sending,
            done_sending_data,
            done_rom_cmd_sending,
            done_skip_cmd_sending;
wire [63:0]rom_mem;
wire master_pull_low_wire,
    master_pull_low_wire1,
    master_pull_low_wire2,
    master_pull_low_wire3,
    master_pull_low_wire4,
    master_pull_low_wire5,
    master_pull_low_wire6,
    master_pull_low_wire7,
    master_pull_low_wire8;
reg     
            
            en_send_reset,
            en_wait_precence,
            en_read_rom,
            en_match_rom,
            en_match_cmd_sender,
            en_sending_data,
            en_rom_cmd_sender,
            en_skip_cmd_sender;

reset_sender rst_snd(clk,en_send_reset,master_pull_low_wire1,done_sending_reset,bus);
precence_waiter pr(clk,bus,en_wait_precence,master_pull_low_wire2,done_wait_precence,found_precence);
rom_reader romr(clk,bus,master_pull_low_wire3,en_read_rom,done_reading_rom,rom_mem);
rom_cmd_sender romcmdsnd(clk,en_rom_cmd_sender,master_pull_low_wire4,done_rom_cmd_sending,bus);
skip_cmd_sender skipcmdsnd(clk,en_skip_cmd_sender,master_pull_low_wire5,done_skip_cmd_sending,bus);
match_cmd_sender matchcmdsnd(clk,en_match_cmd_sender,master_pull_low_wire6,done_match_cmd_sending,bus);
//we can use the same module rom_sender to send the rom for the slave in case of the Match Rom command
rom_sender match_rom(clk,bus,master_pull_low_wire7,rom_mem,en_match_rom,done_matching_rom);
//we can also use the same module for sending data to the slave
rom_sender send_data(clk,bus,master_pull_low_wire8,data_mem,en_sending_data,done_sending_data);
assign master_pull_low_wire=(master_pull_low_wire1|master_pull_low_wire2|
    master_pull_low_wire3|master_pull_low_wire4|master_pull_low_wire5|master_pull_low_wire6|master_pull_low_wire7
    |master_pull_low_wire8
)? 1'b1:1'b0;
    always@(*)begin
        master_pull_low<=master_pull_low_wire;


    end
    always@(posedge clk)begin
     if(reset)begin
        next_state=S_IDLE;
        current_state=next_state;
    end
    end
always@(*)begin
   
        case(current_state)
         
            S_IDLE:
                begin
                    if(en_master)begin
                        next_state<=S_RESET;
                        current_state<=next_state;
                    end
                    else begin
                        next_state<=S_IDLE;
                        current_state<=next_state;
                    end
                end
            S_RESET:
                begin
                    en_send_reset<=1'b1;
                    if(done_sending_reset)begin
                        en_send_reset=1'b0;
                        next_state<=S_WIAT_PRESENCE;
                        current_state<=next_state;
                    end
                    else begin
                        next_state<=S_RESET;
                        current_state<=next_state;
                    end

                end
            S_WIAT_PRESENCE:
                begin
                    en_wait_precence=1'b1;
                    if(done_wait_precence)begin
                        en_wait_precence<=1'b0;
                        if(found_precence)begin

                            next_state<=S_ROM_CMD;
                            current_state<=next_state;
                        end
                        else begin
                            next_state<=S_RESET;
                            current_state<=next_state;
                        end
                            //if precence wasn't found, it gets back to the reset signal state
                    end
                    else begin
                        next_state<=S_WIAT_PRESENCE;
                        current_state<=next_state;
                    end
                end

            S_ROM_CMD:
                begin
                    if(rom_command==8'b00110011)begin
                        

                        en_rom_cmd_sender=1'b1;
                        if(done_rom_cmd_sending)begin 
                            en_rom_cmd_sender=1'b0;
                            en_read_rom=1'b1;
                            if(done_reading_rom)begin
                                en_read_rom=1'b0;
                                next_state<=S_SEND_DATA;
                                current_state<=next_state;
                            end
                            else begin
                                next_state<=S_ROM_CMD;
                                current_state<=next_state;
                            end
                        end
                        else begin
                                next_state<=S_ROM_CMD;
                                current_state<=next_state;

                        end
                        

                    end
                    else if(rom_command==8'b11001100)begin
                      en_skip_cmd_sender=1'b1;
                        if(done_skip_cmd_sending)begin
                            en_skip_cmd_sender<=1'b0;
                            next_state<=S_SEND_DATA;
                            current_state<=next_state;
                        end
                         else begin
                                next_state<=S_ROM_CMD;
                                current_state<=next_state;

                        end
                    end
                    else if(rom_command==8'b01010101)begin
                        en_match_cmd_sender=1'b1;
                        //we want to send that command first
                        if(done_match_cmd_sending)begin
                            en_match_cmd_sender<=1'b0;
                            en_match_rom<=1'b1;
                            if(done_matching_rom)begin
                                en_match_rom<=1'b0;
                                next_state<=S_SEND_DATA;
                                current_state<=next_state;
                            end
                            else begin
                                next_state<=S_ROM_CMD;
                                current_state<=next_state;

                            end
                        end
                        else begin
                                next_state<=S_ROM_CMD;
                                current_state<=next_state;

                            end
                    end
                end

                S_SEND_DATA:
                    begin
                        en_sending_data=1'b1;
                        if(done_sending_data)begin
                            en_sending_data=1'b0;
                            next_state<=S_RESET;
                            current_state<=next_state;
                        end
                        else begin
                            next_state<=S_SEND_DATA;
                            current_state<=next_state;
                        end


                    end
                default: begin

                            next_state<=S_IDLE;
                            current_state<=next_state;
                end

        endcase
    
    






end












endmodule
