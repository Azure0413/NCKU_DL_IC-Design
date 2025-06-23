`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2020 07:42:53 PM
// Design Name: 
// Module Name: vote_logger
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


module vote_logger(
    input clk,
    input rst,
    input mode,
    input candidate0_vote_valid,
    input candidate1_vote_valid,
    input candidate2_vote_valid,
    input candidate3_vote_valid,
    input candidate0_button_press,
    input candidate1_button_press,
    input candidate2_button_press,
    input candidate3_button_press,
    output reg [3:0] candidate0_vote_received,
    output reg [3:0] candidate1_vote_received,
    output reg [3:0] candidate2_vote_received,
    output reg [3:0] candidate3_vote_received
);

    always @(posedge clk) begin
        if (rst && mode == 0) begin
            // �� rst=0 �B mode=0 �ɡA���U���s�u���m�����Կ�H������
            if (candidate0_button_press)
                candidate0_vote_received <= 4'b0;
            if (candidate1_button_press)
                candidate1_vote_received <= 4'b0;
            if (candidate2_button_press)
                candidate2_vote_received <= 4'b0;
            if (candidate3_button_press)
                candidate3_vote_received <= 4'b0;
        end else if (rst && mode == 1) begin
            // �� rst=0 �B mode=1 �ɡA���m�Ҧ��Կ�H������
            candidate0_vote_received <= 4'b0;
            candidate1_vote_received <= 4'b0;
            candidate2_vote_received <= 4'b0;
            candidate3_vote_received <= 4'b0;
        end else begin
            // ���`�p���޿�
            if (candidate0_vote_valid && mode == 0)
                candidate0_vote_received <= candidate0_vote_received + 1;
            else if (candidate1_vote_valid && mode == 0)
                candidate1_vote_received <= candidate1_vote_received + 1;
            else if (candidate2_vote_valid && mode == 0)
                candidate2_vote_received <= candidate2_vote_received + 1;
            else if (candidate3_vote_valid && mode == 0)
                candidate3_vote_received <= candidate3_vote_received + 1;
        end
    end
endmodule