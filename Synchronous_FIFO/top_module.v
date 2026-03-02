module top_module(
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire read_en,
    input [7:0] in,
    output wire empty,
    output wire full,
    output wire [6:0] seven_seg,
    output wire [3:0] an
);

wire [7:0] out;
wire resetn = ~reset;

//////////////////////////////////////////////////////////////
// 2 ff Synchronizer
//////////////////////////////////////////////////////////////

reg wr_sync0, wr_sync1;
reg rd_sync0, rd_sync1;

always @(posedge clk) begin
    wr_sync0 <= write_en;
    wr_sync1 <= wr_sync0;

    rd_sync0 <= read_en;
    rd_sync1 <= rd_sync0;
end

//////////////////////////////////////////////////////////////
//  Debounce Logic (10ms)
//////////////////////////////////////////////////////////////

reg [19:0] wr_cnt;
reg [19:0] rd_cnt;

reg wr_stable;
reg rd_stable;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        wr_cnt <= 0;
        wr_stable <= 0;
    end else begin
        if (wr_sync1)
            wr_cnt <= wr_cnt + 1;
        else
            wr_cnt <= 0;

        if (wr_cnt == 20'hFFFFF)
            wr_stable <= 1;
        else if (!wr_sync1)
            wr_stable <= 0;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        rd_cnt <= 0;
        rd_stable <= 0;
    end else begin
        if (rd_sync1)
            rd_cnt <= rd_cnt + 1;
        else
            rd_cnt <= 0;

        if (rd_cnt == 20'hFFFFF)
            rd_stable <= 1;
        else if (!rd_sync1)
            rd_stable <= 0;
    end
end

//////////////////////////////////////////////////////////////
//  Rising Edge Detection (Single Pulse)
//////////////////////////////////////////////////////////////

reg wr_prev, rd_prev;

always @(posedge clk) begin
    wr_prev <= wr_stable;
    rd_prev <= rd_stable;
end

wire write_pulse = wr_stable & ~wr_prev;
wire read_pulse  = rd_stable & ~rd_prev;

//////////////////////////////////////////////////////////////
// 4️ FIFO Instance
//////////////////////////////////////////////////////////////

fifo dut(
    .clk(clk),
    .resetn(resetn),
    .write_en(write_pulse),
    .read_en(read_pulse),
    .in(in),
    .empty(empty),
    .full(full),
    .out(out)
);

//////////////////////////////////////////////////////////////
// 7 segment 
//////////////////////////////////////////////////////////////

reg [19:0] refresh_counter;
wire [1:0] led_activating_counter;
reg [3:0] anode_temp;
reg [3:0] hex_dec;

always @(posedge clk or posedge reset) begin
    if (reset)
        refresh_counter <= 0;
    else
        refresh_counter <= refresh_counter + 1;
end

assign led_activating_counter = refresh_counter[19:18];

always @(*) begin
    case(led_activating_counter)
        2'b00: begin
            anode_temp = 4'b0111;
            hex_dec = in[7:4];
        end
        2'b01: begin
            anode_temp = 4'b1011;
            hex_dec = in[3:0];
        end
        2'b10: begin
            anode_temp = 4'b1101;
            hex_dec = out[7:4];
        end
        2'b11: begin
            anode_temp = 4'b1110;
            hex_dec = out[3:0];
        end
        default: begin
            anode_temp = 4'b1111;
            hex_dec = 4'h0;
        end
    endcase
end

assign an = anode_temp;

reg [6:0] seg_temp;
always @(*) begin
    case(hex_dec)
        4'h0: seg_temp = 7'b1000000;
        4'h1: seg_temp = 7'b1111001;
        4'h2: seg_temp = 7'b0100100;
        4'h3: seg_temp = 7'b0110000;
        4'h4: seg_temp = 7'b0011001;
        4'h5: seg_temp = 7'b0010010;
        4'h6: seg_temp = 7'b0000010;
        4'h7: seg_temp = 7'b1111000;
        4'h8: seg_temp = 7'b0000000;
        4'h9: seg_temp = 7'b0010000;
        4'hA: seg_temp = 7'b0001000;
        4'hB: seg_temp = 7'b0000011;
        4'hC: seg_temp = 7'b1000110;
        4'hD: seg_temp = 7'b0100001;
        4'hE: seg_temp = 7'b0000110;
        4'hF: seg_temp = 7'b0001110;
        default: seg_temp = 7'b1111111;
    endcase
end

assign seven_seg = seg_temp;

endmodule