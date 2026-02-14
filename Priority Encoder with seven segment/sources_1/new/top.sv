`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 08:09:43
// Design Name: 
// Module Name: top
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


module top#(parameter N=16 ,OUTW = $clog2(N)
 )( input logic clk,
    input logic [N-1:0] in,
    output logic [6:0] seg_out,
    output logic [3:0] an
 );
 logic valid;
 logic [OUTW-1:0] bin_out;
 logic [3:0] tens,ones;
 logic [7:0] value;
    priority_encoder uut2 (
        .in(in),
        .valid(valid),
        .out(bin_out)
        );
 assign valid = (in !=0); // dont have extra switch for valid
assign value = {{(8-OUTW){1'b0}}, bin_out};
    always_comb begin
    tens = value / 10;
    ones = value % 10;
    end
    
   seven_segment uut1(
    .clk(clk),
    .tens(tens),
    .ones(ones),
    .an(an),
    .seg_out(seg_out)
    );
endmodule
