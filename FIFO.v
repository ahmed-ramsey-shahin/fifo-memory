`timescale 1ns / 1ps

module FIFO #(parameter WIDTH=8, DEPTH=8, THRESHOLD=3) (
    input clk, reset_n,
    input wr_en, rd_en,
    input [WIDTH-1:0] data_in,
    output full, empty, threshold,
    output reg overflow, underflow,
    output reg [WIDTH-1:0] data_out
);

    reg [WIDTH-1:0] memory [DEPTH-1:0];
    reg [$clog2(DEPTH)-1:0] write_address;
    reg [$clog2(DEPTH)-1:0] read_address;
    reg [$clog2(DEPTH)-1:0] count;
    integer i;

    always @(posedge clk, negedge reset_n) begin
        if(~reset_n) begin
            write_address <= 'h0;
            read_address <= 'h0;
            count <= 'h0;
            overflow <= 1'b0;
            underflow <= 1'b0;
            data_out <= 1'b0;
            for(i=0; i<DEPTH; i=i+1) begin
                memory[i] <= 'h0;
            end
        end
        else begin
            if(wr_en) begin
                $display("write activated");
                memory[write_address] <= data_in;
                write_address <= write_address + 'h1;
                if(write_address == (DEPTH-1)) begin
                    write_address <= 'h0;
                end
            end
            if(rd_en) begin
                $display("read activated");
                data_out <= memory[read_address];
                read_address <= read_address + 'h1;
                if(read_address == (DEPTH-1)) begin
                    read_address <= 'h0;
                end
            end
            case({wr_en, rd_en})
                2'b00: count <= count;
                2'b01: count <= count - 'h1;
                2'b10: count <= count + 'h1;
                2'b11: count <= count;
                default: count <= count;
            endcase
            overflow <= full & wr_en;
            underflow <= empty & rd_en;
        end
    end

    assign full = (count == DEPTH-1);
    assign empty = (count == 'h0);
    assign threshold = (count < THRESHOLD) ? 1'b1 : 1'b0;
endmodule
