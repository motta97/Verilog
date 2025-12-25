`timescale 1ns/1ps

module Top_Module_tb;

    // Parameters matching your requirement
    localparam ADDR_WIDTH = 16;
    localparam DATA_WIDTH = 32;
    localparam TOTAL_ENTRIES = 256;
    localparam WAYS = 4;
    localparam SETS = TOTAL_ENTRIES / WAYS; // 64 sets

    reg clk;
    reg reset;
    reg read_enable;
    reg write_enable;
    reg  [ADDR_WIDTH-1:0] address_line_reg;
    reg  [DATA_WIDTH-1:0] write_data_reg;
    wire [DATA_WIDTH-1:0] data_bus;
    wire [ADDR_WIDTH-1:0] addr_bus;

    // Tri-state buffers for the shared buses
    assign data_bus = write_enable ? write_data_reg : {DATA_WIDTH{1'bz}};
    assign addr_bus = (read_enable || write_enable) ? address_line_reg : {ADDR_WIDTH{1'bz}};

    // Instantiate DUT
    Top_Module #(
        .address_width(ADDR_WIDTH),
        .data_width(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .address_line(addr_bus),
        .data_line(data_bus)
    );

    // Clock Generation (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // --- Helper Tasks ---
    task write_mem(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    begin
        @(negedge clk);
        address_line_reg = addr;
        write_data_reg   = data;
        write_enable     = 1;
        read_enable      = 0;
        @(posedge clk); 
        // Wait for the controller to signal 'done' if your Top Module had a done port
        // Since we don't have 'done' in Top, we wait for the FSM to cycle (approx 3-4 cycles)
        repeat(4) @(posedge clk);
        write_enable     = 0;
        #1;
    end
    endtask

    task read_mem(input [ADDR_WIDTH-1:0] addr, output [DATA_WIDTH-1:0] data);
    begin
        @(negedge clk);
        address_line_reg = addr;
        read_enable      = 1;
        write_enable     = 0;
        repeat(4) @(posedge clk);
        data = data_bus;
        read_enable      = 0;
        #1;
    end
    endtask

    // --- Test Sequence ---
    reg [DATA_WIDTH-1:0] read_val;
    
    initial begin
        // Initialize
        reset = 1;
        read_enable = 0;
        write_enable = 0;
        address_line_reg = 0;
        write_data_reg = 0;
        
        #50 reset = 0;
        @(posedge clk);

        $display("--- Test 1: Compulsory Miss & Cache Fill ---");
        write_mem(16'hAAAA, 32'h1234_5678);
        read_mem(16'hAAAA, read_val);
        if (read_val === 32'h1234_5678) $display("PASS: Data matched.");
        else $display("FAIL: Expected 1234_5678, got %h", read_val);

        $display("--- Test 2: Set Associativity (Filling all 4 ways) ---");
        // We use addresses that have the same index (lower 6 bits if 64 sets)
        // Set index = addr[5:0]. Let's use index 5'h05.
        repeat(4) @(posedge clk);
        write_mem(16'h0005, 32'h1111_1111); // Way 0
        repeat(4) @(posedge clk);
        write_mem(16'h0105, 32'h2222_2222); // Way 1
        repeat(4) @(posedge clk);
        write_mem(16'h0205, 32'h3333_3333); // Way 2
        repeat(4) @(posedge clk);
        write_mem(16'h0305, 32'h4444_4444); // Way 3
        repeat(4) @(posedge clk);

        $display("--- Test 3: Cache Hit Check ---");
        read_mem(16'h0105, read_val); // Should be HIT
        if (read_val === 32'h2222_2222) $display("PASS: Way 1 Hit.");
    repeat(4) @(posedge clk);
        $display("--- Test 4: Eviction & Write-Back ---");
        // Writing to a 5th address with same index forces eviction of LRU way
        write_mem(16'h0405, 32'h5555_5555); 
        repeat(4) @(posedge clk);
        // Read back the evicted line 16'h0005 (Should be a MISS now)
        read_mem(16'h0005, read_val);
        $display("Check waveforms for 'dirty_data' pulse during Test 4.");
repeat(4) @(posedge clk);
        #100;
        $display("Simulation Complete.");
        $finish;
    end

endmodule