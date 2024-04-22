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
   logic [15:0]     apple_sprite_output;
   logic [15:0]     output_1;
   logic [9:0]      apple_sprite_addr;
   logic [1:0]      apple_sprite_en;
   //logic [15:0]     apple_sprite;
	
   vga_counters counters(.clk50(clk), .*);

   soc_system_apple_sprite apple_sprite(.address(apple_sprite_addr), .clk(clk), .clken(1), .reset_req(0), .readdata(apple_sprite_output));


   always_ff @(posedge clk)
     if (reset) begin
      background_r <= 8'h0;
      background_g <= 8'h80;
      background_b <= 8'h80;
     end else if (chipselect && write)
       case (address)
    
   
       3'h0 : background_r <= writedata;
       3'h1 : background_g <= writedata;
       3'h2 : background_b <= writedata;

    /*
       3'h3 : x [7:0] <= writedata;
       3'h4 : x[15:8] <= writedata;
       3'h5 : y[7:0] <= writedata;
       3'h6 : y[15:8] <= writedata;
    */
       endcase

  //logic for generating vga output
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;

  reg [4:0] d = 5'b1010;
  reg [4:0] e = 5'b1010;
  
// -------------------------------------
always_ff @(posedge clk) begin

    if (VGA_BLANK_n) begin
        if (hcount[10:6] == d && vcount[9:5] == e) begin
            output_1 <= apple_sprite[hcount[5:1] + (vcount[4:0])*32];
            a <= {output_1[15:11], 3'b0};
            b <= { output_1[10:5], 2'b0};
            c <= {output_1[4:0], 3'b0};


             
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

//----------------------------------------------------------

/*
  always_comb begin
      {VGA_R, VGA_G, VGA_B} = {background_r, background_g, background_b};
      if (VGA_BLANK_n ) begin
	if (apple_sprite_en) begin
          case (apple_sprite_output)
            8'h00 : {VGA_R, VGA_G, VGA_B} = {8'hf0, 8'hf0, 8'hf0};
            8'h01 : {VGA_R, VGA_G, VGA_B} = {8'hb0, 8'ha0, 8'ha0};
            8'h02 : {VGA_R, VGA_G, VGA_B} = {8'ha0, 8'ha0, 8'hb0};
            8'h03 : {VGA_R, VGA_G, VGA_B} = {8'ha0, 8'ha0, 8'ha0};
            8'h04 : {VGA_R, VGA_G, VGA_B} = {8'hb0, 8'h30, 8'h20};
            8'h05 : {VGA_R, VGA_G, VGA_B} = {8'hb0, 8'h20, 8'h20};
            8'h06 : {VGA_R, VGA_G, VGA_B} = {8'he0, 8'he0, 8'h90};
            8'h07 : {VGA_R, VGA_G, VGA_B} = {8'he0, 8'h90, 8'h20};
            8'h08 : {VGA_R, VGA_G, VGA_B} = {8'he0, 8'h90, 8'h10};
            8'h09 : {VGA_R, VGA_G, VGA_B} = {8'h90, 8'h40, 8'h00};
            8'h0a : {VGA_R, VGA_G, VGA_B} = {8'h60, 8'h60, 8'h60};
            8'h0b : {VGA_R, VGA_G, VGA_B} = {8'h60, 8'h60, 8'h00};
            8'h0c : {VGA_R, VGA_G, VGA_B} = {8'h60, 8'h00, 8'h00};
            8'h0d : {VGA_R, VGA_G, VGA_B} = {8'h50, 8'h00, 8'h70};
            8'h0e : {VGA_R, VGA_G, VGA_B} = {8'h00, 8'h40, 8'h40};
            8'h0f : {VGA_R, VGA_G, VGA_B} = {8'h00, 8'h00, 8'h00};
          endcase
        end
      end
  end
  
  */
      /* 
     	  always_comb
	    begin
	      {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h0}; // Initialize to black
	      if (VGA_BLANK_n) begin
		if ((hcount[10:1]-(x+20))**2 + (vcount-(y+20))**2 <= 20**2) begin
		  {VGA_R, VGA_G, VGA_B} = {8'hff, 8'h00, 8'h00}; // Red color for circle
		end
		else begin
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
