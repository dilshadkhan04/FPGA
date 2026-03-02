`timescale 1ns/1ps

module fifo #(parameter DEPTH = 16, WIDTH = 8) (
    input wire clk,
    input wire resetn, // Active-low reset
    input wire write_en,
    input wire read_en,
    input wire [WIDTH-1:0] in,
    output wire empty,
    output wire full,
    output reg [WIDTH-1:0] out
);

// Adding 1 extra bit to pointers to easily calculate full/empty conditions
localparam PTR_WIDTH = $clog2(DEPTH);
reg [PTR_WIDTH:0] wrptr;
reg [PTR_WIDTH:0] rdptr;

reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];

// Write Block
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin // Fixed: Active-low check
        wrptr <= 0;
    end else begin
        if (write_en && !full) begin // Fixed: Added begin/end
            fifo_mem[wrptr[PTR_WIDTH-1:0]] <= in;
            wrptr <= wrptr + 1;
        end
    end
end

// Read Block
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin // Fixed: Active-low check
        rdptr <= 0;
        out <= 0;
    end else begin
        if (read_en && !empty) begin // Fixed: Added begin/end
            out <= fifo_mem[rdptr[PTR_WIDTH-1:0]];
            rdptr <= rdptr + 1;
        end
    end
end

// Empty: Pointers are exactly the same
assign empty = (wrptr == rdptr);

// Full: The MSB is different (meaning the write pointer wrapped around), 
// but all other bits are identical.
assign full = (wrptr[PTR_WIDTH] != rdptr[PTR_WIDTH]) && 
              (wrptr[PTR_WIDTH-1:0] == rdptr[PTR_WIDTH-1:0]);

endmodule
