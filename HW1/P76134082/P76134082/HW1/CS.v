`timescale 1ns/10ps
module CS(
  input                                 clk, 
  input                                 reset,
  input                           [7:0] X,
  output                          [9:0] Y
);

reg     [71:0] window_reg;
reg     [11:0] prev_sum;
reg     [8:0]  prev_flags;

wire    [11:0] sum_reg;
wire    [20:0] avg_calc;
wire    [8:0]  valid_flags;
wire           sel_1a, sel_1b, sel_1c, sel_1d, sel_2a, sel_2b, sel_3a, sel_4a;
wire    [7:0]  val_1a, val_1b, val_1c, val_1d, val_2a, val_2b, val_3a, val_4a;
wire    [12:0] final_result;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        window_reg <= 72'b0;
        prev_sum   <= 0;
        prev_flags <= 8'b0;
    end
    else begin
        window_reg <= {window_reg[63:0], X}; 
        prev_sum   <= sum_reg;
        prev_flags <= valid_flags;
    end
end

assign sum_reg = prev_sum - {4'b0, window_reg[71:64]} + {4'b0, X};

assign avg_calc = {sum_reg, sum_reg[11:3]} - {2'b0, sum_reg, 6'b0} 
                + {5'b0, sum_reg, sum_reg[11:9]} - {8'b0, sum_reg};

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_valid_flags
        assign valid_flags[i] = window_reg[63 - (i * 8) -: 8] > avg_calc[19:12];
    end
endgenerate

assign valid_flags[8] = X > avg_calc[19:12];

MinMaxSelect sel1a(prev_flags[0], prev_flags[1], window_reg[71:64], window_reg[63:56], sel_1a, val_1a);
MinMaxSelect sel1b(prev_flags[2], prev_flags[3], window_reg[55:48], window_reg[47:40], sel_1b, val_1b);
MinMaxSelect sel1c(prev_flags[4], prev_flags[5], window_reg[39:32], window_reg[31:24], sel_1c, val_1c);
MinMaxSelect sel1d(prev_flags[6], prev_flags[7], window_reg[23:16], window_reg[15:8], sel_1d, val_1d);

MinMaxSelect sel2a(sel_1a, sel_1b, val_1a, val_1b, sel_2a, val_2a);
MinMaxSelect sel2b(sel_1c, sel_1d, val_1c, val_1d, sel_2b, val_2b);

MinMaxSelect sel3a(sel_2a, sel_2b, val_2a, val_2b, sel_3a, val_3a);
MinMaxSelect sel4a(sel_3a, prev_flags[8], val_3a, window_reg[7:0], sel_4a, val_4a);

//計算最終輸出
assign final_result = {1'b0, prev_sum} + {1'b0, {1'b0, val_4a, 3'b0} + {4'b0, val_4a}};
assign Y = final_result[12:3];

endmodule

module MinMaxSelect(
  input           invalid1,
  input           invalid2,
  input   [7:0]   value1,
  input   [7:0]   value2,
  output reg         o_invalid,
  output reg [7:0]   o_value
);

wire            flag;
assign flag = value1 > value2;

always @(*) begin
    case({invalid1, invalid2})
        2'b00: begin
            o_invalid <= 0;
            if(flag) o_value <= value1;
            else o_value <= value2;
        end
        2'b01: begin
            o_invalid <= 0;
            o_value <= value1;
        end
        2'b10: begin
            o_invalid <= 0;
            o_value <= value2;
        end
        default: begin
            o_invalid <= 1;
            o_value <= 8'b0;
        end
    endcase
end
endmodule
