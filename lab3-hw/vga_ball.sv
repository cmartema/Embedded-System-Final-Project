<<<<<<< HEAD
=======
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
		input logic [8:0]   address,

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

   // zero
   logic [15:0]     zero_sprite_output;
   logic [9:0]      zero_sprite_addr;
   logic [1:0]      zero_sprite_en;

   // one
   logic [15:0]     one_sprite_output;
   logic [9:0]      one_sprite_addr;
   logic [1:0]      one_sprite_en;

   // two
   logic [15:0]     two_sprite_output;
   logic [9:0]      two_sprite_addr;
   logic [1:0]      two_sprite_en;

   // three
   logic [15:0]     three_sprite_output;
   logic [9:0]      three_sprite_addr;
   logic [1:0]      three_sprite_en;

   // four
   logic [15:0]     four_sprite_output;
   logic [9:0]      four_sprite_addr;
   logic [1:0]      four_sprite_en;

   // five
   logic [15:0]     five_sprite_output;
   logic [9:0]      five_sprite_addr;
   logic [1:0]      five_sprite_en;

   // six
   logic [15:0]     six_sprite_output;
   logic [9:0]      six_sprite_addr;
   logic [1:0]      six_sprite_en;

   // seven
   logic [15:0]     seven_sprite_output;
   logic [9:0]      seven_sprite_addr;
   logic [1:0]      seven_sprite_en;

   // eight
   logic [15:0]     eight_sprite_output;
   logic [9:0]      eight_sprite_addr;
   logic [1:0]      eight_sprite_en;

   // nine
   logic [15:0]     nine_sprite_output;
   logic [9:0]      nine_sprite_addr;
   logic [1:0]      nine_sprite_en;
	
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
  
  // zero
  soc_system_zero_sprite zero_sprite(.address(zero_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(zero_sprite_output));
  // one
  soc_system_one_sprite one_sprite(.address(one_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(one_sprite_output));
  // two
  soc_system_two_sprite two_sprite(.address(two_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(two_sprite_output));
  // three
  soc_system_three_sprite three_sprite(.address(three_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(three_sprite_output));
  // four
  soc_system_four_sprite four_sprite(.address(four_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(four_sprite_output));
  // five
  soc_system_five_sprite five_sprite(.address(five_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(five_sprite_output));
  // six
  //soc_system_six_sprite six_sprite(.address(six_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(six_sprite_output));
  // seven
  soc_system_seven_sprite seven_sprite(.address(seven_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(seven_sprite_output));
  // eight
  soc_system_eight_sprite eight_sprite(.address(eight_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(eight_sprite_output));
  // nine
  soc_system_nine_sprite nine_sprite(.address(nine_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(nine_sprite_output));
  
  


  reg [7:0] snake_head_pos_x;
  reg [7:0] snake_head_pos_y;

  reg [7:0] snake_head_up_pos_x;
  reg [7:0] snake_head_up_pos_y;

  reg [7:0] x_pos;
  reg [7:0] y_pos;
  reg [7:0] sprite_type;

  reg [7:0] map [39:0][29:0];
  reg [8:0] x_offset;
  reg [8:0] y_offset;
  
  always_ff @(posedge clk) begin
    if (reset) begin
      background_r <= 8'h0;
      background_g <= 8'h0;
      background_b <= 8'h0;
      snake_head_pos_x <= 8'b00001010;
      snake_head_pos_y <= 8'b00001010;
      snake_head_up_pos_x <= 8'b1111;
      snake_head_up_pos_y <= 8'b1111;
      x_offset <= 9'b0;
      y_offset <= 9'b0;
    end 
    else if (chipselect && write) begin
      case (address)      
        9'h0 : {map[0][0], map[1][0], map[2][0], map[3][0]} <= writedata;
        9'h1 : {map[4][0], map[5][0], map[6][0], map[7][0]} <= writedata;
        9'h2 : {map[8][0], map[9][0], map[10][0], map[11][0]} <= writedata;
        9'h3 : {map[12][0], map[13][0], map[14][0], map[15][0]} <= writedata;
        9'h4 : {map[16][0], map[17][0], map[18][0], map[19][0]} <= writedata;
        9'h5 : {map[20][0], map[21][0], map[22][0], map[23][0]} <= writedata;
        9'h6 : {map[24][0], map[25][0], map[26][0], map[27][0]} <= writedata;
        9'h7 : {map[28][0], map[29][0], map[30][0], map[31][0]} <= writedata;
        9'h8 : {map[32][0], map[33][0], map[34][0], map[35][0]} <= writedata;
        9'h9 : {map[36][0], map[37][0], map[38][0], map[39][0]} <= writedata;

        9'ha : {map[0][1], map[1][1], map[2][1], map[3][1]} <= writedata;
        9'hb : {map[4][1], map[5][1], map[6][1], map[7][1]} <= writedata;
        9'hc : {map[8][1], map[9][1], map[10][1], map[11][1]} <= writedata;
        9'hd : {map[12][1], map[13][1], map[14][1], map[15][1]} <= writedata;
        9'he : {map[16][1], map[17][1], map[18][1], map[19][1]} <= writedata;
        9'hf : {map[20][1], map[21][1], map[22][1], map[23][1]} <= writedata;
        9'h10 : {map[24][1], map[25][1], map[26][1], map[27][1]} <= writedata;
        9'h11 : {map[28][1], map[29][1], map[30][1], map[31][1]} <= writedata;
        9'h12 : {map[32][1], map[33][1], map[34][1], map[35][1]} <= writedata;
        9'h13 : {map[36][1], map[37][1], map[38][1], map[39][1]} <= writedata;

        9'h14 : {map[0][2], map[1][2], map[2][2], map[3][2]} <= writedata;
        9'h15 : {map[4][2], map[5][2], map[6][2], map[7][2]} <= writedata;
        9'h16 : {map[8][2], map[9][2], map[10][2], map[11][2]} <= writedata;
        9'h17 : {map[12][2], map[13][2], map[14][2], map[15][2]} <= writedata;
        9'h18 : {map[16][2], map[17][2], map[18][2], map[19][2]} <= writedata;
        9'h19 : {map[20][2], map[21][2], map[22][2], map[23][2]} <= writedata;
        9'h1a : {map[24][2], map[25][2], map[26][2], map[27][2]} <= writedata;
        9'h1b : {map[28][2], map[29][2], map[30][2], map[31][2]} <= writedata;
        9'h1c : {map[32][2], map[33][2], map[34][2], map[35][2]} <= writedata;
        9'h1d : {map[36][2], map[37][2], map[38][2], map[39][2]} <= writedata;

        9'h1e : {map[0][3], map[1][3], map[2][3], map[3][3]} <= writedata;
        9'h1f : {map[4][3], map[5][3], map[6][3], map[7][3]} <= writedata;
        9'h20 : {map[8][3], map[9][3], map[10][3], map[11][3]} <= writedata;
        9'h21 : {map[12][3], map[13][3], map[14][3], map[15][3]} <= writedata;
        9'h22 : {map[16][3], map[17][3], map[18][3], map[19][3]} <= writedata;
        9'h23 : {map[20][3], map[21][3], map[22][3], map[23][3]} <= writedata;
        9'h24 : {map[24][3], map[25][3], map[26][3], map[27][3]} <= writedata;
        9'h25 : {map[28][3], map[29][3], map[30][3], map[31][3]} <= writedata;
        9'h26 : {map[32][3], map[33][3], map[34][3], map[35][3]} <= writedata;
        9'h27 : {map[36][3], map[37][3], map[38][3], map[39][3]} <= writedata;

        9'h28 : {map[0][4], map[1][4], map[2][4], map[3][4]} <= writedata;
        9'h29 : {map[4][4], map[5][4], map[6][4], map[7][4]} <= writedata;
        9'h2a : {map[8][4], map[9][4], map[10][4], map[11][4]} <= writedata;
        9'h2b : {map[12][4], map[13][4], map[14][4], map[15][4]} <= writedata;
        9'h2c : {map[16][4], map[17][4], map[18][4], map[19][4]} <= writedata;
        9'h2d : {map[20][4], map[21][4], map[22][4], map[23][4]} <= writedata;
        9'h2e : {map[24][4], map[25][4], map[26][4], map[27][4]} <= writedata;
        9'h2f : {map[28][4], map[29][4], map[30][4], map[31][4]} <= writedata;
        9'h30 : {map[32][4], map[33][4], map[34][4], map[35][4]} <= writedata;
        9'h31 : {map[36][4], map[37][4], map[38][4], map[39][4]} <= writedata;

        9'h32 : {map[0][5], map[1][5], map[2][5], map[3][5]} <= writedata;
        9'h33 : {map[4][5], map[5][5], map[6][5], map[7][5]} <= writedata;
        9'h34 : {map[8][5], map[9][5], map[10][5], map[11][5]} <= writedata;
        9'h35 : {map[12][5], map[13][5], map[14][5], map[15][5]} <= writedata;
        9'h36 : {map[16][5], map[17][5], map[18][5], map[19][5]} <= writedata;
        9'h37 : {map[20][5], map[21][5], map[22][5], map[23][5]} <= writedata;
        9'h38 : {map[24][5], map[25][5], map[26][5], map[27][5]} <= writedata;
        9'h39 : {map[28][5], map[29][5], map[30][5], map[31][5]} <= writedata;
        9'h3a : {map[32][5], map[33][5], map[34][5], map[35][5]} <= writedata;
        9'h3b : {map[36][5], map[37][5], map[38][5], map[39][5]} <= writedata;

        9'h3c : {map[0][6], map[1][6], map[2][6], map[3][6]} <= writedata;
        9'h3d : {map[4][6], map[5][6], map[6][6], map[7][6]} <= writedata;
        9'h3e : {map[8][6], map[9][6], map[10][6], map[11][6]} <= writedata;
        9'h3f : {map[12][6], map[13][6], map[14][6], map[15][6]} <= writedata;
        9'h40 : {map[16][6], map[17][6], map[18][6], map[19][6]} <= writedata;
        9'h41 : {map[20][6], map[21][6], map[22][6], map[23][6]} <= writedata;
        9'h42 : {map[24][6], map[25][6], map[26][6], map[27][6]} <= writedata;
        9'h43 : {map[28][6], map[29][6], map[30][6], map[31][6]} <= writedata;
        9'h44 : {map[32][6], map[33][6], map[34][6], map[35][6]} <= writedata;
        9'h45 : {map[36][6], map[37][6], map[38][6], map[39][6]} <= writedata;


        9'h46 : {map[0][7], map[1][7], map[2][7], map[3][7]} <= writedata;
        9'h47 : {map[4][7], map[5][7], map[6][7], map[7][7]} <= writedata;
        9'h48 : {map[8][7], map[9][7], map[10][7], map[11][7]} <= writedata;
        9'h49 : {map[12][7], map[13][7], map[14][7], map[15][7]} <= writedata;
        9'h4a : {map[16][7], map[17][7], map[18][7], map[19][7]} <= writedata;
        9'h4b : {map[20][7], map[21][7], map[22][7], map[23][7]} <= writedata;
        9'h4c : {map[24][7], map[25][7], map[26][7], map[27][7]} <= writedata;
        9'h4d : {map[28][7], map[29][7], map[30][7], map[31][7]} <= writedata;
        9'h4e : {map[32][7], map[33][7], map[34][7], map[35][7]} <= writedata;
        9'h4f : {map[36][7], map[37][7], map[38][7], map[39][7]} <= writedata;

        9'h50 : {map[0][8], map[1][8], map[2][8], map[3][8]} <= writedata;
        9'h51 : {map[4][8], map[5][8], map[6][8], map[7][8]} <= writedata;
        9'h52 : {map[8][8], map[9][8], map[10][8], map[11][8]} <= writedata;
        9'h53 : {map[12][8], map[13][8], map[14][8], map[15][8]} <= writedata;
        9'h54 : {map[16][8], map[17][8], map[18][8], map[19][8]} <= writedata;
        9'h55 : {map[20][8], map[21][8], map[22][8], map[23][8]} <= writedata;
        9'h56 : {map[24][8], map[25][8], map[26][8], map[27][8]} <= writedata;
        9'h57 : {map[28][8], map[29][8], map[30][8], map[31][8]} <= writedata;
        9'h58 : {map[32][8], map[33][8], map[34][8], map[35][8]} <= writedata;
        9'h59 : {map[36][8], map[37][8], map[38][8], map[39][8]} <= writedata;

        9'h5a : {map[0][9], map[1][9], map[2][9], map[3][9]} <= writedata;
        9'h5b : {map[4][9], map[5][9], map[6][9], map[7][9]} <= writedata;
        9'h5c : {map[8][9], map[9][9], map[10][9], map[11][9]} <= writedata;
        9'h5d : {map[12][9], map[13][9], map[14][9], map[15][9]} <= writedata;
        9'h5e : {map[16][9], map[17][9], map[18][9], map[19][9]} <= writedata;
        9'h5f : {map[20][9], map[21][9], map[22][9], map[23][9]} <= writedata;
        9'h60 : {map[24][9], map[25][9], map[26][9], map[27][9]} <= writedata;
        9'h61 : {map[28][9], map[29][9], map[30][9], map[31][9]} <= writedata;
        9'h62 : {map[32][9], map[33][9], map[34][9], map[35][9]} <= writedata;
        9'h63 : {map[36][9], map[37][9], map[38][9], map[39][9]} <= writedata;

        9'h64 : {map[0][10], map[1][10], map[2][10], map[3][10]} <= writedata;
        9'h65 : {map[4][10], map[5][10], map[6][10], map[7][10]} <= writedata;
        9'h66 : {map[8][10], map[9][10], map[10][10], map[11][10]} <= writedata;
        9'h67 : {map[12][10], map[13][10], map[14][10], map[15][10]} <= writedata;
        9'h68 : {map[16][10], map[17][10], map[18][10], map[19][10]} <= writedata;
        9'h69 : {map[20][10], map[21][10], map[22][10], map[23][10]} <= writedata;
        9'h6a : {map[24][10], map[25][10], map[26][10], map[27][10]} <= writedata;
        9'h6b : {map[28][10], map[29][10], map[30][10], map[31][10]} <= writedata;
        9'h6c : {map[32][10], map[33][10], map[34][10], map[35][10]} <= writedata;
        9'h6d : {map[36][10], map[37][10], map[38][10], map[39][10]} <= writedata;

        9'h6e : {map[0][11], map[1][11], map[2][11], map[3][11]} <= writedata;
        9'h6f : {map[4][11], map[5][11], map[6][11], map[7][11]} <= writedata;
        9'h70 : {map[8][11], map[9][11], map[10][11], map[11][11]} <= writedata;
        9'h71 : {map[12][11], map[13][11], map[14][11], map[15][11]} <= writedata;
        9'h72 : {map[16][11], map[17][11], map[18][11], map[19][11]} <= writedata;
        9'h73 : {map[20][11], map[21][11], map[22][11], map[23][11]} <= writedata;
        9'h74 : {map[24][11], map[25][11], map[26][11], map[27][11]} <= writedata;
        9'h75 : {map[28][11], map[29][11], map[30][11], map[31][11]} <= writedata;
        9'h76 : {map[32][11], map[33][11], map[34][11], map[35][11]} <= writedata;
        9'h77 : {map[36][11], map[37][11], map[38][11], map[39][11]} <= writedata;

        9'h78 : {map[0][12], map[1][12], map[2][12], map[3][12]} <= writedata;
        9'h79 : {map[4][12], map[5][12], map[6][12], map[7][12]} <= writedata;
        9'h7a : {map[8][12], map[9][12], map[10][12], map[11][12]} <= writedata;
        9'h7b : {map[12][12], map[13][12], map[14][12], map[15][12]} <= writedata;
        9'h7c : {map[16][12], map[17][12], map[18][12], map[19][12]} <= writedata;
        9'h7d : {map[20][12], map[21][12], map[22][12], map[23][12]} <= writedata;
        9'h7e : {map[24][12], map[25][12], map[26][12], map[27][12]} <= writedata;
        9'h7f : {map[28][12], map[29][12], map[30][12], map[31][12]} <= writedata;
        9'h80 : {map[32][12], map[33][12], map[34][12], map[35][12]} <= writedata;
        9'h81 : {map[36][12], map[37][12], map[38][12], map[39][12]} <= writedata;

        9'h82 : {map[0][13], map[1][13], map[2][13], map[3][13]} <= writedata;
        9'h83 : {map[4][13], map[5][13], map[6][13], map[7][13]} <= writedata;
        9'h84 : {map[8][13], map[9][13], map[10][13], map[11][13]} <= writedata;
        9'h85 : {map[12][13], map[13][13], map[14][13], map[15][13]} <= writedata;
        9'h86 : {map[16][13], map[17][13], map[18][13], map[19][13]} <= writedata;
        9'h87 : {map[20][13], map[21][13], map[22][13], map[23][13]} <= writedata;
        9'h88 : {map[24][13], map[25][13], map[26][13], map[27][13]} <= writedata;
        9'h89 : {map[28][13], map[29][13], map[30][13], map[31][13]} <= writedata;
        9'h8a : {map[32][13], map[33][13], map[34][13], map[35][13]} <= writedata;
        9'h8b : {map[36][13], map[37][13], map[38][13], map[39][13]} <= writedata;

        9'h8c : {map[0][14], map[1][14], map[2][14], map[3][14]} <= writedata;
        9'h8d : {map[4][14], map[5][14], map[6][14], map[7][14]} <= writedata;
        9'h8e : {map[8][14], map[9][14], map[10][14], map[11][14]} <= writedata;
        9'h8f : {map[12][14], map[13][14], map[14][14], map[15][14]} <= writedata;
        9'h90 : {map[16][14], map[17][14], map[18][14], map[19][14]} <= writedata;
        9'h91 : {map[20][14], map[21][14], map[22][14], map[23][14]} <= writedata;
        9'h92 : {map[24][14], map[25][14], map[26][14], map[27][14]} <= writedata;
        9'h93 : {map[28][14], map[29][14], map[30][14], map[31][14]} <= writedata;
        9'h94 : {map[32][14], map[33][14], map[34][14], map[35][14]} <= writedata;
        9'h95 : {map[36][14], map[37][14], map[38][14], map[39][14]} <= writedata;

        9'h96 : {map[0][15], map[1][15], map[2][15], map[3][15]} <= writedata;
        9'h97 : {map[4][15], map[5][15], map[6][15], map[7][15]} <= writedata;
        9'h98 : {map[8][15], map[9][15], map[10][15], map[11][15]} <= writedata;
        9'h99 : {map[12][15], map[13][15], map[14][15], map[15][15]} <= writedata;
        9'h9a : {map[16][15], map[17][15], map[18][15], map[19][15]} <= writedata;
        9'h9b : {map[20][15], map[21][15], map[22][15], map[23][15]} <= writedata;
        9'h9c : {map[24][15], map[25][15], map[26][15], map[27][15]} <= writedata;
        9'h9d : {map[28][15], map[29][15], map[30][15], map[31][15]} <= writedata;
        9'h9e : {map[32][15], map[33][15], map[34][15], map[35][15]} <= writedata;
        9'h9f : {map[36][15], map[37][15], map[38][15], map[39][15]} <= writedata;

        9'ha0 : {map[0][16], map[1][16], map[2][16], map[3][16]} <= writedata;
        9'ha1 : {map[4][16], map[5][16], map[6][16], map[7][16]} <= writedata;
        9'ha2 : {map[8][16], map[9][16], map[10][16], map[11][16]} <= writedata;
        9'ha3 : {map[12][16], map[13][16], map[14][16], map[15][16]} <= writedata;
        9'ha4 : {map[16][16], map[17][16], map[18][16], map[19][16]} <= writedata;
        9'ha5 : {map[20][16], map[21][16], map[22][16], map[23][16]} <= writedata;
        9'ha6 : {map[24][16], map[25][16], map[26][16], map[27][16]} <= writedata;
        9'ha7 : {map[28][16], map[29][16], map[30][16], map[31][16]} <= writedata;
        9'ha8 : {map[32][16], map[33][16], map[34][16], map[35][16]} <= writedata;
        9'ha9 : {map[36][16], map[37][16], map[38][16], map[39][16]} <= writedata;

        9'haa : {map[0][17], map[1][17], map[2][17], map[3][17]} <= writedata;
        9'hab : {map[4][17], map[5][17], map[6][17], map[7][17]} <= writedata;
        9'hac : {map[8][17], map[17][9], map[10][17], map[11][17]} <= writedata;
        9'had : {map[12][17], map[13][17], map[14][17], map[15][17]} <= writedata;
        9'hae : {map[16][17], map[17][17], map[18][17], map[19][17]} <= writedata;
        9'haf : {map[20][17], map[21][17], map[22][17], map[23][17]} <= writedata;
        9'hb0 : {map[24][17], map[25][17], map[26][17], map[27][17]} <= writedata;
        9'hb1 : {map[28][17], map[29][17], map[30][17], map[31][17]} <= writedata;
        9'hb2 : {map[32][17], map[33][17], map[34][17], map[35][17]} <= writedata;
        9'hb3 : {map[36][17], map[37][17], map[38][17], map[39][17]} <= writedata;

        9'hb4 : {map[0][18], map[1][18], map[2][18], map[3][18]} <= writedata;
        9'hb5 : {map[4][18], map[5][18], map[6][18], map[7][18]} <= writedata;
        9'hb6 : {map[8][18], map[9][18], map[10][18], map[11][18]} <= writedata;
        9'hb7 : {map[12][18], map[13][18], map[14][18], map[15][18]} <= writedata;
        9'hb8 : {map[16][18], map[17][18], map[18][18], map[19][18]} <= writedata;
        9'hb9 : {map[20][18], map[21][18], map[22][18], map[23][18]} <= writedata;
        9'hba : {map[24][18], map[25][18], map[26][18], map[27][18]} <= writedata;
        9'hbb : {map[28][18], map[29][18], map[30][18], map[31][18]} <= writedata;
        9'hbc : {map[32][18], map[33][18], map[34][18], map[35][18]} <= writedata;
        9'hbd : {map[36][18], map[37][18], map[38][18], map[39][18]} <= writedata;

        9'hbe : {map[0][19], map[1][19], map[2][19], map[3][19]} <= writedata;
        9'hbf : {map[4][19], map[5][19], map[6][19], map[7][19]} <= writedata;
        9'he0 : {map[8][19], map[9][19], map[10][19], map[11][19]} <= writedata;
        9'hc1 : {map[12][19], map[13][19], map[14][19], map[15][19]} <= writedata;
        9'hc2 : {map[16][19], map[17][19], map[18][19], map[19][19]} <= writedata;
        9'hc3 : {map[20][19], map[21][19], map[22][19], map[23][19]} <= writedata;
        9'hc4 : {map[24][19], map[25][19], map[26][19], map[27][19]} <= writedata;
        9'hc5 : {map[28][19], map[29][19], map[30][19], map[31][19]} <= writedata;
        9'hc6 : {map[32][19], map[33][19], map[34][19], map[35][19]} <= writedata;
        9'hc7 : {map[36][19], map[37][19], map[38][19], map[39][19]} <= writedata;

        9'hc8 : {map[0][20], map[1][20], map[2][20], map[3][20]} <= writedata;
        9'hc9 : {map[4][20], map[5][20], map[6][20], map[7][20]} <= writedata;
        9'hca : {map[8][20], map[9][20], map[10][20], map[11][20]} <= writedata;
        9'hcb : {map[12][20], map[13][20], map[14][20], map[15][20]} <= writedata;
        9'hcc : {map[16][20], map[17][20], map[18][20], map[19][20]} <= writedata;
        9'hcd : {map[20][20], map[21][20], map[22][20], map[23][20]} <= writedata;
        9'hce : {map[24][20], map[25][20], map[26][20], map[27][20]} <= writedata;
        9'hcf : {map[28][20], map[29][20], map[30][20], map[31][20]} <= writedata;
        9'hd0 : {map[32][20], map[33][20], map[34][20], map[35][20]} <= writedata;
        9'hd1 : {map[36][20], map[37][20], map[38][20], map[39][20]} <= writedata;

        9'hd2 : {map[0][21], map[1][21], map[2][21], map[3][21]} <= writedata;
        9'hd3 : {map[4][21], map[5][21], map[6][21], map[7][21]} <= writedata;
        9'hd4 : {map[8][21], map[9][21], map[10][21], map[11][21]} <= writedata;
        9'hd5 : {map[12][21], map[13][21], map[14][21], map[15][21]} <= writedata;
        9'hd6 : {map[16][21], map[17][21], map[18][21], map[19][21]} <= writedata;
        9'hd7 : {map[20][21], map[21][21], map[22][21], map[23][21]} <= writedata;
        9'hd8 : {map[24][21], map[25][21], map[26][21], map[27][21]} <= writedata;
        9'hd9 : {map[28][21], map[29][21], map[30][21], map[31][21]} <= writedata;
        9'hda : {map[32][21], map[33][21], map[34][21], map[35][21]} <= writedata;
        9'hdb : {map[36][21], map[37][21], map[38][21], map[39][21]} <= writedata;

        9'hdc : {map[0][22], map[1][22], map[2][22], map[3][22]} <= writedata;
        9'hdd : {map[4][22], map[5][22], map[6][22], map[7][22]} <= writedata;
        9'hde : {map[8][22], map[9][22], map[10][22], map[11][22]} <= writedata;
        9'hdf : {map[12][22], map[13][22], map[14][22], map[15][22]} <= writedata;
        9'he0 : {map[16][22], map[17][22], map[18][22], map[19][22]} <= writedata;
        9'he1 : {map[20][22], map[21][22], map[22][22], map[23][22]} <= writedata;
        9'he2 : {map[24][22], map[25][22], map[26][22], map[27][22]} <= writedata;
        9'he3 : {map[28][22], map[29][22], map[30][22], map[31][22]} <= writedata;
        9'he4 : {map[32][22], map[33][22], map[34][22], map[35][22]} <= writedata;
        9'he5 : {map[36][22], map[37][22], map[38][22], map[39][22]} <= writedata;

        9'he6 : {map[0][23], map[1][23], map[2][23], map[3][23]} <= writedata;
        9'he7 : {map[4][23], map[5][23], map[6][23], map[7][23]} <= writedata;
        9'he8 : {map[8][23], map[9][23], map[10][23], map[11][23]} <= writedata;
        9'he9 : {map[12][23], map[13][23], map[14][23], map[15][23]} <= writedata;
        9'hea : {map[16][23], map[17][23], map[18][23], map[19][23]} <= writedata;
        9'heb : {map[20][23], map[21][23], map[22][23], map[23][23]} <= writedata;
        9'hec : {map[24][23], map[25][23], map[26][23], map[27][23]} <= writedata;
        9'hed : {map[28][23], map[29][23], map[30][23], map[31][23]} <= writedata;
        9'hee : {map[32][23], map[33][23], map[34][23], map[35][23]} <= writedata;
        9'hef : {map[36][23], map[37][23], map[38][23], map[39][23]} <= writedata;

        9'hf0 : {map[0][24], map[1][24], map[2][24], map[3][24]} <= writedata;
        9'hf1 : {map[4][24], map[5][24], map[6][24], map[7][24]} <= writedata;
        9'hf2 : {map[8][24], map[9][24], map[10][24], map[11][24]} <= writedata;
        9'hf3 : {map[12][24], map[13][24], map[14][24], map[15][24]} <= writedata;
        9'hf4 : {map[16][24], map[17][24], map[18][24], map[19][24]} <= writedata;
        9'hf5 : {map[20][24], map[21][24], map[22][24], map[23][24]} <= writedata;
        9'hf6 : {map[24][24], map[25][24], map[26][24], map[27][24]} <= writedata;
        9'hf7 : {map[28][24], map[29][24], map[30][24], map[31][24]} <= writedata;
        9'hf8 : {map[32][24], map[33][24], map[34][24], map[35][24]} <= writedata;
        9'hf9 : {map[36][24], map[37][24], map[38][24], map[39][24]} <= writedata;

        9'hfa : {map[0][25], map[1][25], map[2][25], map[3][25]} <= writedata;
        9'hfb : {map[4][25], map[5][25], map[6][25], map[7][25]} <= writedata;
        9'hfc : {map[8][25], map[25][9], map[10][25], map[11][25]} <= writedata;
        9'hfd : {map[12][25], map[13][25], map[14][25], map[15][25]} <= writedata;
        9'hfe : {map[16][25], map[17][25], map[18][25], map[19][25]} <= writedata;
        9'hff : {map[20][25], map[21][25], map[22][25], map[23][25]} <= writedata;
        9'h100 : {map[24][25], map[25][25], map[26][25], map[27][25]} <= writedata;
        9'h101 : {map[28][25], map[29][25], map[30][25], map[31][25]} <= writedata;
        9'h102 : {map[32][25], map[33][25], map[34][25], map[35][25]} <= writedata;
        9'h103 : {map[36][25], map[37][25], map[38][25], map[39][25]} <= writedata;

        9'h104 : {map[0][26], map[1][26], map[2][26], map[3][26]} <= writedata;
        9'h105 : {map[4][26], map[5][26], map[6][26], map[7][26]} <= writedata;
        9'h106 : {map[8][26], map[9][26], map[10][26], map[11][26]} <= writedata;
        9'h107 : {map[12][26], map[13][26], map[14][26], map[15][26]} <= writedata;
        9'h108 : {map[16][26], map[17][26], map[18][26], map[19][26]} <= writedata;
        9'h109 : {map[20][26], map[21][26], map[22][26], map[23][26]} <= writedata;
        9'h10a : {map[24][26], map[25][26], map[26][26], map[27][26]} <= writedata;
        9'h10b : {map[28][26], map[29][26], map[30][26], map[31][26]} <= writedata;
        9'h10c : {map[32][26], map[33][26], map[34][26], map[35][26]} <= writedata;
        9'h10d : {map[36][26], map[37][26], map[38][26], map[39][26]} <= writedata;

        9'h10e : {map[0][27], map[1][27], map[2][27], map[3][27]} <= writedata;
        9'h10f : {map[4][27], map[5][27], map[6][27], map[7][27]} <= writedata;
        9'h110 : {map[8][27], map[9][27], map[10][27], map[11][27]} <= writedata;
        9'h111 : {map[12][27], map[13][27], map[14][27], map[15][27]} <= writedata;
        9'h112 : {map[16][27], map[17][27], map[18][27], map[19][27]} <= writedata;
        9'h113 : {map[20][27], map[21][27], map[22][27], map[23][27]} <= writedata;
        9'h114 : {map[24][27], map[25][27], map[26][27], map[27][27]} <= writedata;
        9'h115 : {map[28][27], map[29][27], map[30][27], map[31][27]} <= writedata;
        9'h116 : {map[32][27], map[33][27], map[34][27], map[35][27]} <= writedata;
        9'h117 : {map[36][27], map[37][27], map[38][27], map[39][27]} <= writedata;

        9'h118 : {map[0][28], map[1][28], map[2][28], map[3][28]} <= writedata;
        9'h119 : {map[4][28], map[5][28], map[6][28], map[7][28]} <= writedata;
        9'h11a : {map[8][28], map[9][28], map[10][28], map[11][28]} <= writedata;
        9'h11b : {map[12][28], map[13][28], map[14][28], map[15][28]} <= writedata;
        9'h11c : {map[16][28], map[17][28], map[18][28], map[19][28]} <= writedata;
        9'h11d : {map[20][28], map[21][28], map[22][28], map[23][28]} <= writedata;
        9'h11e : {map[24][28], map[25][28], map[26][28], map[27][28]} <= writedata;
        9'h11f : {map[28][28], map[29][28], map[30][28], map[31][28]} <= writedata;
        9'h120 : {map[32][28], map[33][28], map[34][28], map[35][28]} <= writedata;
        9'h121 : {map[36][28], map[37][28], map[38][28], map[39][28]} <= writedata;

        9'h122 : {map[0][29], map[1][29], map[2][29], map[3][29]} <= writedata;
        9'h123 : {map[4][29], map[5][29], map[6][29], map[7][29]} <= writedata;
        9'h124 : {map[8][29], map[9][29], map[10][29], map[11][29]} <= writedata;
        9'h125 : {map[12][29], map[13][29], map[14][29], map[15][29]} <= writedata;
        9'h126 : {map[16][29], map[17][29], map[18][29], map[19][29]} <= writedata;
        9'h127 : {map[20][29], map[21][29], map[22][29], map[23][29]} <= writedata;
        9'h128 : {map[24][29], map[25][29], map[26][29], map[27][29]} <= writedata;
        9'h129 : {map[28][29], map[29][29], map[30][29], map[31][29]} <= writedata;
        9'h12a : {map[32][29], map[33][29], map[34][29], map[35][29]} <= writedata;
        9'h12b : {map[36][29], map[37][29], map[38][29], map[39][29]} <= writedata;


        

      endcase
      /*
      if (x_offset == 9'b100111) begin
        x_offset <= 0;
        y_offset <= y_offset + 1;
      end else if (y_offset == 29) begin
        x_offset <= 0;
        y_offset <= 0;
      end else begin
        x_offset <= x_offset + 4;
      end
      */
      // map[x_pos][y_pos] <= sprite_type;
   end
   //map[x_pos][y_pos] <= sprite_type;
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
    if (VGA_BLANK_n) begin
      // Dynamic Sprites
      /*
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
      */
      // apple - 1
      if (map[hcount[10:5]][vcount[9:4]] == 8'b1) begin 
        apple_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {apple_sprite_output[15:11], 3'b0};
        b <= {apple_sprite_output[10:5], 2'b0};
        c <= {apple_sprite_output[4:0], 3'b0};
      end 
      // head up - 2
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10) begin 
        snake_head_up_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_head_up_sprite_output[15:11], 3'b0};
        b <= {snake_head_up_sprite_output[10:5], 2'b0};
        c <= {snake_head_up_sprite_output[4:0], 3'b0};
      end 
      // head down - 3
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b11) begin 
        snake_head_down_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_head_down_sprite_output[15:11], 3'b0};
        b <= {snake_head_down_sprite_output[10:5], 2'b0};
        c <= {snake_head_down_sprite_output[4:0], 3'b0};
      end
      // head left - 4
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b100) begin 
        snake_head_left_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_head_left_sprite_output[15:11], 3'b0};
        b <= {snake_head_left_sprite_output[10:5], 2'b0};
        c <= {snake_head_left_sprite_output[4:0], 3'b0};
      end
      // head right - 5
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b101) begin 
        snake_head_right_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_head_right_sprite_output[15:11], 3'b0};
        b <= {snake_head_right_sprite_output[10:5], 2'b0};
        c <= {snake_head_right_sprite_output[4:0], 3'b0};
      end
      // body vertical - 6
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b110) begin 
        snake_body_vertical_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_vertical_sprite_output[15:11], 3'b0};
        b <= {snake_body_vertical_sprite_output[10:5], 2'b0};
        c <= {snake_body_vertical_sprite_output[4:0], 3'b0};
      end
      // body horizontal - 7
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b111) begin 
        snake_body_horizontal_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_horizontal_sprite_output[15:11], 3'b0};
        b <= {snake_body_horizontal_sprite_output[10:5], 2'b0};
        c <= {snake_body_horizontal_sprite_output[4:0], 3'b0};
      end
      // body top left - 8
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1000) begin 
        snake_body_topleft_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_topleft_sprite_output[15:11], 3'b0};
        b <= {snake_body_topleft_sprite_output[10:5], 2'b0};
        c <= {snake_body_topleft_sprite_output[4:0], 3'b0};
      end
      // body bottom left - 9
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1001) begin 
        snake_body_bottomleft_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_bottomleft_sprite_output[15:11], 3'b0};
        b <= {snake_body_bottomleft_sprite_output[10:5], 2'b0};
        c <= {snake_body_bottomleft_sprite_output[4:0], 3'b0};
      end
      // body top right - 10
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1010) begin 
        snake_body_topright_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_topright_sprite_output[15:11], 3'b0};
        b <= {snake_body_topright_sprite_output[10:5], 2'b0};
        c <= {snake_body_topright_sprite_output[4:0], 3'b0};
      end
      // body bottom right - 11
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1011) begin 
        snake_body_bottomright_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_body_bottomright_sprite_output[15:11], 3'b0};
        b <= {snake_body_bottomright_sprite_output[10:5], 2'b0};
        c <= {snake_body_bottomright_sprite_output[4:0], 3'b0};
      end
      // tail up - 12
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1100) begin 
        snake_tail_up_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_tail_up_sprite_output[15:11], 3'b0};
        b <= {snake_tail_up_sprite_output[10:5], 2'b0};
        c <= {snake_tail_up_sprite_output[4:0], 3'b0};
      end
      // tail down - 13
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1101) begin 
        snake_tail_down_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_tail_down_sprite_output[15:11], 3'b0};
        b <= {snake_tail_down_sprite_output[10:5], 2'b0};
        c <= {snake_tail_down_sprite_output[4:0], 3'b0};
      end
      // tail left - 14
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1110) begin 
        snake_tail_left_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_tail_left_sprite_output[15:11], 3'b0};
        b <= {snake_tail_left_sprite_output[10:5], 2'b0};
        c <= {snake_tail_left_sprite_output[4:0], 3'b0};
      end
      // tail right - 15
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b1111) begin 
        snake_tail_right_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {snake_tail_right_sprite_output[15:11], 3'b0};
        b <= {snake_tail_right_sprite_output[10:5], 2'b0};
        c <= {snake_tail_right_sprite_output[4:0], 3'b0};
      end
      
      // zero - 16
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10000) begin 
        zero_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {zero_sprite_output[15:11], 3'b0};
        b <= {zero_sprite_output[10:5], 2'b0};
        c <= {zero_sprite_output[4:0], 3'b0};
      end
      
      // one - 17
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10001) begin 
        one_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {one_sprite_output[15:11], 3'b0};
        b <= {one_sprite_output[10:5], 2'b0};
        c <= {one_sprite_output[4:0], 3'b0};
      end
      
      // two - 18
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10010) begin 
        two_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {two_sprite_output[15:11], 3'b0};
        b <= {two_sprite_output[10:5], 2'b0};
        c <= {two_sprite_output[4:0], 3'b0};
      end
      // three - 19
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10011) begin 
        three_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {three_sprite_output[15:11], 3'b0};
        b <= {three_sprite_output[10:5], 2'b0};
        c <= {three_sprite_output[4:0], 3'b0};
      end
      //four - 20
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10100) begin 
        four_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {four_sprite_output[15:11], 3'b0};
        b <= {four_sprite_output[10:5], 2'b0};
        c <= {four_sprite_output[4:0], 3'b0};
      end
      // five - 21
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10101) begin 
        five_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {five_sprite_output[15:11], 3'b0};
        b <= {five_sprite_output[10:5], 2'b0};
        c <= {five_sprite_output[4:0], 3'b0};
      end
      // six - 22
      
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10110) begin 
        six_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {six_sprite_output[15:11], 3'b0};
        b <= {six_sprite_output[10:5], 2'b0};
        c <= {six_sprite_output[4:0], 3'b0};
      end
      
      // seven - 23
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b10111) begin 
        seven_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {seven_sprite_output[15:11], 3'b0};
        b <= {seven_sprite_output[10:5], 2'b0};
        c <= {seven_sprite_output[4:0], 3'b0};
      end
      // eight - 24
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b11000) begin 
        eight_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {eight_sprite_output[15:11], 3'b0};
        b <= {eight_sprite_output[10:5], 2'b0};
        c <= {eight_sprite_output[4:0], 3'b0};
      end
      // nine - 25
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b11001) begin 
        nine_sprite_addr <= hcount[4:1] + (vcount[3:0])*16;
        a <= {nine_sprite_output[15:11], 3'b0};
        b <= {nine_sprite_output[10:5], 2'b0};
        c <= {nine_sprite_output[4:0], 3'b0};
      end
      else if (map[hcount[10:5]][vcount[9:4]] == 8'b0 && hcount[10:6] > 8'b1 && hcount[10:6] < 8'b100110 && vcount[9:4] > 8'b011 && vcount[9:4]< 8'b11100) begin 
        a <= 8'h0;
        b <= 8'h0;
        c <= 8'h0;
      end
      

      
      // static sprites
      //left wall column
      else if(hcount[10:6] == 5'b00000 && vcount[9:5] > 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= {wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end 
      //right
      else if(hcount[10:6] == 5'b10011 && vcount[9:5] > 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= {wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end
      //top
      else if( vcount[9:5] == 5'b00001) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= {wall_sprite_output[10:5], 2'b0};
        c <= {wall_sprite_output[4:0], 3'b0};
      end 
      //bottom
      else if( vcount[9:5] == 5'b01110) begin
        wall_sprite_addr <= hcount[5:1] + (vcount[4:0])*32;
        a <= {wall_sprite_output[15:11], 3'b0};
        b <= {wall_sprite_output[10:5], 2'b0};
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
>>>>>>> 4ec3bdeb81017703f152429efd8bab1e5eea5cf9
