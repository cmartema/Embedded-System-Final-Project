/*
 * Avalon memory-mapped peripheral that generates VGA
 *
 * Stephen A. Edwards
 * Columbia University
 */

module vga_ball(
    input logic         clk,
	  input logic 	      reset,
		input logic [31:0]   writedata,
		input logic 	      write,
		input 		          chipselect,
		input logic [7:0]   address,

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
  //reg [63:0] map [0:74]; // 75 register and each register is 64 bits wide

  


  reg [7:0] snake_head_pos_x;
  reg [7:0] snake_head_pos_y;

  reg [7:0] snake_head_up_pos_x;
  reg [7:0] snake_head_up_pos_y;

  reg [7:0] x_pos;
  reg [7:0] y_pos;
  reg [7:0] sprite_type;

  int map [39:0][29:0];
  
  always_ff @(posedge clk) begin
    if (reset) begin
      background_r <= 8'h0;
      background_g <= 8'h0;
      background_b <= 8'h0;
      snake_head_pos_x <= 8'b00001010;
      snake_head_pos_y <= 8'b00001010;
      snake_head_up_pos_x <= 8'b1111;
      snake_head_up_pos_y <= 8'b1111;
    end 
    else if (chipselect && write) begin
      case (address)
        8'h0 : {map[0][0], map[0][1], map[0][2], map[0][3], map[0][4], map[0][5], map[0][6], map[0][7]} <= writedata;
        8'h1 : {map[0][8], map[0][9], map[0][10], map[0][11], map[0][12], map[0][13], map[0][14], map[0][15]} <= writedata;
        8'h2 : {map[0][16], map[0][17], map[0][18], map[0][19], map[0][20], map[0][21], map[0][22], map[0][23]} <= writedata;
        8'h3 : {map[0][24], map[0][25], map[0][26], map[0][27], map[0][28], map[0][29], map[1][0], map[1][1]} <= writedata;
        8'h4 : {map[1][2], map[1][3], map[1][4], map[1][5], map[1][6], map[1][7], map[1][8], map[1][9]} <= writedata;
        8'h5 : {map[1][10], map[1][11], map[1][12], map[1][13], map[1][14], map[1][15], map[1][16], map[1][17]} <= writedata;
        8'h6 : {map[1][18], map[1][19], map[1][20], map[1][21], map[1][22], map[1][23], map[1][24], map[1][25]} <= writedata;
        8'h7 : {map[1][26], map[1][27], map[1][28], map[1][29], map[2][0], map[2][1], map[2][2], map[2][3]} <= writedata;
        8'h8 : {map[2][4], map[2][5], map[2][6], map[2][7], map[2][8], map[2][9], map[2][10], map[2][11]} <= writedata;
        8'h9 : {map[2][12], map[2][13], map[2][14], map[2][15], map[2][16], map[2][17], map[2][18], map[2][19]} <= writedata;
        8'ha : {map[2][20], map[2][21], map[2][22], map[2][23], map[2][24], map[2][25], map[2][26], map[2][27]} <= writedata;
        8'hb : {map[2][28], map[2][29], map[3][0], map[3][1], map[3][2], map[3][3], map[3][4], map[3][5]} <= writedata;
        8'hc : {map[3][6], map[3][7], map[3][8], map[3][9], map[3][10],map[3][], map[3][11], map[3][12]} <= writedata;
        8'hd : {map[3][13], map[3][14], map[3][15], map[3][16], map[3][17],map[3][18], map[3][19], map[3][20]} <= writedata;
        8'h2 : {map[3][21], map[3][22], map[3][23], map[3][24], map[3][25],map[3][26], map[3][27], map[3][28]} <= writedata;
        8'h0 : {map[3][29], map[4][0], map[4][1], map[4][2], map[4][3],map[4][4], map[4][5], map[4][6]} <= writedata;
        8'h1 : {map[4][7], map[4][8], map[4][9], map[4][10], map[4][11],map[4][12], map[4][13], map[4][14]} <= writedata;
        8'h2 : {map[4][15], map[4][16], map[4][17], map[4][18], map[4][19],map[4][20], map[4][21], map[4][22]} <= writedata;
        8'h0 : {map[4][23], map[4][24], map[4][25], map[4][26], map[4][27],map[4][28], map[4][29], map[5][0]} <= writedata;
        8'h1 : {map[5][1], map[5][2], map[5][3], map[5][4], map[5][5],map[5][6], map[5][7], map[5][8]} <= writedata;
        8'h2 : {map[5][9], map[5][10], map[5][11], map[5][12], map[5][13],map[5][14], map[5][15], map[5][16]} <= writedata;
        8'h0 : {map[5][17], map[5][18], map[5][11], map[5][19], map[5][20],map[5][21], map[5][22], map[5][23]} <= writedata;
        8'h1 : {map[5][24], map[5][25], map[5][26], map[5][27], map[5][28],map[5][29], map[6][0], map[6][1]} <= writedata;
        8'h2 : {map[6][2], map[6][3], map[6][4], map[6][5], map[6][6], map[6][7], map[6][8], map[6][9]} <= writedata;
      endcase
      // map[x_pos][y_pos] <= sprite_type;
   end
   map[x_pos][y_pos] <= sprite_type;
  end
   
  //logic for generating vga output
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;

  reg [7:0] apple_x;
  reg [7:0] apple_y;

  reg [7:0] head_output1;
  reg [7:0] head_output2;
  reg [7:0] head_output3;
   
  // -------------------------------------
  always_ff @(posedge clk) begin
    
    //this is the snake fruit
    if (VGA_BLANK_n) begin
      if (map[hcount[10:5]][vcount[9:4]] == 8'b1) begin
        apple_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {apple_sprite_output[15:11], 3'b0};
        b <= {apple_sprite_output[10:5], 2'b0};
        c <= {apple_sprite_output[4:0], 3'b0};
      end 
      // this is snake head right 
      else if (map[{2'b00, hcount[10:5]}][{2'b00, vcount[9:4]}] == 8'b10) begin
        snake_head_right_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_head_right_sprite_output[15:11], 3'b0};
        b <= {snake_head_right_sprite_output[10:5], 2'b0};
        c <= {snake_head_right_sprite_output[4:0], 3'b0};
      end 
      else if (map[{2'b00, hcount[10:5]}][{2'b00, vcount[9:4]}] == 8'b11) begin
        snake_body_horizontal_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_horizontal_sprite_output[15:11], 3'b0};
        b <= {snake_body_horizontal_sprite_output[10:5], 2'b0};
        c <= {snake_body_horizontal_sprite_output[4:0], 3'b0};
      end
      //left wall column
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
      else begin
        a <= background_r;
        b <= background_g;
        c <= background_b;
      end
    end 
  end 
// Assign VGA outputs
assign {VGA_R, VGA_G, VGA_B} = {a, b, c}; 


endmodule

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