module Cache #(
    parameter depth     = 64,
    parameter waysNum   = 4,
    parameter tagWidth  = 10,    // Adjusted: tagWidth + idxWidth = 16 (for your 16-bit address)
    parameter dataWidth = 32,
    parameter idxWidth  = 6      // log2(64) = 6 bits
)(
    input  wire                    clk,
    input  wire                    reset,

    // System buses (bidirectional)
    inout  wire [tagWidth+idxWidth-1:0] address_line,
    inout  wire [dataWidth-1:0]         data_line,

    // Control from Controller
    input  wire                    cache_en_read,
    input  wire                    cache_en_write,
    input  wire                    ram_en_write,
    input  wire                    ram_done,

    // Status back to Controller
    output reg                     cache_done,
    output reg                     cache_found,
    output reg                     dirty_data
);

    localparam ADDR_W = tagWidth + idxWidth;

    // --- Cache Storage Arrays ---
    reg [tagWidth-1:0]    tag_array   [0:depth-1][0:waysNum-1];
    reg [dataWidth-1:0]   data_array  [0:depth-1][0:waysNum-1];
    reg                   valid_array [0:depth-1][0:waysNum-1];
    reg                   dirty_array [0:depth-1][0:waysNum-1];
    reg [$clog2(waysNum)-1:0] lru [0:depth-1][0:waysNum-1];

    // --- Internal Latches & Flags ---
    reg [ADDR_W-1:0] addr_latch;
    reg [dataWidth-1:0] write_data_latch;
    reg pending_read_miss;
    reg pending_write_miss;
    reg [$clog2(waysNum)-1:0] pending_victim_way;
    reg [idxWidth-1:0] pending_index;
    reg [tagWidth-1:0] pending_tag;

    // --- Tri-state Control ---
    reg drive_data;
    reg drive_addr;
    reg [dataWidth-1:0] bus_data_out;
    reg [ADDR_W-1:0]    bus_addr_out;

    assign data_line    = drive_data ? bus_data_out : {dataWidth{1'bz}};
    assign address_line = drive_addr ? bus_addr_out : {ADDR_W{1'bz}};

    // --- LIVE Hit Detection (Fixes 1-cycle delay) ---
    // If the controller is enabling us THIS cycle, look at the live bus.
    // Otherwise, look at our stable latched value.
    wire [idxWidth-1:0] current_idx = (cache_en_read || cache_en_write) ? 
                                       address_line[idxWidth-1:0] : addr_latch[idxWidth-1:0];
    wire [tagWidth-1:0] current_tag = (cache_en_read || cache_en_write) ? 
                                       address_line[ADDR_W-1:idxWidth] : addr_latch[ADDR_W-1:idxWidth];

    integer i, r, c;
    reg hit_any;
    reg [$clog2(waysNum)-1:0] hit_way;
    reg [$clog2(waysNum)-1:0] victim_way;

    // Combinational Hit and Victim Logic
    always @(*) begin
        hit_any = 1'b0;
        hit_way = 0;
        for (i = 0; i < waysNum; i = i + 1) begin
            if (valid_array[current_idx][i] && (tag_array[current_idx][i] == current_tag)) begin
                hit_any = 1'b1;
                hit_way = i;
            end
        end

        // LRU Victim Selection
        victim_way = 0;
        for (i = 1; i < waysNum; i = i + 1) begin
            if (lru[current_idx][i] < lru[current_idx][victim_way])
                victim_way = i;
        end
    end

    // --- Sequential Logic ---
    always @(posedge clk) begin
        if (reset) begin
            cache_done <= 0;
            cache_found <= 0;
            dirty_data <= 0;
            drive_data <= 0;
            drive_addr <= 0;
            pending_read_miss <= 0;
            pending_write_miss <= 0;
            for (r = 0; r < depth; r = r + 1) begin
                for (c = 0; c < waysNum; c = c + 1) begin
                    valid_array[r][c] <= 0;
                    dirty_array[r][c] <= 0;
                    lru[r][c] <= c;
                end
            end
        end else begin
            // Defaults
            cache_done <= 0;
            drive_data <= 0;
            drive_addr <= 0;

            // --- READ Operation ---
            if (cache_en_read) begin
                addr_latch <= address_line;
                if (hit_any) begin
                    bus_data_out <= data_array[current_idx][hit_way];
                    drive_data <= 1'b1;
                    cache_found <= 1'b1;
                    cache_done <= 1'b1;
                    // Update LRU
                    for (i = 0; i < waysNum; i = i + 1) begin
                        if (i == hit_way) lru[current_idx][i] <= waysNum - 1;
                        else if (lru[current_idx][i] > lru[current_idx][hit_way])
                            lru[current_idx][i] <= lru[current_idx][i] - 1;
                    end
                end else begin
                    pending_read_miss <= 1'b1;
                    pending_index <= current_idx;
                    pending_tag <= current_tag;
                    cache_found <= 1'b0;
                    cache_done <= 1'b1;
                end
            end

            // --- WRITE Operation ---
            else if (cache_en_write) begin
                addr_latch <= address_line;
                write_data_latch <= data_line;
                if (hit_any) begin
                    data_array[current_idx][hit_way] <= data_line;
                    dirty_array[current_idx][hit_way] <= 1'b1;
                    valid_array[current_idx][hit_way] <= 1'b1;
                    cache_found <= 1'b1;
                    cache_done <= 1'b1;
                    // Update LRU
                    for (i = 0; i < waysNum; i = i + 1) begin
                        if (i == hit_way) lru[current_idx][i] <= waysNum - 1;
                        else if (lru[current_idx][i] > lru[current_idx][hit_way])
                            lru[current_idx][i] <= lru[current_idx][i] - 1;
                    end
                end else begin
                    cache_found <= 1'b0;
                    if (dirty_array[current_idx][victim_way] && valid_array[current_idx][victim_way]) begin
                        dirty_data <= 1'b1;
                        pending_write_miss <= 1'b1;
                        pending_victim_way <= victim_way;
                        pending_index <= current_idx;
                        pending_tag <= current_tag;
                    end else begin
                        // Clean miss: Replace immediately
                        tag_array[current_idx][victim_way] <= current_tag;
                        data_array[current_idx][victim_way] <= data_line;
                        valid_array[current_idx][victim_way] <= 1'b1;
                        dirty_array[current_idx][victim_way] <= 1'b1;
                        cache_done <= 1'b1;
                        // Update LRU
                        for (i = 0; i < waysNum; i = i + 1) begin
                            if (i == victim_way) lru[current_idx][i] <= waysNum - 1;
                            else if (lru[current_idx][i] > lru[current_idx][victim_way])
                                lru[current_idx][i] <= lru[current_idx][i] - 1;
                        end
                    end
                end
            end

            // --- Write-Back Drive ---
            if (ram_en_write && pending_write_miss) begin
                drive_data <= 1'b1;
                drive_addr <= 1'b1;
                bus_data_out <= data_array[pending_index][pending_victim_way];
                bus_addr_out <= {tag_array[pending_index][pending_victim_way], pending_index};
            end

            // --- RAM Done Handling ---
            if (ram_done) begin
                if (pending_read_miss) begin
                    tag_array[pending_index][victim_way] <= pending_tag;
                    data_array[pending_index][victim_way] <= data_line;
                    valid_array[pending_index][victim_way] <= 1'b1;
                    dirty_array[pending_index][victim_way] <= 1'b0;
                    pending_read_miss <= 0;
                    cache_done <= 1'b1;
                end
                if (pending_write_miss) begin
                    tag_array[pending_index][pending_victim_way] <= pending_tag;
                    data_array[pending_index][pending_victim_way] <= write_data_latch;
                    valid_array[pending_index][pending_victim_way] <= 1'b1;
                    dirty_array[pending_index][pending_victim_way] <= 1'b1;
                    pending_write_miss <= 0;
                    dirty_data <= 0;
                    cache_done <= 1'b1;
                end
            end
        end
    end
endmodule