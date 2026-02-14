`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 08:46:58
// Design Name: 
// Module Name: seven_seg_outment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_segment(
                    input logic clk,
                    input logic [3:0] tens,
                    input logic [3:0] ones,
                    output logic [3:0] an,
                    output logic [6:0] seg_out
    );
    logic [15:0] refresh;
    logic [1:0] select;
    logic [3:0] digital_value;
    always_ff@(posedge clk) refresh<=refresh+1;
    assign select = refresh[15:14] ;
    always_comb begin
    case(select)
 2'd0: begin
    an = 4'b1110;   // LD10 active
    digital_value = ones;
end
2'd1: begin
    an = 4'b1101;   // LD11 active
    digital_value = tens;
            end
            default: begin
                an = 4'b1111;   // others off
                digital_value = 4'd0;
            end
        endcase
    
     
     case (digital_value)
            4'd0: seg_out = 7'b1000000;
            4'd1: seg_out = 7'b1111001;
            4'd2: seg_out = 7'b0100100;
            4'd3: seg_out = 7'b0110000;
            4'd4: seg_out = 7'b0011001;
            4'd5: seg_out = 7'b0010010;
            4'd6: seg_out = 7'b0000010;
            4'd7: seg_out = 7'b1111000;
            4'd8: seg_out = 7'b0000000;
            4'd9: seg_out = 7'b0010000;
            default: seg_out = 7'b1111111; // blank
        endcase
 end
endmodule
