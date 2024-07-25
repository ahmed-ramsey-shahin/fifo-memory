`timescale 1ns/1ps

module FIFOTestBench();
    reg clk, reset_n;
    reg wr_en, rd_en;
    reg [15:0] data_in;
    wire full, empty, threshold, overflow, underflow;
    wire [15:0] data_out;
    integer i;

    FIFO #(16, 8, 5) UUT (
        clk, reset_n,
        wr_en, rd_en,
        data_in,
        full, empty, threshold, overflow, underflow,
        data_out
    );

    // clock generation
    always begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end

    initial begin
        i = 0;
        reset_n = 1'b0;
        data_in = 'h0;
        wr_en = 1'b0;
        rd_en = 1'b0;
        #2;
        reset_n = 1'b1;
        // @(negedge clk);
        // rd_en = 1'b1;
        @(negedge clk);
        rd_en = 1'b0;
        for(i=0; i<8; i=i+1) begin
            wr_en = 1'b1;
            data_in = i + 2;
            @(negedge clk);
            wr_en = 1'b0;
        end
        wr_en = 1'b1;
        data_in = 'h16;
        @(negedge clk);
        wr_en = 1'b0;
        #10;
        wr_en = 1'b1;
        rd_en = 1'b1;
        data_in = 'h11;
        #20;
        reset_n = 1'b0;
        #10;
        reset_n = 1'b1;
        #10;
        $finish;
    end
endmodule
