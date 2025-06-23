`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/12 14:33:39
// Design Name: 
// Module Name: runningled
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

module runningled(
    input clock,
    input rst,
    output reg [3:0] led
    );
    
reg [31:0] counter;
parameter N = 50000000; // 設定分頻計數值，假設時脈為 50MHz，則約 0.5 秒變化一次

always @(posedge clock)
begin
    if (rst) begin
        led <= 4'b0001;
        counter <= 0;
    end else begin
        counter <= counter + 1;
        if (counter >= N) begin
            counter <= 0;
            led <= {led[0], led[3:1]};
        end
    end
end
endmodule