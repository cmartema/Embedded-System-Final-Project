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
        8'h0 : {map[0][0], map[1][0], map[2][0], map[3][0]} <= writedata;
        8'h1 : {map[4][0], map[5][0], map[6][0], map[7][0]} <= writedata;
        8'h2 : {map[8][0], map[9][0], map[10][0], map[11][0]} <= writedata;
        8'h3 : {map[12][0], map[13][0], map[14][0], map[15][0]} <= writedata;
        8'h4 : {map[16][0], map[17][0], map[18][0], map[19][0]} <= writedata;
        8'h5 : {map[20][0], map[21][0], map[22][0], map[23][0]} <= writedata;
        8'h6 : {map[24][0], map[25][0], map[26][0], map[27][0]} <= writedata;
        8'h7 : {map[28][0], map[29][0], map[30][0], map[31][0]} <= writedata;
        8'h8 : {map[32][0], map[33][0], map[34][0], map[35][0]} <= writedata;
        8'h9 : {map[36][0], map[37][0], map[38][0], map[39][0]} <= writedata;

        8'ha : {map[0][1], map[1][1], map[2][1], map[3][1]} <= writedata;
        8'hb : {map[4][1], map[5][1], map[6][1], map[7][1]} <= writedata;
        8'hc : {map[8][1], map[9][1], map[10][1], map[11][1]} <= writedata;
        8'hd : {map[12][1], map[13][1], map[14][1], map[15][1]} <= writedata;
        8'he : {map[16][1], map[17][1], map[18][1], map[19][1]} <= writedata;
        8'hf : {map[20][1], map[21][1], map[22][1], map[23][1]} <= writedata;
        8'h10 : {map[24][1], map[25][1], map[26][1], map[27][1]} <= writedata;
        8'h11 : {map[28][1], map[29][1], map[30][1], map[31][1]} <= writedata;
        8'h12 : {map[32][1], map[33][1], map[34][1], map[35][1]} <= writedata;
        8'h13 : {map[36][1], map[37][1], map[38][1], map[39][1]} <= writedata;

        8'h14 : {map[0][2], map[1][2], map[2][2], map[3][2]} <= writedata;
        8'h15 : {map[4][2], map[5][2], map[6][2], map[7][2]} <= writedata;
        8'h16 : {map[8][2], map[9][2], map[10][2], map[11][2]} <= writedata;
        8'h17 : {map[12][2], map[13][2], map[14][2], map[15][2]} <= writedata;
        8'h18 : {map[16][2], map[17][2], map[18][2], map[19][2]} <= writedata;
        8'h19 : {map[20][2], map[21][2], map[22][2], map[23][2]} <= writedata;
        8'h1a : {map[24][2], map[25][2], map[26][2], map[27][2]} <= writedata;
        8'h1b : {map[28][2], map[29][2], map[30][2], map[31][2]} <= writedata;
        8'h1c : {map[32][2], map[33][2], map[34][2], map[35][2]} <= writedata;
        8'h1d : {map[36][2], map[37][2], map[38][2], map[39][2]} <= writedata;

        8'h1e : {map[0][3], map[1][3], map[2][3], map[3][3]} <= writedata;
        8'h1f : {map[4][3], map[5][3], map[6][3], map[7][3]} <= writedata;
        8'h20 : {map[8][3], map[9][3], map[10][3], map[11][3]} <= writedata;
        8'h21 : {map[12][3], map[13][3], map[14][3], map[15][3]} <= writedata;
        8'h22 : {map[16][3], map[17][3], map[18][3], map[19][3]} <= writedata;
        8'h23 : {map[20][3], map[21][3], map[22][3], map[23][3]} <= writedata;
        8'h24 : {map[24][3], map[25][3], map[26][3], map[27][3]} <= writedata;
        8'h25 : {map[28][3], map[29][3], map[30][3], map[31][3]} <= writedata;
        8'h26 : {map[32][3], map[33][3], map[34][3], map[35][3]} <= writedata;
        8'h27 : {map[36][3], map[37][3], map[38][3], map[39][3]} <= writedata;

        8'h28 : {map[0][4], map[1][4], map[2][4], map[3][4]} <= writedata;
        8'h29 : {map[4][4], map[5][4], map[6][4], map[7][4]} <= writedata;
        8'h2a : {map[8][4], map[9][4], map[10][4], map[11][4]} <= writedata;
        8'h2b : {map[12][4], map[13][4], map[14][4], map[15][4]} <= writedata;
        8'h2c : {map[16][4], map[17][4], map[18][4], map[19][4]} <= writedata;
        8'h2d : {map[20][4], map[21][4], map[22][4], map[23][4]} <= writedata;
        8'h2e : {map[24][4], map[25][4], map[26][4], map[27][4]} <= writedata;
        8'h2f : {map[28][4], map[29][4], map[30][4], map[31][4]} <= writedata;
        8'h30 : {map[32][4], map[33][4], map[34][4], map[35][4]} <= writedata;
        8'h31 : {map[36][4], map[37][4], map[38][4], map[39][4]} <= writedata;

        8'h32 : {map[0][5], map[1][5], map[2][5], map[3][5]} <= writedata;
        8'h33 : {map[4][5], map[5][5], map[6][5], map[7][5]} <= writedata;
        8'h34 : {map[8][5], map[9][5], map[10][5], map[11][5]} <= writedata;
        8'h35 : {map[12][5], map[13][5], map[14][5], map[15][5]} <= writedata;
        8'h36 : {map[16][5], map[17][5], map[18][5], map[19][5]} <= writedata;
        8'h37 : {map[20][5], map[21][5], map[22][5], map[23][5]} <= writedata;
        8'h38 : {map[24][5], map[25][5], map[26][5], map[27][5]} <= writedata;
        8'h39 : {map[28][5], map[29][5], map[30][5], map[31][5]} <= writedata;
        8'h3a : {map[32][5], map[33][5], map[34][5], map[35][5]} <= writedata;
        8'h3b : {map[36][5], map[37][5], map[38][5], map[39][5]} <= writedata;

        8'h3c : {map[0][6], map[1][6], map[2][6], map[3][6]} <= writedata;
        8'h3d : {map[4][6], map[5][6], map[6][6], map[7][6]} <= writedata;
        8'h3e : {map[8][6], map[9][6], map[10][6], map[11][6]} <= writedata;
        8'h3f : {map[12][6], map[13][6], map[14][6], map[15][6]} <= writedata;
        8'h40 : {map[16][6], map[17][6], map[18][6], map[19][6]} <= writedata;
        8'h41 : {map[20][6], map[21][6], map[22][6], map[23][6]} <= writedata;
        8'h42 : {map[24][6], map[25][6], map[26][6], map[27][6]} <= writedata;
        8'h43 : {map[28][6], map[29][6], map[30][6], map[31][6]} <= writedata;
        8'h44 : {map[32][6], map[33][6], map[34][6], map[35][6]} <= writedata;
        8'h45 : {map[36][6], map[37][6], map[38][6], map[39][6]} <= writedata;


        8'h46 : {map[0][7], map[1][7], map[2][7], map[3][7]} <= writedata;
        8'h47 : {map[4][7], map[5][7], map[6][7], map[7][7]} <= writedata;
        8'h48 : {map[8][7], map[9][7], map[10][7], map[11][7]} <= writedata;
        8'h49 : {map[12][7], map[13][7], map[14][7], map[15][7]} <= writedata;
        8'h4a : {map[16][7], map[17][7], map[18][7], map[19][7]} <= writedata;
        8'h4b : {map[20][7], map[21][7], map[22][7], map[23][7]} <= writedata;
        8'h4c : {map[24][7], map[25][7], map[26][7], map[27][7]} <= writedata;
        8'h4d : {map[28][7], map[29][7], map[30][7], map[31][7]} <= writedata;
        8'h4e : {map[32][7], map[33][7], map[34][7], map[35][7]} <= writedata;
        8'h4f : {map[36][7], map[37][7], map[38][7], map[39][7]} <= writedata;

        8'h50 : {map[0][8], map[1][8], map[2][8], map[3][8]} <= writedata;
        8'h51 : {map[4][8], map[5][8], map[6][8], map[7][8]} <= writedata;
        8'h52 : {map[8][8], map[9][8], map[10][8], map[11][8]} <= writedata;
        8'h53 : {map[12][8], map[13][8], map[14][8], map[15][8]} <= writedata;
        8'h54 : {map[16][8], map[17][8], map[18][8], map[19][8]} <= writedata;
        8'h55 : {map[20][8], map[21][8], map[22][8], map[23][8]} <= writedata;
        8'h56 : {map[24][8], map[25][8], map[26][8], map[27][8]} <= writedata;
        8'h57 : {map[28][8], map[29][8], map[30][8], map[31][8]} <= writedata;
        8'h58 : {map[32][8], map[33][8], map[34][8], map[35][8]} <= writedata;
        8'h59 : {map[36][8], map[37][8], map[38][8], map[39][8]} <= writedata;

        8'h5a : {map[0][9], map[1][9], map[2][9], map[3][9]} <= writedata;
        8'h5b : {map[4][9], map[5][9], map[6][9], map[7][9]} <= writedata;
        8'h5c : {map[8][9], map[9][9], map[10][9], map[11][9]} <= writedata;
        8'h5d : {map[12][9], map[13][9], map[14][9], map[15][9]} <= writedata;
        8'h5e : {map[16][9], map[17][9], map[18][9], map[19][9]} <= writedata;
        8'h5f : {map[20][9], map[21][9], map[22][9], map[23][9]} <= writedata;
        8'h60 : {map[24][9], map[25][9], map[26][9], map[27][9]} <= writedata;
        8'h61 : {map[28][9], map[29][9], map[30][9], map[31][9]} <= writedata;
        8'h62 : {map[32][9], map[33][9], map[34][9], map[35][9]} <= writedata;
        8'h63 : {map[36][9], map[37][9], map[38][9], map[39][9]} <= writedata;

        8'h64 : {map[0][10], map[1][10], map[2][10], map[3][10]} <= writedata;
        8'h65 : {map[4][10], map[5][10], map[6][10], map[7][10]} <= writedata;
        8'h66 : {map[8][10], map[9][10], map[10][10], map[11][10]} <= writedata;
        8'h67 : {map[12][10], map[13][10], map[14][10], map[15][10]} <= writedata;
        8'h68 : {map[16][10], map[17][10], map[18][10], map[19][10]} <= writedata;
        8'h69 : {map[20][10], map[21][10], map[22][10], map[23][10]} <= writedata;
        8'h6a : {map[24][10], map[25][10], map[26][10], map[27][10]} <= writedata;
        8'h6b : {map[28][10], map[29][10], map[30][10], map[31][10]} <= writedata;
        8'h6c : {map[32][10], map[33][10], map[34][10], map[35][10]} <= writedata;
        8'h6d : {map[36][10], map[37][10], map[38][10], map[39][10]} <= writedata;

        8'h6e : {map[0][11], map[1][11], map[2][11], map[3][11]} <= writedata;
        8'h6f : {map[4][11], map[5][11], map[6][11], map[7][11]} <= writedata;
        8'h70 : {map[8][11], map[9][11], map[10][11], map[11][11]} <= writedata;
        8'h71 : {map[12][11], map[13][11], map[14][11], map[15][11]} <= writedata;
        8'h72 : {map[16][11], map[17][11], map[18][11], map[19][11]} <= writedata;
        8'h73 : {map[20][11], map[21][11], map[22][11], map[23][11]} <= writedata;
        8'h74 : {map[24][11], map[25][11], map[26][11], map[27][11]} <= writedata;
        8'h75 : {map[28][11], map[29][11], map[30][11], map[31][11]} <= writedata;
        8'h76 : {map[32][11], map[33][11], map[34][11], map[35][11]} <= writedata;
        8'h77 : {map[36][11], map[37][11], map[38][11], map[39][11]} <= writedata;

        8'h78 : {map[0][12], map[1][12], map[2][12], map[3][12]} <= writedata;
        8'h79 : {map[4][12], map[5][12], map[6][12], map[7][12]} <= writedata;
        8'h7a : {map[8][12], map[9][12], map[10][12], map[11][12]} <= writedata;
        8'h7b : {map[12][12], map[13][12], map[14][12], map[15][12]} <= writedata;
        8'h7c : {map[16][12], map[17][12], map[18][12], map[19][12]} <= writedata;
        8'h7d : {map[20][12], map[21][12], map[22][12], map[23][12]} <= writedata;
        8'h7e : {map[24][12], map[25][12], map[26][12], map[27][12]} <= writedata;
        8'h7f : {map[28][12], map[29][12], map[30][12], map[31][12]} <= writedata;
        8'h80 : {map[32][12], map[33][12], map[34][12], map[35][12]} <= writedata;
        8'h81 : {map[36][12], map[37][12], map[38][12], map[39][12]} <= writedata;

        8'h82 : {map[0][13], map[1][13], map[2][13], map[3][13]} <= writedata;
        8'h83 : {map[4][13], map[5][13], map[6][13], map[7][13]} <= writedata;
        8'h84 : {map[8][13], map[9][13], map[10][13], map[11][13]} <= writedata;
        8'h85 : {map[12][13], map[13][13], map[14][13], map[15][13]} <= writedata;
        8'h86 : {map[16][13], map[17][13], map[18][13], map[19][13]} <= writedata;
        8'h87 : {map[20][13], map[21][13], map[22][13], map[23][13]} <= writedata;
        8'h88 : {map[24][13], map[25][13], map[26][13], map[27][13]} <= writedata;
        8'h89 : {map[28][13], map[29][13], map[30][13], map[31][13]} <= writedata;
        8'h8a : {map[32][13], map[33][13], map[34][13], map[35][13]} <= writedata;
        8'h8b : {map[36][13], map[37][13], map[38][13], map[39][13]} <= writedata;

        8'h8c : {map[0][14], map[1][14], map[2][14], map[3][14]} <= writedata;
        8'h8d : {map[4][14], map[5][14], map[6][14], map[7][14]} <= writedata;
        8'h8e : {map[8][14], map[9][14], map[10][14], map[11][14]} <= writedata;
        8'h8f : {map[12][14], map[13][14], map[14][14], map[15][14]} <= writedata;
        8'h90 : {map[16][14], map[17][14], map[18][14], map[19][14]} <= writedata;
        8'h91 : {map[20][14], map[21][14], map[22][14], map[23][14]} <= writedata;
        8'h92 : {map[24][14], map[25][14], map[26][14], map[27][14]} <= writedata;
        8'h93 : {map[28][14], map[29][14], map[30][14], map[31][14]} <= writedata;
        8'h94 : {map[32][14], map[33][14], map[34][14], map[35][14]} <= writedata;
        8'h95 : {map[36][14], map[37][14], map[38][14], map[39][14]} <= writedata;
/*
        8'h46 : {map[0][7], map[1][7], map[2][7], map[3][7]} <= writedata;
        8'h47 : {map[4][7], map[5][7], map[6][7], map[7][7]} <= writedata;
        8'h48 : {map[8][7], map[9][7], map[10][7], map[11][7]} <= writedata;
        8'h49 : {map[12][7], map[13][7], map[14][7], map[15][7]} <= writedata;
        8'h4a : {map[16][7], map[17][7], map[18][7], map[19][7]} <= writedata;
        8'h4b : {map[20][7], map[21][7], map[22][7], map[23][7]} <= writedata;
        8'h4c : {map[24][7], map[25][7], map[26][7], map[27][7]} <= writedata;
        8'h4d : {map[28][7], map[29][7], map[30][7], map[31][7]} <= writedata;
        8'h4e : {map[32][7], map[33][7], map[34][7], map[35][7]} <= writedata;
        8'h4f : {map[36][7], map[37][7], map[38][7], map[39][7]} <= writedata;

        8'h50 : {map[0][8], map[1][8], map[2][8], map[3][8]} <= writedata;
        8'h51 : {map[4][8], map[5][8], map[6][8], map[7][8]} <= writedata;
        8'h52 : {map[8][8], map[9][8], map[10][8], map[11][8]} <= writedata;
        8'h53 : {map[12][8], map[13][8], map[14][8], map[15][8]} <= writedata;
        8'h54 : {map[16][8], map[17][8], map[18][8], map[19][8]} <= writedata;
        8'h55 : {map[20][8], map[21][8], map[22][8], map[23][8]} <= writedata;
        8'h56 : {map[24][8], map[25][8], map[26][8], map[27][8]} <= writedata;
        8'h57 : {map[28][8], map[29][8], map[30][8], map[31][8]} <= writedata;
        8'h58 : {map[32][8], map[33][8], map[34][8], map[35][8]} <= writedata;
        8'h59 : {map[36][8], map[37][8], map[38][8], map[39][8]} <= writedata;
*/
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