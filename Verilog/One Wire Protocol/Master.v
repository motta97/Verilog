module master(
    inout bus,
    input clk,
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

reg     
            [63:0]rom_mem,
            en_send_reset,
            en_wait_precence,
            en_read_rom,
            en_match_rom,
            en_match_cmd_sender,
            en_sending_data,
            en_rom_cmd_sender,
            en_skip_cmd_sender;

reset_sender rst_snd(clk,en_send_reset,done_sending_reset,bus);
precence_waiter pr(clk,bus,en_wait_precence,done_wait_precence,found_precence);
rom_reader romr(clk,bus,en_read_rom,done_reading_rom,rom_mem);
rom_cmd_sender romcmdsnd(clk,en_rom_cmd_sender,done_rom_cmd_sending,bus);
skip_cmd_sender skipcmdsnd(clk,en_skip_cmd_sender,done_skip_cmd_sending,bus);
match_cmd_sender matchcmdsnd(clk,en_match_cmd_sender,done_match_cmd_sending,bus);
//we can use the same module rom_sender to send the rom for the slave in case of the Match Rom command
rom_sender match_rom(clk,bus,rom_mem[index_Rom_match],en_match_rom,done_matching_rom);
//we can also use the same module for sending data to the slave
rom_sender send_data(clk,bus,data_mem,en_sending_data,done_sending_data);

    
always@(posedge clk)begin
    if(reset)begin
        next_state=S_IDLE;
        current_state=next_state;
    end
    else begin

        case(current_state)
            S_IDLE:
                begin
                    if(en_master)begin
                        next_state=S_RESET;
                        current_state=next_state;
                    end
                    else begin
                        next_state=S_IDLE;
                        current_state=next_state;
                    end
                end
            S_RESET:
                begin
                    en_send_reset=1'b1;
                    if(done_sending_reset)begin
                        en_send_reset=1'b0;
                        next_state=S_WIAT_PRESENCE;
                        current_state=next_state;
                    end
                    else begin
                        next_state=S_RESET;
                        current_state=next_state;
                    end

                end
            S_WIAT_PRESENCE:
                begin
                    en_wait_precence=1'b1;
                    if(done_wait_precence)begin
                        en_wait_precence=1'b0;
                        if(found_precence)begin

                            next_state=S_ROM_CMD;
                            current_state=next_state;
                        end
                        else begin
                            next_state=S_RESET;
                            current_state=next_state;
                        end
                            //if precence wasn't found, it gets back to the reset signal state
                    end
                    else begin
                        next_state=S_WIAT_PRESENCE;
                        current_state=next_state;
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
                                next_state=S_SEND_DATA;
                                current_state=next_state;
                            end
                            else begin
                                next_state=S_ROM_CMD;
                                current_state=next_state;
                            end
                        end
                        else begin
                                next_state=S_ROM_CMD;
                                current_state=next_state;

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
                                next_state=S_ROM_CMD;
                                current_state=next_state;

                            end
                        end
                        else begin
                                next_state=S_ROM_CMD;
                                current_state=next_state;

                            end
                    end
                end

                S_SEND_DATA:
                    begin
                        en_sending_data=1'b1;
                        if(done_sending_data)begin
                            en_sending_data=1'b0;
                            next_state=S_RESET;
                            current_state=next_state;
                        end
                        else begin
                            next_state=S_SEND_DATA;
                            current_state=next_state;
                        end


                    end

        endcase
    end






end












endmodule