module CONV (
    input clk,
    input reset,
    input ready,
    input [19:0] idata,
    input [19:0] cdata_rd,

    output reg busy,
    output reg crd,
    output reg cwr,
    output reg [2:0] csel,
    output reg [11:0] iaddr,
    output reg [11:0] caddr_rd,
    output reg [11:0] caddr_wr,
    output reg [19:0] cdata_wr
);

  parameter LOGIC_IDLE = 3'd0;
  parameter LOGIC_CONVOLVE = 3'd1;
  parameter LOGIC_LOAD_MEM_LAYER0 = 3'd2;
  parameter LOGIC_READ_MEM = 3'd3;
  parameter LOGIC_LOAD_MEM_LAYER1 = 3'd4;
  parameter LOGIC_LOAD_MEM_LAYER2 = 3'd5;
  parameter LOGIC_FINISH = 3'd6;
  parameter LOGIC_DELAY = 3'd7;

  parameter READ_L0MEM0 = 2'd0, READ_L0MEM1 = 2'd1, READ_L1MEM0 = 2'd2, READ_L1MEM1 =2'd3;
  parameter bias_layer0 = 20'h01310;
  parameter bias_layer1 = 20'hF7295;
  parameter NO_SELECTION = 3'd0, LAYER0_KERNEL0 = 3'd1, LAYER0_KERNEL1 = 3'd2, LAYER1_KERNEL0 = 3'd3, LAYER1_KERNEL1 = 3'd4, LAYER2_KERNEL = 3'd5;

  reg [2:0] current_state, next_state, previous_state;
  reg [1:0] current_read_state, next_read_state;
  reg signed [19:0] input_data_buffer;
  reg [5:0] x_coordinate, y_coordinate;
  reg [3:0] block_counter;
  reg signed [39:0] convolution_mul_0, convolution_add_0, convolution_mul_1, convolution_add_1;
  wire signed [19:0] kernel_0_output, kernel_1_output;
  wire signed [39:0] sum_0, sum_1;
  wire signed [19:0] carry_0, carry_1;
  reg [2:0] pooling_counter;
  reg signed [19:0] max_value;
  reg flag_layer0, flag_layer1, flag_layer2;

  always @( posedge clk or posedge reset ) begin
    if( reset ) input_data_buffer <= 'd0;
    else begin
      case( block_counter )
        1: input_data_buffer <= ( x_coordinate==0 || y_coordinate==0 )? 'd0: idata;
        2: input_data_buffer <= ( y_coordinate==0 )? 'd0: idata;
        3: input_data_buffer <= ( x_coordinate==63 || y_coordinate==0 )? 'd0: idata;
        4: input_data_buffer <= ( x_coordinate==0 )? 'd0: idata;
        5: input_data_buffer <= idata;
        6: input_data_buffer <= ( x_coordinate==63 )? 'd0: idata;
        7: input_data_buffer <= ( x_coordinate==0 || y_coordinate==63 )? 'd0: idata;
        8: input_data_buffer <= ( y_coordinate==63 )? 'd0: idata;
        9: input_data_buffer <= ( x_coordinate==63 || y_coordinate==63 )? 'd0: idata;
        default: input_data_buffer <= 'd0;
      endcase
    end
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) block_counter <= 0;
    else if( next_state == LOGIC_CONVOLVE ) block_counter <= block_counter + 1;
    else block_counter <= 0;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) begin
      x_coordinate <= 'd0;
	  y_coordinate <= 'd0;
    end
    else if( next_state == LOGIC_DELAY ) begin
      if( current_state == LOGIC_LOAD_MEM_LAYER2  ) begin
        x_coordinate[4:0] <= x_coordinate[4:0] + 1;
		y_coordinate <= y_coordinate + ( x_coordinate == 5'd31 ) ;
      end
      else if( current_state == LOGIC_LOAD_MEM_LAYER1 ) begin
        x_coordinate <= x_coordinate + 2;
		y_coordinate <= y_coordinate + ( x_coordinate == 6'd62 ) + ( x_coordinate == 6'd62 );
      end
      else begin
        x_coordinate <= x_coordinate + 1;
		y_coordinate <= y_coordinate + ( x_coordinate == 6'd63 );
      end
    end
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) begin
      convolution_mul_0 <= 'd0;
	  convolution_mul_1 <= 'd0;
    end
    else if( current_state == LOGIC_CONVOLVE ) begin
      if( block_counter > 1 ) begin
        convolution_mul_0 <= kernel_0_output * input_data_buffer;
        convolution_mul_1 <= kernel_1_output * input_data_buffer;
      end
      else begin
        convolution_mul_0 <= 'd0;
        convolution_mul_1 <= 'd0;
      end
    end
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) begin
      convolution_add_0 <= 'd0;
	  convolution_add_1 <= 'd0;
    end
    else if( current_state == LOGIC_CONVOLVE ) begin
      if( block_counter > 2 ) begin
        convolution_add_0 <= convolution_add_0 + convolution_mul_0 ;
        convolution_add_1 <= convolution_add_1 + convolution_mul_1 ;
      end
      else begin
        convolution_add_0 <= 'd0;
        convolution_add_1 <= 'd0;
      end
    end
  end

  KERNEL0 kernel_module_0( .counter(block_counter), .kernel(kernel_0_output) );
  KERNEL1 kernel_module_1( .counter(block_counter), .kernel(kernel_1_output) );

  always @( posedge clk or posedge reset ) begin
    if( reset ) busy <= 0;
    else if( current_state == LOGIC_FINISH ) busy <= 0;
    else if( current_state == LOGIC_IDLE ) busy <= 1;
  end

  always @( * ) begin
    case( current_state )
      LOGIC_IDLE, LOGIC_CONVOLVE, LOGIC_DELAY, LOGIC_READ_MEM : begin
        crd = 1;
		cwr = 0;
      end
      LOGIC_LOAD_MEM_LAYER0, LOGIC_LOAD_MEM_LAYER1, LOGIC_LOAD_MEM_LAYER2: begin
        crd = 0;
		cwr = 1;
      end
      default: begin
        crd = 0;
		cwr = 0;
      end
    endcase
  end

  always @( * ) begin
    case( current_state )
      LOGIC_IDLE, LOGIC_CONVOLVE: csel = NO_SELECTION;
      LOGIC_DELAY: csel = LAYER0_KERNEL0;
      LOGIC_LOAD_MEM_LAYER0: csel = ( flag_layer0 )? LAYER0_KERNEL1 : LAYER0_KERNEL0 ;
      LOGIC_READ_MEM: begin
        case( current_read_state )
          READ_L0MEM0: csel = LAYER0_KERNEL0;
          READ_L0MEM1: csel = LAYER0_KERNEL1;
          READ_L1MEM0: csel = LAYER1_KERNEL0;
          READ_L1MEM1: csel = LAYER1_KERNEL1;
        endcase
      end
      LOGIC_LOAD_MEM_LAYER1: csel = ( flag_layer1 )? LAYER1_KERNEL1 : LAYER1_KERNEL0;
      LOGIC_LOAD_MEM_LAYER2:  csel = LAYER2_KERNEL;
      default: csel = NO_SELECTION;
    endcase
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) pooling_counter <= 0;
    else if( next_read_state == READ_L0MEM0 || next_read_state == READ_L0MEM1 ) pooling_counter <= pooling_counter + 2'd1;
    else pooling_counter <= 0;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) max_value <= 'd0;
    else if( current_state == LOGIC_READ_MEM && (current_read_state == READ_L0MEM0 || current_read_state == READ_L0MEM1) ) begin
      if( pooling_counter == 1 ) max_value <= cdata_rd;
      else if( cdata_rd > max_value ) max_value <= cdata_rd;
    end
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) iaddr <= 0;
    else if( next_state == LOGIC_CONVOLVE ) begin
      case( block_counter )
        0: iaddr <= {y_coordinate-6'd1,x_coordinate-6'd1};
        1: iaddr <= {y_coordinate-6'd1,x_coordinate};
        2: iaddr <= {y_coordinate-6'd1,x_coordinate+6'd1};
        3: iaddr <= {y_coordinate,x_coordinate-6'd1};
        4: iaddr <= {y_coordinate,x_coordinate};
        5: iaddr <= {y_coordinate,x_coordinate+6'd1};
        6: iaddr <= {y_coordinate+6'd1,x_coordinate-6'd1};
        7: iaddr <= {y_coordinate+6'd1,x_coordinate};
        8: iaddr <= {y_coordinate+6'd1,x_coordinate+6'd1};
      endcase
    end
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) flag_layer2 <= 0;
    else if( current_state == LOGIC_LOAD_MEM_LAYER2 ) flag_layer2 <= ~flag_layer2;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) flag_layer1 <= 0;
    else if( current_state == LOGIC_LOAD_MEM_LAYER1 ) flag_layer1 <= ~flag_layer1;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) flag_layer0 <= 0;
    else if( current_state == LOGIC_LOAD_MEM_LAYER0 ) flag_layer0 <= ~flag_layer0;
  end

  assign sum_0 = convolution_add_0 + {4'b0,bias_layer0,16'b0};
  assign sum_1 = convolution_add_1 + {4'b0,bias_layer1,16'b0};

  assign carry_0 = ( sum_0[15] )? sum_0[35:16] + 1: sum_0[35:16];
  assign carry_1 = ( sum_1[15] )? sum_1[35:16] + 1: sum_1[35:16];

  always @( posedge clk or posedge reset ) begin
    if( reset ) caddr_wr <= 0;
    else if( next_state == LOGIC_LOAD_MEM_LAYER0 ) caddr_wr <= {y_coordinate,x_coordinate};
    else if( next_state == LOGIC_LOAD_MEM_LAYER1 ) caddr_wr <= {y_coordinate[5:1],x_coordinate[5:1]};
    else if( next_state == LOGIC_LOAD_MEM_LAYER2 ) caddr_wr <= {y_coordinate,x_coordinate[4:0],1'b0} + flag_layer2;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) cdata_wr <= 0;
    else if( next_state == LOGIC_LOAD_MEM_LAYER0 ) begin
      if( current_state == LOGIC_LOAD_MEM_LAYER0 ) cdata_wr <= ( carry_1 > 0 )? carry_1 : 'd0 ; // using flag_layer0 will error
      else cdata_wr <= ( carry_0 > 0 )? carry_0 : 'd0 ;
    end
    else if( next_state == LOGIC_LOAD_MEM_LAYER1 ) cdata_wr <= ( cdata_rd > max_value )? cdata_rd: max_value ;
    else if( next_state == LOGIC_LOAD_MEM_LAYER2 ) cdata_wr <= cdata_rd;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) caddr_rd <= 0;
    else if( next_read_state == READ_L0MEM0 || next_read_state == READ_L0MEM1 ) begin
      case( pooling_counter )
        0: caddr_rd <= {y_coordinate,x_coordinate};
        1: caddr_rd <= {y_coordinate,x_coordinate+6'd1};
        2: caddr_rd <= {y_coordinate+6'd1,x_coordinate};
        3: caddr_rd <= {y_coordinate+6'd1,x_coordinate+6'd1};
      endcase
    end
    else if( next_read_state == READ_L1MEM0 || next_read_state == READ_L1MEM1 ) caddr_rd <= {y_coordinate[4:0],x_coordinate[4:0]};
  end

  // FSM State Update Logic
  always @( posedge clk or posedge reset ) begin
    if( reset ) previous_state <= LOGIC_IDLE;
    else previous_state <= current_state;
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) current_state <= LOGIC_IDLE;
    else current_state <= next_state;
  end

  always @( * ) begin
    case( current_state )
      LOGIC_IDLE: next_state = ( !ready )? LOGIC_CONVOLVE : LOGIC_IDLE ;
      LOGIC_CONVOLVE: next_state = ( block_counter == 12 )? LOGIC_LOAD_MEM_LAYER0 : LOGIC_CONVOLVE ;
      LOGIC_READ_MEM: begin
        if( current_read_state == READ_L0MEM0 ) next_state = ( pooling_counter == 3'd4 )? LOGIC_LOAD_MEM_LAYER1 : LOGIC_READ_MEM ;
        else if( current_read_state == READ_L0MEM1 ) next_state = ( pooling_counter == 3'd4 )? LOGIC_LOAD_MEM_LAYER1 : LOGIC_READ_MEM ;
        else if( current_read_state == READ_L1MEM0 ) next_state = LOGIC_LOAD_MEM_LAYER2;
        else next_state = LOGIC_LOAD_MEM_LAYER2;

      end
      LOGIC_LOAD_MEM_LAYER0: next_state = ( flag_layer0 )? LOGIC_DELAY : LOGIC_LOAD_MEM_LAYER0 ;
      LOGIC_LOAD_MEM_LAYER1: next_state = ( flag_layer1 )? LOGIC_DELAY : LOGIC_READ_MEM ;
      LOGIC_LOAD_MEM_LAYER2: next_state = ( flag_layer2 )? LOGIC_DELAY : LOGIC_READ_MEM ;
      LOGIC_DELAY: begin
        if( {y_coordinate,x_coordinate} == 12'd0 ) begin
          if( previous_state == LOGIC_LOAD_MEM_LAYER2  ) next_state = LOGIC_FINISH;
          else if( previous_state == LOGIC_LOAD_MEM_LAYER1 ) next_state = LOGIC_READ_MEM;
          else next_state = LOGIC_READ_MEM;
        end
        else begin
          if( previous_state == LOGIC_LOAD_MEM_LAYER2  ) next_state = LOGIC_READ_MEM;
          else if( previous_state == LOGIC_LOAD_MEM_LAYER1 ) next_state = LOGIC_READ_MEM;
          else next_state = LOGIC_CONVOLVE;
        end
      end
      LOGIC_FINISH: next_state = LOGIC_FINISH;
    endcase
  end

  always @( posedge clk or posedge reset ) begin
    if( reset ) current_read_state <= READ_L0MEM0;
    else current_read_state <= next_read_state;
  end

  always @( * ) begin
    case( current_read_state )
      READ_L0MEM0: next_read_state = ( current_state == LOGIC_LOAD_MEM_LAYER1 )? READ_L0MEM1 : READ_L0MEM0 ;
      READ_L0MEM1: begin
        if( current_state == LOGIC_DELAY ) next_read_state = ( {y_coordinate,x_coordinate} == 12'd0 )? READ_L1MEM0 : READ_L0MEM0 ;
        else next_read_state = READ_L0MEM1;
      end
      READ_L1MEM0: next_read_state = ( current_state == LOGIC_LOAD_MEM_LAYER2 )? READ_L1MEM1: READ_L1MEM0 ;
      READ_L1MEM1: begin
        if( current_state == LOGIC_DELAY ) next_read_state = ( {y_coordinate,x_coordinate} == 12'd0 )? READ_L0MEM0: READ_L1MEM0 ;
        else next_read_state = READ_L1MEM1;
      end
    endcase
  end

endmodule

// Kernel Module 0
module KERNEL0(
  input [3:0] counter,
  output reg signed [19:0] kernel
);

  parameter Kernel_0 = 20'h0A89E;
  parameter Kernel_1 = 20'h092D5;
  parameter Kernel_2 = 20'h06D43;
  parameter Kernel_3 = 20'h01004;
  parameter Kernel_4 = 20'hF8F71;
  parameter Kernel_5 = 20'hF6E54;
  parameter Kernel_6 = 20'hFA6D7;
  parameter Kernel_7 = 20'hFC834;
  parameter Kernel_8 = 20'hFAC19;

  always @( * ) begin
    case( counter )
      2: kernel = Kernel_0;
      3: kernel = Kernel_1;
      4: kernel = Kernel_2;
      5: kernel = Kernel_3;
      6: kernel = Kernel_4;
      7: kernel = Kernel_5;
      8: kernel = Kernel_6;
      9: kernel = Kernel_7;
      10: kernel = Kernel_8;
      default: kernel = 'd0;
    endcase
  end
endmodule

// Kernel Module 1
module KERNEL1(
  input [3:0] counter,
  output reg signed [19:0] kernel
);

  parameter Kernel_0 = 20'hFDB55;
  parameter Kernel_1 = 20'h02992;
  parameter Kernel_2 = 20'hFC994;
  parameter Kernel_3 = 20'h050FD;
  parameter Kernel_4 = 20'h02F20;
  parameter Kernel_5 = 20'h0202D;
  parameter Kernel_6 = 20'h03BD7;
  parameter Kernel_7 = 20'hFD369;
  parameter Kernel_8 = 20'h05E68;

  always @( * ) begin
    case( counter )
      2: kernel = Kernel_0;
      3: kernel = Kernel_1;
      4: kernel = Kernel_2;
      5: kernel = Kernel_3;
      6: kernel = Kernel_4;
      7: kernel = Kernel_5;
      8: kernel = Kernel_6;
      9: kernel = Kernel_7;
      10: kernel = Kernel_8;
      default: kernel = 'd0;
    endcase
  end
endmodule
