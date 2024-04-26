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

   always_ff @(posedge clk)
     if (reset) begin
      background_r <= 8'h0;
      background_g <= 8'h0;
      background_b <= 8'h0;
     end else if (chipselect && write)
       case (address)
    
   
       3'h0 : background_r <= writedata;
       3'h1 : background_g <= writedata;
       3'h2 : background_b <= writedata;
       3'h3 : d <= writedata;
       3'h4 : e <= writedata;

    
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

  reg [5:0] head_pos_x = 6'b001111;
  reg [5:0] head_pos_y = 6'b001010;
  
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

      //snake head left
      
      else if (hcount[10:5] == (head_pos_x-1) && hcount[4:1] >= 4'b1111 && vcount[9:4] == head_pos_y) begin //coordinates(10,10) 31
        snake_head_left_sprite_addr <= hcount[4:1] - 4'b1111 + (vcount[3:0])*16;
        a <= {snake_head_left_sprite_output[15:11], 3'b0};
        b <= { snake_head_left_sprite_output[10:5], 2'b0};
        c <= {snake_head_left_sprite_output[4:0], 3'b0};
      end else if (hcount[10:5] == (head_pos_x) && hcount[4:1] < 4'b1111 && vcount[9:4] == head_pos_y) begin
        snake_head_left_sprite_addr <= hcount[4:1] - 4'b41111 + (vcount[3:0])*16;
        a <= {snake_head_left_sprite_output[15:11], 3'b0};
        b <= { snake_head_left_sprite_output[10:5], 2'b0};
        c <= {snake_head_left_sprite_output[4:0], 3'b0};
      end 
      
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
