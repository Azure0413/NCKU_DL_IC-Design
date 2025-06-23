`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/21 14:51:10
// Design Name: 
// Module Name: spiControl_FSM
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


module spiControl_FSM(
    ////input
    input clk,//100MHz
    input rst,
    input [3:0] data_in,
    input load_data,
    ////output
    output spi_clk,//10MHz
    output reg spi_data,
    output reg done_send
    );
    
    reg [2:0] counter = 3'd0;
    reg [2:0] dataCount;
    reg [7:0] shiftReg;
    reg [1:0] state;
    reg clk_10;
    reg CE;
    
    assign spi_clk = (CE == 1) ? clk_10 : 1'b1;

    always @(posedge clk)
    begin
        if(counter != 4)
            counter <= counter + 1;
        else
            counter <= 0;
    end

    initial
        clk_10 <= 0;

    always @(posedge clk)
    begin
        if(counter == 4)
            clk_10 <= ~clk_10;
    end

    localparam IDLE = 2'd0,
               SEND = 2'd1,
               DONE = 2'd2;

    always @(negedge clk_10)
    begin
        if(rst)
        begin
            state <= IDLE;
            dataCount <= 0;
            done_send <= 1'b0;
            CE <= 0;
            spi_data <= 1'b1;
        end
        else
        begin
            case(state)
                IDLE:begin
                    if(load_data)
                    begin
                        shiftReg <= {data_in, 4'b0000};
                        state <= SEND;
                        dataCount <= 0;
                    end
                end
                SEND:begin
                    spi_data <= shiftReg[7];
                    shiftReg <= {shiftReg[6:0], 1'b0};
                    CE <= 1;
                    if(dataCount != 7)
                        dataCount <= dataCount + 1;
                    else
                    begin
                        state <= DONE;
                    end
                end
                DONE:begin
                    CE <= 0;
                    done_send <= 1'b1;
                    if(!load_data)
                    begin
                        done_send <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
    
endmodule