/*
 * Avalon memory-mapped peripheral that generates VGA
 *
 * Stephen A. Edwards
 * Columbia University
 */

module vga_ball(input logic        clk,
	        input logic 	   reset,
		input logic [15:0]  writedata,
		input logic 	   write,
		input 		   chipselect,
		input logic [2:0]  address,

		output logic [7:0] VGA_R, VGA_G, VGA_B,
		output logic 	   VGA_CLK, VGA_HS, VGA_VS,
		                   VGA_BLANK_n,
		output logic 	   VGA_SYNC_n);

   logic [10:0]	   hcount;
   logic [9:0]     vcount;
   
   logic [20:0]   dis;
   logic [15:0] 	   background_r, background_g, background_b;
   logic [15:0] 	   pos_x[0:200];
   logic [15:0] 	   pos_y[0:200];
   logic [15:0] 	   apple_x;
   logic [15:0] 	   apple_y;
   logic [15:0]      head_x,head_y;
   logic [15:0]      snake_length=2;
   logic [9:0]       sim_time = 0;
   logic             extend=0;
   logic [0:15]    number_zero[0:15], number_one[0:15], number_two[0:15],number_three[0:15],number_four[0:15];
   logic [0:15]    number_five[0:15], number_six[0:15], number_seven[0:15],number_eight[0:15],number_nine[0:15];
   logic [3:0]     score_a,score_b,score_c;  
   
   
   
	
   vga_counters counters(.clk50(clk), .*);

   always_ff @(posedge clk)
     if (reset) begin
	background_r <= 8'h0;
	background_g <= 8'h0;
	background_b <= 8'h80;
        number_zero[0][0:15] <=		16'b0000000000000000;
        number_zero[1][0:15] <=		16'b0000000000000000;
        number_zero[2][0:15] <=		16'b0000000000000000;
        number_zero[3][0:15] <=		16'b0000011111100000;
        number_zero[4][0:15] <=		16'b0000111111110000;
        number_zero[5][0:15] <=		16'b0000110000110000;
        number_zero[6][0:15] <=		16'b0000110000110000;
        number_zero[7][0:15] <=		16'b0000110000110000;
        number_zero[8][0:15] <=		16'b0000110000110000;
        number_zero[9][0:15] <=		16'b0000110000110000;
        number_zero[10][0:15] <=	16'b0000110000110000;
        number_zero[11][0:15] <=	16'b0000111111110000;
        number_zero[12][0:15] <=	16'b0000011111100000;
        number_zero[13][0:15] <=	16'b0000000000000000;
        number_zero[14][0:15] <=	16'b0000000000000000;
        number_zero[15][0:15] <=	16'b0000000000000000;
        //number1
        number_one[0][0:15] <=		16'b0000000000000000;
        number_one[1][0:15] <=		16'b0000000000000000;
        number_one[2][0:15] <=		16'b0000000000000000;
        number_one[3][0:15] <=		16'b0000000110000000;
        number_one[4][0:15] <=		16'b0000001110000000;
        number_one[5][0:15] <=		16'b0000011110000000;
        number_one[6][0:15] <=		16'b0000000110000000;
        number_one[7][0:15] <=		16'b0000000110000000;
        number_one[8][0:15] <=		16'b0000000110000000;
        number_one[9][0:15] <=		16'b0000000110000000;
        number_one[10][0:15] <=		16'b0000000110000000;
        number_one[11][0:15] <=		16'b0000011111100000;
        number_one[12][0:15] <=		16'b0000011111100000;
        number_one[13][0:15] <=		16'b0000000000000000;
        number_one[14][0:15] <=		16'b0000000000000000;
        number_one[15][0:15] <=		16'b0000000000000000;
        //number2
        number_two[0][0:15] <=		16'b0000000000000000;
        number_two[1][0:15] <=		16'b0000000000000000;
        number_two[2][0:15] <=		16'b0000000000000000;
        number_two[3][0:15] <=		16'b0000011111100000;
        number_two[4][0:15] <=		16'b0000111111110000;
        number_two[5][0:15] <=		16'b0000110000110000;
        number_two[6][0:15] <=		16'b0000000001110000;
        number_two[7][0:15] <=		16'b0000000011100000;
        number_two[8][0:15] <=		16'b0000000111000000;
        number_two[9][0:15] <=		16'b0000001110000000;
        number_two[10][0:15] <=		16'b0000011100000000;
        number_two[11][0:15] <=		16'b0000111111110000;
        number_two[12][0:15] <=		16'b0000111111110000;
        number_two[13][0:15] <=		16'b0000000000000000;
        number_two[14][0:15] <=		16'b0000000000000000;
        number_two[15][0:15] <=		16'b0000000000000000;
        //number3
        number_three[0][0:15] <=	16'b0000000000000000;
        number_three[1][0:15] <=	16'b0000000000000000;
        number_three[2][0:15] <=	16'b0000000000000000;
        number_three[3][0:15] <=	16'b0000011111100000;
        number_three[4][0:15] <=	16'b0000111111110000;
        number_three[5][0:15] <=	16'b0000110000110000;
        number_three[6][0:15] <=	16'b0000000000110000;
        number_three[7][0:15] <=	16'b0000000111100000;
        number_three[8][0:15] <=	16'b0000000111100000;
        number_three[9][0:15] <=	16'b0000000000110000;
        number_three[10][0:15] <=	16'b0000110000110000;
        number_three[11][0:15] <=	16'b0000111111110000;
        number_three[12][0:15] <=	16'b0000011111100000;
        number_three[13][0:15] <=	16'b0000000000000000;
        number_three[14][0:15] <=	16'b0000000000000000;
        number_three[15][0:15] <=	16'b0000000000000000;
        //number4
        number_four[0][0:15] <=		16'b0000000000000000;
        number_four[1][0:15] <=		16'b0000000000000000;
        number_four[2][0:15] <=		16'b0000000000000000;
        number_four[3][0:15] <=		16'b0000000011100000;
        number_four[4][0:15] <=		16'b0000000111100000;
        number_four[5][0:15] <=		16'b0000001111100000;
        number_four[6][0:15] <=		16'b0000011101100000;
        number_four[7][0:15] <=		16'b0000111001100000;
        number_four[8][0:15] <=		16'b0000110001100000;
        number_four[9][0:15] <=		16'b0000111111110000;
        number_four[10][0:15] <=	16'b0000111111110000;
        number_four[11][0:15] <=	16'b0000000001100000;
        number_four[12][0:15] <=	16'b0000000001100000;
        number_four[13][0:15] <=	16'b0000000000000000;
        number_four[14][0:15] <=	16'b0000000000000000;
        number_four[15][0:15] <=	16'b0000000000000000;
        //number5
        number_five[0][0:15] <=		16'b0000000000000000;
        number_five[1][0:15] <=		16'b0000000000000000;
        number_five[2][0:15] <=		16'b0000000000000000;
        number_five[3][0:15] <=		16'b0000111111110000;
        number_five[4][0:15] <=		16'b0000111111110000;
        number_five[5][0:15] <=		16'b0000110000000000;
        number_five[6][0:15] <=		16'b0000110000000000;
        number_five[7][0:15] <=		16'b0000111111100000;
        number_five[8][0:15] <=		16'b0000111111110000;
        number_five[9][0:15] <=		16'b0000000000110000;
        number_five[10][0:15] <=	16'b0000000000110000;
        number_five[11][0:15] <=	16'b0000111111110000;
        number_five[12][0:15] <=	16'b0000111111100000;
        number_five[13][0:15] <=	16'b0000000000000000;
        number_five[14][0:15] <=	16'b0000000000000000;
        number_five[15][0:15] <=	16'b0000000000000000;
        //number6
        number_six[0][0:15] <=		16'b0000000000000000;
        number_six[1][0:15] <=		16'b0000000000000000;
        number_six[2][0:15] <=		16'b0000000000000000;
        number_six[3][0:15] <=		16'b0000011111110000;
        number_six[4][0:15] <=		16'b0000111111110000;
        number_six[5][0:15] <=		16'b0000110000000000;
        number_six[6][0:15] <=		16'b0000110000000000;
        number_six[7][0:15] <=		16'b0000111111100000;
        number_six[8][0:15] <=		16'b0000111111110000;
        number_six[9][0:15] <=		16'b0000110000110000;
        number_six[10][0:15] <=		16'b0000110000110000;
        number_six[11][0:15] <=		16'b0000111111110000;
        number_six[12][0:15] <=		16'b0000011111100000;
        number_six[13][0:15] <=		16'b0000000000000000;
        number_six[14][0:15] <=		16'b0000000000000000;
        number_six[15][0:15] <=		16'b0000000000000000;
        //number7
        number_seven[0][0:15] <=	16'b0000000000000000;
        number_seven[1][0:15] <=	16'b0000000000000000;
        number_seven[2][0:15] <=	16'b0000000000000000;
        number_seven[3][0:15] <=	16'b0000111111110000;
        number_seven[4][0:15] <=	16'b0000111111110000;
        number_seven[5][0:15] <=	16'b0000000000110000;
        number_seven[6][0:15] <=	16'b0000000001110000;
        number_seven[7][0:15] <=	16'b0000000011100000;
        number_seven[8][0:15] <=	16'b0000000111000000;
        number_seven[9][0:15] <=	16'b0000001110000000;
        number_seven[10][0:15] <=	16'b0000011100000000;
        number_seven[11][0:15] <=	16'b0000111000000000;
        number_seven[12][0:15] <=	16'b0000110000000000;
        number_seven[13][0:15] <=	16'b0000000000000000;
        number_seven[14][0:15] <=	16'b0000000000000000;
        number_seven[15][0:15] <=	16'b0000000000000000;
        //number8
        number_eight[0][0:15] <=	16'b0000000000000000;
        number_eight[1][0:15] <=	16'b0000000000000000;
        number_eight[2][0:15] <=	16'b0000000000000000;
        number_eight[3][0:15] <=	16'b0000011111100000;
        number_eight[4][0:15] <=	16'b0000111111110000;
        number_eight[5][0:15] <=	16'b0000110000110000;
        number_eight[6][0:15] <=	16'b0000110000110000;
        number_eight[7][0:15] <=	16'b0000011111100000;
        number_eight[8][0:15] <=	16'b0000011111100000;
        number_eight[9][0:15] <=	16'b0000110000110000;
        number_eight[10][0:15] <=	16'b0000110000110000;
        number_eight[11][0:15] <=	16'b0000111111110000;
        number_eight[12][0:15] <=	16'b0000011111100000;
        number_eight[13][0:15] <=	16'b0000000000000000;
        number_eight[14][0:15] <=	16'b0000000000000000;
        number_eight[15][0:15] <=	16'b0000000000000000;
        //number9
        number_nine[0][0:15] <=		16'b0000000000000000;
        number_nine[1][0:15] <=		16'b0000000000000000;
        number_nine[2][0:15] <=		16'b0000000000000000;
        number_nine[3][0:15] <=		16'b0000011111100000;
        number_nine[4][0:15] <=		16'b0000111111110000;
        number_nine[5][0:15] <=		16'b0000110000110000;
        number_nine[6][0:15] <=		16'b0000110000110000;
        number_nine[7][0:15] <=		16'b0000111111110000;
        number_nine[8][0:15] <=		16'b0000011111110000;
        number_nine[9][0:15] <=		16'b0000000000110000;
        number_nine[10][0:15] <=	16'b0000000000110000;
        number_nine[11][0:15] <=	16'b0000111111110000;
        number_nine[12][0:15] <=	16'b0000111111100000;
        number_nine[13][0:15] <=	16'b0000000000000000;
        number_nine[14][0:15] <=	16'b0000000000000000;
        number_nine[15][0:15] <=	16'b0000000000000000;
     end else if (chipselect && write)
       case (address)
         3'h0 : head_x <= writedata;
         3'h1 : head_y <= writedata;
	 3'h2 : snake_length <= writedata;
         3'h3 : apple_x <= writedata;
         3'h4 : apple_y <= writedata;
       endcase

   always_ff @(posedge clk)
     if(reset)begin
        pos_x[0] <= 50;
        pos_y[0] <= 40;
        pos_x[1] <= 51;
        pos_y[1] <= 40;
     end
     else begin
     if(pos_x[0] != head_x||pos_y[0] != head_y )begin
       extend<=1;
       score_a <= snake_length%10;
       score_b <= (snake_length/10)%10;
       score_c <= snake_length/100;
       for (int j=200; j>0;j--)begin
        if(j<=snake_length-1)begin
         pos_x[j]=pos_x[j-1];
         pos_y[j]=pos_y[j-1];
        end
       end
       pos_x[0]=head_x;
       pos_y[0]=head_y;
       extend<=0;
       /*if(pos_x[1]>30&&pos_y[1]<=40&&pos_x[1]<70)begin pos_x[0]=pos_x[1]-1; pos_y[0]=pos_y[1];end
        else if(pos_x[1]<=30&&pos_y[1]<60) begin pos_x[0]=pos_x[1]; pos_y[0]=pos_y[1]+1;end
         else if(pos_x[1]>30&&pos_y[1]>=60&&pos_x[1]<70) begin pos_x[0]=pos_x[1]+1; pos_y[0]=pos_y[1];end
          else if(pos_x[1]>=70) begin pos_x[0]=pos_x[1]; pos_y[0]=pos_y[1]-1;end
       sim_time = 0;*/
     end
     end

     always_comb begin
     {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h0};
     if (VGA_BLANK_n && !extend)begin
      {VGA_R, VGA_G, VGA_B} ={8'h0, 8'h0, 8'h80};
      for(int i=0; i<200;i++) begin
       if(i<snake_length&&i!=0)begin
        if (hcount > 12*pos_x[i] && hcount < 12*(pos_x[i]+1)
	        && vcount > 6*pos_y[i] && vcount < 6*(pos_y[i]+1))
         {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
        end
       else if(i==0&&hcount > 12*pos_x[i] && hcount < 12*(pos_x[i]+1)
	        && vcount > 6*pos_y[i] && vcount < 6*(pos_y[i]+1)) {VGA_R, VGA_G, VGA_B} ={8'h0, 8'h80, 8'h0};
	   /*else if (hcount[10:6] == 5'd3 &&
	    vcount[9:5] == 5'd3)
	   {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};*/
	   
      end 
     if (hcount > 12*apple_x && hcount < 12*(apple_x+1)
	        && vcount > 6*apple_y && vcount < 6*(apple_y+1))
         {VGA_R, VGA_G, VGA_B} = {8'h80, 8'h0, 8'h0};
     if ((hcount>=0&&hcount<12) || (hcount >= 79*12 && hcount<80*12)
	        || (vcount >= 0&&vcount<6&& hcount<79*12)||(vcount >= 79*6&&vcount<80*6&& hcount<79*12))
         {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
     

      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==0)begin
         if(number_zero[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==1)begin
         if(number_one[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==2)begin
         if(number_two[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==3)begin
         if(number_three[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==4)begin
         if(number_four[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==5)begin
         if(number_five[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==6)begin
         if(number_six[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==7)begin
         if(number_seven[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==8)begin
         if(number_eight[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1100 && hcount <1116
	        && vcount >=30 && vcount < 46&&score_a==9)begin
         if(number_nine[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end




      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==0)begin
         if(number_zero[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==1)begin
         if(number_one[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==2)begin
         if(number_two[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==3)begin
         if(number_three[vcount-30][hcount-1100]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==4)begin
         if(number_four[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==5)begin
         if(number_five[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==6)begin
         if(number_six[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==7)begin
         if(number_seven[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==8)begin
         if(number_eight[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1075 && hcount <1091
	        && vcount >=30 && vcount < 46&&score_b==9)begin
         if(number_nine[vcount-30][hcount-1075]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end



     if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==0)begin
         if(number_zero[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==1)begin
         if(number_one[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==2)begin
         if(number_two[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==3)begin
         if(number_three[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==4)begin
         if(number_four[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==5)begin
         if(number_five[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==6)begin
         if(number_six[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==7)begin
         if(number_seven[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==8)begin
         if(number_eight[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end
      if (hcount >= 1050 && hcount <1066
	        && vcount >=30 && vcount < 46&&score_c==9)begin
         if(number_nine[vcount-30][hcount-1050]==1) {VGA_R, VGA_G, VGA_B} = {8'hff, 8'hff, 8'hff};
         else {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h80};
      end 
     end
     end
	       
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
