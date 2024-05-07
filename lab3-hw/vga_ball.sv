/*
 * Avalon memory-mapped peripheral that generates VGA
 *
 * Stephen A. Edwards
 * Columbia University
 */

module vga_ball(
    input logic         clk,
	  input logic 	      reset,
		input logic [7:0]   writedata,
		input logic 	      write,
		input 		          chipselect,
		input logic [2:0]   address,

		output logic [7:0] VGA_R, VGA_G, VGA_B,
		output logic 	   VGA_CLK, VGA_HS, VGA_VS,
		                   VGA_BLANK_n,
		output logic 	   VGA_SYNC_n
    
    );

   logic [10:0]	   hcount;
   logic [9:0]     vcount;

   logic [7:0] 	   background_r, background_g, background_b;

   logic [15:0]     x, y;

  //  this is for apple_sprite
   logic [15:0]     apple_sprite_output;
   logic [9:0]      apple_sprite_addr;
   logic [1:0]      apple_sprite_en;

  // snake face forwarded to right
   logic [15:0]     snake_head_right_sprite_output;
   logic [9:0]      snake_head_right_sprite_addr;
   logic [1:0]      snake_head_right_sprite_en;
  // snake face forwarded to left
   logic [15:0]     snake_head_left_sprite_output;
   logic [9:0]      snake_head_left_sprite_addr;
   logic [1:0]      snake_head_left_sprite_en;
  // snake face forwarded to up
   logic [15:0]     snake_head_up_sprite_output;
   logic [9:0]      snake_head_up_sprite_addr;
   logic [1:0]      snake_head_up_sprite_en;
  // snake face forwarded to down
   logic [15:0]     snake_head_down_sprite_output;
   logic [9:0]      snake_head_down_sprite_addr;
   logic [1:0]      snake_head_down_sprite_en;

  // body bottom left
   logic [15:0]     snake_body_bottomleft_sprite_output;
   logic [9:0]      snake_body_bottomleft_sprite_addr;
   logic [1:0]      snake_body_bottomleft_sprite_en;

  // body bottom right
   logic [15:0]     snake_body_bottomright_sprite_output;
   logic [9:0]      snake_body_bottomright_sprite_addr;
   logic [1:0]      snake_body_bottomright_sprite_en;

  // body top left
   logic [15:0]     snake_body_topleft_sprite_output;
   logic [9:0]      snake_body_topleft_sprite_addr;
   logic [1:0]      snake_body_topleft_sprite_en;

  // body top right
   logic [15:0]     snake_body_topright_sprite_output;
   logic [9:0]      snake_body_topright_sprite_addr;
   logic [1:0]      snake_body_topright_sprite_en;

  // body horizontal
   logic [15:0]     snake_body_horizontal_sprite_output;
   logic [9:0]      snake_body_horizontal_sprite_addr;
   logic [1:0]      snake_body_horizontal_sprite_en;
  // body vertical
   logic [15:0]     snake_body_vertical_sprite_output;
   logic [9:0]      snake_body_vertical_sprite_addr;
   logic [1:0]      snake_body_vertical_sprite_en;

  // tail up
   logic [15:0]     snake_tail_up_sprite_output;
   logic [9:0]      snake_tail_up_sprite_addr;
   logic [1:0]      snake_tail_up_sprite_en;
  // tail down
   logic [15:0]     snake_tail_down_sprite_output;
   logic [9:0]      snake_tail_down_sprite_addr;
   logic [1:0]      snake_tail_down_sprite_en;
  // tail left
   logic [15:0]     snake_tail_left_sprite_output;
   logic [9:0]      snake_tail_left_sprite_addr;
   logic [1:0]      snake_tail_left_sprite_en;
  // tail right
   logic [15:0]     snake_tail_right_sprite_output;
   logic [9:0]      snake_tail_right_sprite_addr;
   logic [1:0]      snake_tail_right_sprite_en;

   // wall
   logic [15:0]     wall_sprite_output;
   logic [9:0]      wall_sprite_addr;
   logic [1:0]      wall_sprite_en;
	
   vga_counters counters(.clk50(clk), .*);
  
  //  apple  
   soc_system_apple_sprite apple_sprite(.address(apple_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(apple_sprite_output));
  //  face right
   soc_system_snake_head_right_sprite snake_head_right_sprite(.address(snake_head_right_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_head_right_sprite_output));
  //  face left
   soc_system_snake_head_left_sprite snake_head_left_sprite(.address(snake_head_left_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_head_left_sprite_output));
  //  face up
   soc_system_snake_head_up_sprite snake_head_up_sprite(.address(snake_head_up_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_head_up_sprite_output));
  //  face down
   soc_system_snake_head_down_sprite snake_head_down_sprite(.address(snake_head_down_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_head_down_sprite_output));

  // snake body
  // bottom left
   soc_system_snake_body_bottomleft_sprite snake_body_bottomleft_sprite(.address(snake_body_bottomleft_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_body_bottomleft_sprite_output));
  // bottom right
   soc_system_snake_body_bottomright_sprite snake_body_bottomright_sprite(.address(snake_body_bottomright_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_body_bottomright_sprite_output));
  // top left
   soc_system_snake_body_topleft_sprite snake_body_topleft_sprite(.address(snake_body_topleft_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_body_topleft_sprite_output));
  // top right
   soc_system_snake_body_topright_sprite snake_body_topright_sprite(.address(snake_body_topright_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_body_topright_sprite_output));

  // body horizontal
   soc_system_snake_body_horizontal_sprite snake_body_horizontal_sprite(.address(snake_body_horizontal_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_body_horizontal_sprite_output));
  // body vertical
   soc_system_snake_body_vertical_sprite snake_body_vertical_sprite(.address(snake_body_vertical_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_body_vertical_sprite_output));

  // tail up
   soc_system_snake_tail_up_sprite snake_tail_up_sprite(.address(snake_tail_up_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_tail_up_sprite_output));
  // tail down
   soc_system_snake_tail_down_sprite snake_tail_down_sprite(.address(snake_tail_down_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_tail_down_sprite_output));
  // tail left
   soc_system_snake_tail_left_sprite snake_tail_left_sprite(.address(snake_tail_left_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_tail_left_sprite_output));
  // tail right
  soc_system_snake_tail_right_sprite snake_tail_right_sprite(.address(snake_tail_right_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(snake_tail_right_sprite_output));
  // wall
  soc_system_wall_sprite wall_sprite(.address(wall_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(wall_sprite_output));


  //Register for the offsetting the screen
  reg [63:0] map [0:74]; // 75 register and each register is 64 bits wide


  reg [7:0] snake_head_pos_x;
  reg [7:0] snake_head_pos_y;

  reg [7:0] snake_head_up_pos_x;
  reg [7:0] snake_head_up_pos_y;

   always_ff @(posedge clk)
     if (reset) begin
      background_r <= 8'h0;
      background_g <= 8'h0;
      background_b <= 8'h0;
      snake_head_pos_x <= 8'b00001010;
      snake_head_pos_y <= 8'b00001010;
      d <= 8'b00001101;
      e <= 8'b00001010;

      
     end else if (chipselect && write)
      case (address)
      //  3'h0 : snake_head_pos_x <= writedata;
      //  3'h1 : snake_head_pos_y <= writedata;
      //  3'h2 : d <= writedata;
      //  3'h3 : e <= writedata;
      //  3'h4 : snake_head_up_pos_x <= writedata;
      //  3'h5 : snake_head_up_pos_y <= writedata;

      /* Using a 7 bit switch statement to write to each of the 75 registers */
        7'h0 : map[0] <= writedata;
        7'h1 : map[1] <= writedata;
        7'h2 : map[2] <= writedata;
        7'h3 : map[3] <= writedata;
        7'h4 : map[4] <= writedata;
        7'h5 : map[5] <= writedata;
        7'h6 : map[6] <= writedata;
        7'h7 : map[7] <= writedata;
        7'h8 : map[8] <= writedata;
        7'h9 : map[9] <= writedata;
        7'h0A : map[10] <= writedata;
        7'h0B : map[11] <= writedata;
        7'h0C : map[12] <= writedata;
        7'h0D : map[13] <= writedata;
        7'h0E : map[14] <= writedata;
        7'h0F : map[15] <= writedata;
        7'h10 : map[16] <= writedata;
        7'h11 : map[17] <= writedata;
        7'h12 : map[18] <= writedata;
        7'h13 : map[19] <= writedata;
        7'h14 : map[20] <= writedata;
        7'h15 : map[21] <= writedata;
        7'h16 : map[22] <= writedata;
        7'h17 : map[23] <= writedata;
        7'h18 : map[24] <= writedata;
        7'h19 : map[25] <= writedata;
        7'h1A : map[26] <= writedata;
        7'h1B : map[27] <= writedata;
        7'h1C : map[28] <= writedata;
        7'h1D : map[29] <= writedata;
        7'h1E : map[30] <= writedata;
        7'h1F : map[31] <= writedata;
        7'h20 : map[32] <= writedata;
        7'h21 : map[33] <= writedata;
        7'h22 : map[34] <= writedata;
        7'h23 : map[35] <= writedata;
        7'h24 : map[36] <= writedata;
        7'h25 : map[37] <= writedata;
        7'h26 : map[38] <= writedata;
        7'h27 : map[39] <= writedata;
        7'h28 : map[40] <= writedata;
        7'h29 : map[41] <= writedata;
        7'h2A : map[42] <= writedata;
        7'h2B : map[43] <= writedata;
        7'h2C : map[44] <= writedata;
        7'h2D : map[45] <= writedata;
        7'h2E : map[46] <= writedata;
        7'h2F : map[47] <= writedata;
        7'h30 : map[48] <= writedata;
        7'h31 : map[49] <= writedata;
        7'h32 : map[50] <= writedata;
        7'h33 : map[51] <= writedata;
        7'h34 : map[52] <= writedata;
        7'h35 : map[53] <= writedata;
        7'h36 : map[54] <= writedata;
        7'h37 : map[55] <= writedata;
        7'h38 : map[56] <= writedata;
        7'h39 : map[57] <= writedata;
        7'h3A : map[58] <= writedata;
        7'h3B : map[59] <= writedata;
        7'h3C : map[60] <= writedata;
        7'h3D : map[61] <= writedata;
        7'h3E : map[62] <= writedata;
        7'h3F : map[63] <= writedata;
        7'h40 : map[64] <= writedata;
        7'h41 : map[65] <= writedata;
        7'h42 : map[66] <= writedata;
        7'h43 : map[67] <= writedata;
        7'h44 : map[68] <= writedata;
        7'h45 : map[69] <= writedata;
        7'h46 : map[70] <= writedata;
        7'h47 : map[71] <= writedata;
        7'h48 : map[72] <= writedata;
        7'h49 : map[73] <= writedata;
        7'h4A : map[74] <= writedata;
        default: ;


       endcase

  //logic for generating vga output
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;

  reg [7:0] d;
  reg [7:0] e;

  reg [7:0] head_output1;
  reg [7:0] head_output2;
  reg [7:0] head_output3;

  
// -------------------------------------
always_ff @(posedge clk) begin

    //this is the snake fruit
    if (VGA_BLANK_n) begin
      if (hcount[10:5] == (d[5:0]-1) && hcount[4:1] >= 4'b1111 && vcount[9:4] == e[5:0]) begin //coordinates(10,10) 31
        apple_sprite_addr <= hcount[4:1] - 4'b1111 + (vcount[3:0])*16;
        a <= {apple_sprite_output[15:11], 3'b0};
        b <= { apple_sprite_output[10:5], 2'b0};
        c <= {apple_sprite_output[4:0], 3'b0};
      end else if (hcount[10:5] == d[5:0] && hcount[4:1] < 4'b1111 && vcount[9:4] == e[5:0]) begin
        apple_sprite_addr <=  hcount[4:1] + 4'b0001 + (vcount[3:0])*16;
        a <= {apple_sprite_output[15:11], 3'b0};
        b <= { apple_sprite_output[10:5], 2'b0};
        c <= {apple_sprite_output[4:0], 3'b0};
      end

      //snake head right
      
      else if (hcount[10:5] == (snake_head_pos_x[5:0]-1) && hcount[4:1] >= 4'b1111 && vcount[9:4] == snake_head_pos_y[5:0]) begin //coordinates(10,10) 31
        snake_head_right_sprite_addr <= hcount[4:1] - 4'b1111 + (vcount[3:0])*16;
        a <= {snake_head_right_sprite_output[15:11], 3'b0};
        b <= { snake_head_right_sprite_output[10:5], 2'b0};
        c <= {snake_head_right_sprite_output[4:0], 3'b0};
      end else if (hcount[10:5] == (snake_head_pos_x[5:0]) && hcount[4:1] < 4'b1111 && vcount[9:4] == snake_head_pos_y[5:0]) begin
        snake_head_right_sprite_addr <= hcount[4:1] - 4'b41111 + (vcount[3:0])*16;
        a <= {snake_head_right_sprite_output[15:11], 3'b0};
        b <= { snake_head_right_sprite_output[10:5], 2'b0};
        c <= {snake_head_right_sprite_output[4:0], 3'b0};
      end 

      //snake head up

       else if (hcount[10:5] == (snake_head_up_pos_x[5:0]-1) && hcount[4:1] >= 4'b1111 && vcount[9:4] == snake_head_up_pos_y[5:0]) begin //coordinates(10,10) 31
        snake_head_up_sprite_addr <= hcount[4:1] - 4'b1111 + (vcount[3:0])*16;
        a <= {snake_head_up_sprite_output[15:11], 3'b0};
        b <= { snake_head_up_sprite_output[10:5], 2'b0};
        c <= {snake_head_up_sprite_output[4:0], 3'b0};
      end else if (hcount[10:5] == (snake_head_up_pos_x[5:0]) && hcount[4:1] < 4'b1111 && vcount[9:4] == snake_head_up_pos_y[5:0]) begin
        snake_head_up_sprite_addr <= hcount[4:1] - 4'b41111 + (vcount[3:0])*16;
        a <= {snake_head_up_sprite_output[15:11], 3'b0};
        b <= { snake_head_up_sprite_output[10:5], 2'b0};
        c <= {snake_head_up_sprite_output[4:0], 3'b0};
      end
      /*
      //snake body
      else if (hcount[10:5] == (head_pos_x) && hcount[4:1] >= 4'b1111 && vcount[9:4] == head_pos_y) begin //coordinates(10,10) 31
        snake_body_horizontal_sprite_addr <= hcount[4:1] - 4'b1111 + (vcount[3:0])*16;
        a <= {snake_body_horizontal_sprite_output[15:11], 3'b0};
        b <= { snake_body_horizontal_sprite_output[10:5], 2'b0};
        c <= {snake_body_horizontal_sprite_output[4:0], 3'b0};
      end else if (hcount[10:5] == (head_pos_x + 1) && hcount[4:1] < 4'b1111 && vcount[9:4] == head_pos_y) begin
        snake_body_horizontal_sprite_addr <= hcount[4:1] - 4'b41111 + (vcount[3:0])*16;
        a <= {snake_body_horizontal_sprite_output[15:11], 3'b0};
        b <= { snake_body_horizontal_sprite_output[10:5], 2'b0};
        c <= {snake_body_horizontal_sprite_output[4:0], 3'b0};
      end

      //snake tail left
      else if (hcount[10:5] == (head_pos_x+1) && hcount[4:1] >= 4'b1111 && vcount[9:4] == head_pos_y) begin //coordinates(10,10) 31
        snake_tail_right_sprite_addr <= hcount[4:1] - 4'b1111 + (vcount[3:0])*16;
        a <= {snake_tail_right_sprite_output[15:11], 3'b0};
        b <= { snake_tail_right_sprite_output[10:5], 2'b0};
        c <= {snake_tail_right_sprite_output[4:0], 3'b0};
      end else if (hcount[10:5] == (head_pos_x + 2) && hcount[4:1] < 4'b1111 && vcount[9:4] == head_pos_y) begin
        snake_tail_right_sprite_addr <= hcount[4:1] - 4'b41111 + (vcount[3:0])*16;
        a <= {snake_tail_right_sprite_output[15:11], 3'b0};
        b <= { snake_tail_right_sprite_output[10:5], 2'b0};
        c <= {snake_tail_right_sprite_output[4:0], 3'b0};
      end
      */
      //wall
      /*
      else if (hcount[10:6] == 5'b00001-1 && hcount[5:1] >= 5'b11111 && vcount[9:5] == 5'b00001) begin //5,5,31
        wall_sprite_addr <= hcount[5:1] - 5'b11111 + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= { wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end else if (hcount[10:6] == 5'b00001-1 && hcount[5:1] < 5'b11111 && vcount[9:5] == 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] - 5'b11111 + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= { wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end*/

      //left
      else if(hcount[10:6] == 5'b00000 && vcount[9:5] > 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= { wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
        end 

      //right
      else if(hcount[10:6] == 5'b10011 && vcount[9:5] > 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= { wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end
      
      //top
      else if( vcount[9:5] == 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= { wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end 

      //bottom
      else if( vcount[9:5] == 5'b01110) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= { wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end 

      //this is where we put all of our snake head code by using an if else statement
      //well for starter we can start the head facing towards right
      /*
      else if (hcount[10:6] == (5'b00101-1) && hcount[5:1] >= 5'b11111 && vcount[9:5] == 5'b00101) begin //5,5,31
        apple_sprite_addr <= hcount[5:1] - 5'b11111 + (vcount[4:0])*32;
        a <= {apple_sprite_output[15:11], 3'b0};
        b <= { apple_sprite_output[10:5], 2'b0};
        c <= {apple_sprite_output[4:0], 3'b0};
      end else if (hcount[10:6] == 5'b00101-1 && hcount[5:1] < 5'b11111 && vcount[9:5] == 5'b00101) begin
        apple_sprite_addr <= hcount[5:1] - 5'b11111 + (vcount[4:0])*32;
        a <= {apple_sprite_output[15:11], 3'b0};
        b <= { apple_sprite_output[10:5], 2'b0};
        c <= {apple_sprite_output[4:0], 3'b0};
      end
      */
      else begin
        a <= background_r;
        b <= background_g;
        c <= background_b;
      end
    end
end

// Assign VGA outputs
assign {VGA_R, VGA_G, VGA_B} = {a, b, c};

//----------------------------------------------------------
// I think this is the original template code or lab3 our solution
/* 
always_comb begin
  {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h0}; // Initialize to black
  if (VGA_BLANK_n) begin
    if ((hcount[10:1]-(x+20))**2 + (vcount-(y+20))**2 <= 20**2) begin
		  {VGA_R, VGA_G, VGA_B} = {8'hff, 8'h00, 8'h00}; // Red color for circle
		end else begin
		  {VGA_R, VGA_G, VGA_B} = {background_r, background_g, background_b};
		end
	end
end
*/
       
endmodule

module vga_counters(
 input logic 	     clk50, reset,
 output logic [10:0] hcount,  // hcount[10:1] is pixel column
 output logic [9:0]  vcount,  // vcount[9:0] is pixel row
 output logic 	     VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n, VGA_SYNC_n);

/*
 * 640 X 480 VGA timing for a 50 MHz clock: one pixel every other cycle
 * 
 * HCOUNT 1599 0             1279       1599 0
 *             _______________              ________
 * ___________|    Video      |____________|  Video
 * 
 * 
 * |SYNC| BP |<-- HACTIVE -->|FP|SYNC| BP |<-- HACTIVE
 *       _______________________      _____________
 * |____|       VGA_HS          |____|
 */
   // Parameters for hcount
   parameter HACTIVE      = 11'd 1280,
             HFRONT_PORCH = 11'd 32,
             HSYNC        = 11'd 192,
             HBACK_PORCH  = 11'd 96,   
             HTOTAL       = HACTIVE + HFRONT_PORCH + HSYNC +
                            HBACK_PORCH; // 1600
   
   // Parameters for vcount
   parameter VACTIVE      = 10'd 480,
             VFRONT_PORCH = 10'd 10,
             VSYNC        = 10'd 2,
             VBACK_PORCH  = 10'd 33,
             VTOTAL       = VACTIVE + VFRONT_PORCH + VSYNC +
                            VBACK_PORCH; // 525

   logic endOfLine;
   
   always_ff @(posedge clk50 or posedge reset)
     if (reset)          hcount <= 0;
     else if (endOfLine) hcount <= 0;
     else  	         hcount <= hcount + 11'd 1;

   assign endOfLine = hcount == HTOTAL - 1;
       
   logic endOfField;
   
   always_ff @(posedge clk50 or posedge reset)
     if (reset)          vcount <= 0;
     else if (endOfLine)
       if (endOfField)   vcount <= 0;
       else              vcount <= vcount + 10'd 1;

   assign endOfField = vcount == VTOTAL - 1;

   // Horizontal sync: from 0x520 to 0x5DF (0x57F)
   // 101 0010 0000 to 101 1101 1111
   assign VGA_HS = !( (hcount[10:8] == 3'b101) &
		      !(hcount[7:5] == 3'b111));
   assign VGA_VS = !( vcount[9:1] == (VACTIVE + VFRONT_PORCH) / 2);

   assign VGA_SYNC_n = 1'b0; // For putting sync on the green signal; unused
   
   // Horizontal active: 0 to 1279     Vertical active: 0 to 479
   // 101 0000 0000  1280	       01 1110 0000  480
   // 110 0011 1111  1599	       10 0000 1100  524
   assign VGA_BLANK_n = !( hcount[10] & (hcount[9] | hcount[8]) ) &
			!( vcount[9] | (vcount[8:5] == 4'b1111) );

   /* VGA_CLK is 25 MHz
    *             __    __    __
    * clk50    __|  |__|  |__|
    *        
    *             _____       __
    * hcount[0]__|     |_____|
    */
   assign VGA_CLK = hcount[0]; // 25 MHz clock: rising edge sensitive
   
endmodule
