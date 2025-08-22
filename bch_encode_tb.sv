`timescale 1ns / 1ps

module bch_encode_tb;
    // Parameters
    parameter N = 63;
    parameter K = 24;
    parameter CLK_PERIOD = 10;
    
    // Signals
    reg clk;
    reg rst_n;
    reg data_in;
    reg data_valid;
    wire ecc_out;
    wire ecc_valid;
    
    // Memory array to store input data from file
    reg [0:0] input_data [0:K-1]; // Unpacked array for $readmemb    
    // Loop variable
    integer i;
    
    // Instantiate DUT
    bch_encode #(
        .N(N),
        .K(K),
        .WIDTH(1),
        .COEFF_FILE("./g_coff_63_24.txt")
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_valid(data_valid),
        .ecc_out(ecc_out),
        .ecc_valid(ecc_valid)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
        data_in = 0;
        data_valid = 0;
        
        // Read input data from file
        $readmemb("./input_data.txt", input_data);
        
        // Reset
        #22 rst_n = 1;
        
        // Test case 1: Send data from file
        @(posedge clk);
        data_valid = 1;
        for (i = 0; i < K; i = i + 1) begin
            data_in = input_data[i];
            @(posedge clk);
        end
        for (i = 0; i < N-K; i = i + 1) begin
            data_in = 0;
            @(posedge clk);
        end
        data_valid = 0;
        
        // Wait for ECC output
        #200;
        
        // Test case 3: Reset during operation
        data_valid = 1;
        #50;
        rst_n = 0;
        #20;
        rst_n = 1;
        
        // Send more random data
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            data_in = $random;
        end
        data_valid = 0;
        
        #100;
        $display("Simulation completed");
        $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t rst_n=%b data_valid=%b data_in=%b ecc_out=%b ecc_valid=%b",
                 $time, rst_n, data_valid, data_in, ecc_out, ecc_valid);
    end
    
    // Dump waveform
    initial begin
        $dumpfile("bch_encode_tb.vcd");
        $dumpvars(0, bch_encode_tb);
    end

endmodule
