`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 08:10:27
// Design Name: 
// Module Name: priority_encoder
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

module priority_encoder #(parameter N = 16, OUTW = $clog2(N))(
                            input logic [N-1:0] in,
                            input logic valid,
                            output logic [OUTW-1:0] out
                           );
                          
            always_comb begin
             if(!valid) begin
               out = '0;
               end
             else begin
               out = '0;
           for(int i=N-1;i>=0;i--) begin
              if(in[i]) begin
               out = i[OUTW-1:0];
               break;
               end
           end
       end
    end
endmodule
