module crc8_address (
    input  wire [55:0] data_in,  
    output wire [63:0] addr_out   
);

    wire [7:0] crc;

    assign crc = crc8_calc(data_in);
    assign addr_out = {data_in, crc};

   
    function [7:0] crc8_calc;
        input [55:0] din;
        integer i;
        reg [7:0] c;
        begin
            c = 8'h00;  
            for (i = 55; i >= 0; i = i - 1) begin
                c[7] = c[6];
                c[6] = c[5];
                c[5] = c[4] ^ c[7] ^ din[i];
                c[4] = c[3] ^ c[7] ^ din[i];
                c[3] = c[2];
                c[2] = c[1];
                c[1] = c[0];
                c[0] = c[7] ^ din[i];
            end
            crc8_calc = c;
        end
    endfunction

endmodule
