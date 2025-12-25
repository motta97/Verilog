// Parameterized Synchronous RAM with bidirectional data bus
module RAM #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 16
)(
    input  wire                   clk,
    input  wire                   rst,

    input  wire                   read_enable,
    input  wire                   write_enable,

    input  wire [ADDR_WIDTH-1:0]  address,
    inout  wire [DATA_WIDTH-1:0]  data_line,

    output reg                    done
);

    // Memory depth
    localparam MEM_DEPTH = 2 ** ADDR_WIDTH;

    // Memory array
    reg [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];

    // Bus driving control
    reg drive_data;
    reg [DATA_WIDTH-1:0] data_out;

    // Tri-state assignment
    assign data_line = drive_data ? data_out : {DATA_WIDTH{1'bz}};

    integer i;

    // Synchronous operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done       <= 1'b0;
            drive_data <= 1'b0;
            data_out   <= {DATA_WIDTH{1'b0}};
        end
        else begin
            done       <= 1'b0;
            drive_data <= 1'b0; // default: bus released

            // ---------------- WRITE ----------------
            if (write_enable && !read_enable) begin
                memory[address] <= data_line;  // sample bus
                done <= 1'b1;
            end

            // ---------------- READ ----------------
            else if (read_enable && !write_enable) begin
                data_out   <= memory[address];
                drive_data <= 1'b1;            // drive bus for 1 cycle
                done       <= 1'b1;
            end

            // ---------------- IDLE / INVALID ----------------
            else begin
                done <= 1'b0;
            end
        end
    end

endmodule
