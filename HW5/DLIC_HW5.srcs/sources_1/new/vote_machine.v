`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2020 07:50:45 PM
// Design Name: 
// Module Name: voting_machine
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


module voting_machine(
input clk,
input rst,
input mode,
input button0,
input button1,
input button2,
input button3,
output [3:0] led
);

    wire valid_vote_0;
    wire valid_vote_1;
    wire valid_vote_2;
    wire valid_vote_3;
    wire [3:0] cand0_vote_recvd;
    wire [3:0] cand1_vote_recvd;
    wire [3:0] cand2_vote_recvd;
    wire [3:0] cand3_vote_recvd;
    wire anyValidVote;

buttoncontrol bc0(
    .clk(clk),
    .rst(rst),
    .button(button0),
    .valid_vote(valid_vote_0)
);

buttoncontrol bc1(
    .clk(clk),
    .rst(rst),
    .button(button1),
    .valid_vote(valid_vote_1)
);

buttoncontrol bc2(
    .clk(clk),
    .rst(rst),
    .button(button2),
    .valid_vote(valid_vote_2)
);

buttoncontrol bc3(
    .clk(clk),
    .rst(rst),
    .button(button3),//
    .valid_vote(valid_vote_3)
);

vote_logger vl(
    .clk(clk),
    .rst(rst),
    .mode(mode),
    //////////////////////////////////////////////////////////////////////////////////
    .candidate0_vote_valid(valid_vote_0),
    .candidate1_vote_valid(valid_vote_1),
    .candidate2_vote_valid(valid_vote_2),
    .candidate3_vote_valid(valid_vote_3),
    .candidate0_button_press(button0),
    .candidate1_button_press(button1),
    .candidate2_button_press(button2),
    .candidate3_button_press(button3),
    .candidate0_vote_received(cand0_vote_recvd),
    .candidate1_vote_received(cand1_vote_recvd),
    .candidate2_vote_received(cand2_vote_recvd),
    .candidate3_vote_received(cand3_vote_recvd)
    //////////////////////////////////////////////////////////////////////////////////
);
    //////////////////////////////////////////////////////////////////////////////////
    assign anyValidVote = valid_vote_0|valid_vote_1|valid_vote_2|valid_vote_3;
    //////////////////////////////////////////////////////////////////////////////////
    
    modecontrol mc(
    .clk(clk),
    .rst(rst),
    .mode(mode),
    .valid_vote(anyValidVote),
    .candidate0_vote(cand0_vote_recvd),
    .candidate1_vote(cand1_vote_recvd),
    .candidate2_vote(cand2_vote_recvd),
    .candidate3_vote(cand3_vote_recvd),
    .candidate0_button_press(valid_vote_0),
    .candidate1_button_press(valid_vote_1),
    .candidate2_button_press(valid_vote_2),
    .candidate3_button_press(valid_vote_3),
    
    .led(led)
    
    );

endmodule