`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2020 07:59:45 PM
// Design Name: 
// Module Name: modeControl
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


module modecontrol(
input clk,
input rst,
input mode,
input valid_vote,
input [3:0] candidate0_vote,
input [3:0] candidate1_vote,
input [3:0] candidate2_vote,
input [3:0] candidate3_vote,
input candidate0_button_press,
input candidate1_button_press,
input candidate2_button_press,
input candidate3_button_press,

output reg [3:0] led

);
    
    reg [30:0] counter;
    
    always @(posedge clk) begin
//        if (rst == 0 && mode == 1) begin
//            counter <= 31'b0;  // Reset all when mode=1
//        end 
//        else if (rst == 0 && mode == 0) begin
//            // Selectively reset counter based on button press
//            if (candidate0_button_press || candidate1_button_press || 
//                candidate2_button_press || candidate3_button_press) 
//            begin
//                counter <= 31'b0;
//            end 
//            else if (valid_vote) begin
//                counter <= counter + 1;
//            end 
//            else if (counter != 0 && counter < 100000000) begin
//                counter <= counter + 1;
//            end 
//            else begin
//                counter <= 0;
//            end
//        end
        if(rst)
            counter <= 31'b0;   //Whenever reset is pressed, counter started from 0
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        else if(valid_vote) //If a valid vote is casted, counter becomes 1
            counter <= counter + 1;
        else if(counter !=0 & counter < 100000000)//If counter is not 0, increment it till 100000000
            counter <= counter + 1;
        else //Once counter becomes 100000000, reset it to zero
            counter <= 0;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    end    
        
    always @(posedge clk) begin
        if(rst)
            led <= 4'b0;
        else begin
            if(mode == 0 &  counter > 31'b0 ) //mode0 -> voting mode, mode 1 -> result mode
                led <= 4'b1111;
            else if(mode == 0)
                led <= 4'b0;
            else if(mode == 1)begin //resultmode
                //////////////////////////////////////////////////////////////////////////////////
                if(candidate0_button_press)
                    led <= candidate0_vote;
                else if(candidate1_button_press)
                    led <= candidate1_vote;
                else if(candidate2_button_press)
                    led <= candidate2_vote;
                else if(candidate3_button_press)
                    led <= candidate3_vote;
                //////////////////////////////////////////////////////////////////////////////////
            end
        end  
    end
    
endmodule