module Top_Module#(parameter address_width = 32,
    parameter data_width    = 32)(
        input clk,
        input reset,
    input read_enable,
    input write_enable,
    input [address_width-1:0] address_line,
    inout [data_width-1:0]    data_line
);

    

    
  

    wire read_enable_controller;
    wire write_enable_controller;
 
// Connect the Top Module inputs to the controller wires
assign read_enable_controller = read_enable;
assign write_enable_controller = write_enable;
    wire ram_en_read;
    wire ram_en_write;
    wire ram_done;

    wire cache_en_read;
    wire cache_en_write;
    wire cache_done;
    wire cache_found;
    wire dirty_data;

    cache_controller #(
        .address_width(address_width),
        .data_width(data_width)
    ) c_controller (
        .clk(clk),
        .reset(reset),
        .read_enable(read_enable_controller),
        .write_enable(write_enable_controller),
        .ram_en_read(ram_en_read),
        .ram_en_write(ram_en_write),
        .ram_done(ram_done),
        .cache_done(cache_done),
        .dirty_data(dirty_data),
        .cache_en_read(cache_en_read),
        .cache_en_write(cache_en_write),
        .cache_found(cache_found),
        .done() 
    );

    Cache cache1 (
        .clk(clk),
        .reset(reset),
        .address_line(address_line),
        .data_line(data_line),
        .cache_en_read(cache_en_read),
        .cache_en_write(cache_en_write),
        .ram_en_write(ram_en_write),
        .ram_done(ram_done),
        .cache_done(cache_done),
        .cache_found(cache_found),
        .dirty_data(dirty_data)
    );

    RAM #(
        .ADDR_WIDTH(address_width),
        .DATA_WIDTH(data_width)
    ) ram1 (
        .clk(clk),
        .rst(reset),
        .read_enable(ram_en_read),
        .write_enable(ram_en_write),
        .address(address_line),
        .data_line(data_line),
        .done(ram_done)
    );

endmodule
