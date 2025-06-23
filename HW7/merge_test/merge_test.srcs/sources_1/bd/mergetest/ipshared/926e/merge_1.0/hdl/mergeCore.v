`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2020 12:34:37 PM
// Design Name: 
// Module Name: mergeCore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Merge two sorted FIFOs into one sorted stream (descending order)
//
// Dependencies: arrayFifo, mergedFifo
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module mergeCore(
    input         clock,
    input         reset,
    input         start,
    input  [31:0] fifoWrData,
    input         fifo1WrEn,
    input         fifo2WrEn,
    input         mergedFifoRdEn,
    output [31:0] mergedFifoRdData,
    output reg    done
);

    wire fifo1Empty, fifo2Empty;
    wire [31:0] fifo1Data, fifo2Data;

    reg fifo1RdEn, fifo2RdEn;
    reg mergeFifoWrEn;
    reg [31:0] mergeFifoData;

    reg [31:0] dataLatch;
    reg fromFifo1;
    
    reg [2:0] state;
    
    localparam IDLE        = 3'd0,
               READ        = 3'd1,
               LOAD        = 3'd2,
               WRITE       = 3'd3,
               FLUSH_FIFO  = 3'd4,
               DONE        = 3'd5;

    always @(posedge clock) begin
        if (reset) begin
            state           <= IDLE;
            fifo1RdEn       <= 1'b0;
            fifo2RdEn       <= 1'b0;
            mergeFifoWrEn   <= 1'b0;
            done            <= 1'b0;
            dataLatch       <= 32'd0;
            fromFifo1       <= 1'b0;
        end else begin
            fifo1RdEn     <= 1'b0;
            fifo2RdEn     <= 1'b0;
            mergeFifoWrEn <= 1'b0;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) state <= READ;
                end

                READ: begin
                    if (!fifo1Empty && !fifo2Empty) begin
                        if (fifo1Data > fifo2Data) begin // DESCENDING ORDER
                            fromFifo1 <= 1'b1;
                            fifo1RdEn <= 1'b1;
                        end else begin
                            fromFifo1 <= 1'b0;
                            fifo2RdEn <= 1'b1;
                        end
                        state <= LOAD;
                    end else if (fifo1Empty && fifo2Empty) begin
                        state <= DONE;
                    end else begin
                        state <= FLUSH_FIFO;
                        if (!fifo1Empty) fifo1RdEn <= 1'b1;
                        else if (!fifo2Empty) fifo2RdEn <= 1'b1;
                    end
                end

                LOAD: begin
                    dataLatch <= fromFifo1 ? fifo1Data : fifo2Data;
                    state <= WRITE;
                end

                WRITE: begin
                    mergeFifoWrEn <= 1'b1;
                    mergeFifoData <= dataLatch;
                    state <= READ;
                end

                FLUSH_FIFO: begin
                    if (!fifo1Empty) begin
                        fifo1RdEn     <= 1'b1;
                        dataLatch     <= fifo1Data;
                        fromFifo1     <= 1'b1;
                        state         <= WRITE;
                    end else if (!fifo2Empty) begin
                        fifo2RdEn     <= 1'b1;
                        dataLatch     <= fifo2Data;
                        fromFifo1     <= 1'b0;
                        state         <= WRITE;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1'b1;
                    if (!start)
                        state <= IDLE;
                end
            endcase
        end
    end

    // FIFO instantiations
    arrayFifo arrayFifo1 (
        .clk(clock),
        .srst(reset),
        .din(fifoWrData),
        .wr_en(fifo1WrEn),
        .rd_en(fifo1RdEn),
        .dout(fifo1Data),
        .full(),
        .empty(fifo1Empty)
    );

    arrayFifo arrayFifo2 (
        .clk(clock),
        .srst(reset),
        .din(fifoWrData),
        .wr_en(fifo2WrEn),
        .rd_en(fifo2RdEn),
        .dout(fifo2Data),
        .full(),
        .empty(fifo2Empty)
    );

    mergedFifo mergedFifo (
        .clk(clock),
        .srst(reset),
        .din(mergeFifoData),
        .wr_en(mergeFifoWrEn),
        .rd_en(mergedFifoRdEn),
        .dout(mergedFifoRdData),
        .full(),
        .empty()
    );

endmodule
