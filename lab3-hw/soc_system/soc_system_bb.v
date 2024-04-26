
module soc_system (
	clk_clk,
	hps_hps_io_emac1_inst_TX_CLK,
	hps_hps_io_emac1_inst_TXD0,
	hps_hps_io_emac1_inst_TXD1,
	hps_hps_io_emac1_inst_TXD2,
	hps_hps_io_emac1_inst_TXD3,
	hps_hps_io_emac1_inst_RXD0,
	hps_hps_io_emac1_inst_MDIO,
	hps_hps_io_emac1_inst_MDC,
	hps_hps_io_emac1_inst_RX_CTL,
	hps_hps_io_emac1_inst_TX_CTL,
	hps_hps_io_emac1_inst_RX_CLK,
	hps_hps_io_emac1_inst_RXD1,
	hps_hps_io_emac1_inst_RXD2,
	hps_hps_io_emac1_inst_RXD3,
	hps_hps_io_sdio_inst_CMD,
	hps_hps_io_sdio_inst_D0,
	hps_hps_io_sdio_inst_D1,
	hps_hps_io_sdio_inst_CLK,
	hps_hps_io_sdio_inst_D2,
	hps_hps_io_sdio_inst_D3,
	hps_hps_io_usb1_inst_D0,
	hps_hps_io_usb1_inst_D1,
	hps_hps_io_usb1_inst_D2,
	hps_hps_io_usb1_inst_D3,
	hps_hps_io_usb1_inst_D4,
	hps_hps_io_usb1_inst_D5,
	hps_hps_io_usb1_inst_D6,
	hps_hps_io_usb1_inst_D7,
	hps_hps_io_usb1_inst_CLK,
	hps_hps_io_usb1_inst_STP,
	hps_hps_io_usb1_inst_DIR,
	hps_hps_io_usb1_inst_NXT,
	hps_hps_io_spim1_inst_CLK,
	hps_hps_io_spim1_inst_MOSI,
	hps_hps_io_spim1_inst_MISO,
	hps_hps_io_spim1_inst_SS0,
	hps_hps_io_uart0_inst_RX,
	hps_hps_io_uart0_inst_TX,
	hps_hps_io_i2c0_inst_SDA,
	hps_hps_io_i2c0_inst_SCL,
	hps_hps_io_i2c1_inst_SDA,
	hps_hps_io_i2c1_inst_SCL,
	hps_hps_io_gpio_inst_GPIO09,
	hps_hps_io_gpio_inst_GPIO35,
	hps_hps_io_gpio_inst_GPIO40,
	hps_hps_io_gpio_inst_GPIO48,
	hps_hps_io_gpio_inst_GPIO53,
	hps_hps_io_gpio_inst_GPIO54,
	hps_hps_io_gpio_inst_GPIO61,
	hps_ddr3_mem_a,
	hps_ddr3_mem_ba,
	hps_ddr3_mem_ck,
	hps_ddr3_mem_ck_n,
	hps_ddr3_mem_cke,
	hps_ddr3_mem_cs_n,
	hps_ddr3_mem_ras_n,
	hps_ddr3_mem_cas_n,
	hps_ddr3_mem_we_n,
	hps_ddr3_mem_reset_n,
	hps_ddr3_mem_dq,
	hps_ddr3_mem_dqs,
	hps_ddr3_mem_dqs_n,
	hps_ddr3_mem_odt,
	hps_ddr3_mem_dm,
	hps_ddr3_oct_rzqin,
	reset_reset_n,
	vga_b,
	vga_blank_n,
	vga_clk,
	vga_g,
	vga_hs,
	vga_r,
	vga_sync_n,
	vga_vs,
	snake_body_bottomleft_sprite_s1_address,
	snake_body_bottomleft_sprite_s1_debugaccess,
	snake_body_bottomleft_sprite_s1_clken,
	snake_body_bottomleft_sprite_s1_chipselect,
	snake_body_bottomleft_sprite_s1_write,
	snake_body_bottomleft_sprite_s1_readdata,
	snake_body_bottomleft_sprite_s1_writedata,
	snake_body_bottomleft_sprite_s1_byteenable,
	snake_body_bottomright_snake_s1_address,
	snake_body_bottomright_snake_s1_debugaccess,
	snake_body_bottomright_snake_s1_clken,
	snake_body_bottomright_snake_s1_chipselect,
	snake_body_bottomright_snake_s1_write,
	snake_body_bottomright_snake_s1_readdata,
	snake_body_bottomright_snake_s1_writedata,
	snake_body_bottomright_snake_s1_byteenable,
	apple_sprite_s1_address,
	apple_sprite_s1_debugaccess,
	apple_sprite_s1_clken,
	apple_sprite_s1_chipselect,
	apple_sprite_s1_write,
	apple_sprite_s1_readdata,
	apple_sprite_s1_writedata,
	apple_sprite_s1_byteenable,
	snake_body_horizontal_sprite_s1_address,
	snake_body_horizontal_sprite_s1_debugaccess,
	snake_body_horizontal_sprite_s1_clken,
	snake_body_horizontal_sprite_s1_chipselect,
	snake_body_horizontal_sprite_s1_write,
	snake_body_horizontal_sprite_s1_readdata,
	snake_body_horizontal_sprite_s1_writedata,
	snake_body_horizontal_sprite_s1_byteenable,
	snake_body_topleft_sprite_s1_address,
	snake_body_topleft_sprite_s1_debugaccess,
	snake_body_topleft_sprite_s1_clken,
	snake_body_topleft_sprite_s1_chipselect,
	snake_body_topleft_sprite_s1_write,
	snake_body_topleft_sprite_s1_readdata,
	snake_body_topleft_sprite_s1_writedata,
	snake_body_topleft_sprite_s1_byteenable,
	snake_body_topright_sprite_s1_address,
	snake_body_topright_sprite_s1_debugaccess,
	snake_body_topright_sprite_s1_clken,
	snake_body_topright_sprite_s1_chipselect,
	snake_body_topright_sprite_s1_write,
	snake_body_topright_sprite_s1_readdata,
	snake_body_topright_sprite_s1_writedata,
	snake_body_topright_sprite_s1_byteenable,
	snake_body_vertical_sprite_s1_address,
	snake_body_vertical_sprite_s1_debugaccess,
	snake_body_vertical_sprite_s1_clken,
	snake_body_vertical_sprite_s1_chipselect,
	snake_body_vertical_sprite_s1_write,
	snake_body_vertical_sprite_s1_readdata,
	snake_body_vertical_sprite_s1_writedata,
	snake_body_vertical_sprite_s1_byteenable,
	wall_sprite_s1_address,
	wall_sprite_s1_debugaccess,
	wall_sprite_s1_clken,
	wall_sprite_s1_chipselect,
	wall_sprite_s1_write,
	wall_sprite_s1_readdata,
	wall_sprite_s1_writedata,
	wall_sprite_s1_byteenable,
	snake_head_down_sprite_s1_address,
	snake_head_down_sprite_s1_debugaccess,
	snake_head_down_sprite_s1_clken,
	snake_head_down_sprite_s1_chipselect,
	snake_head_down_sprite_s1_write,
	snake_head_down_sprite_s1_readdata,
	snake_head_down_sprite_s1_writedata,
	snake_head_down_sprite_s1_byteenable,
	snake_head_left_sprite_s1_address,
	snake_head_left_sprite_s1_debugaccess,
	snake_head_left_sprite_s1_clken,
	snake_head_left_sprite_s1_chipselect,
	snake_head_left_sprite_s1_write,
	snake_head_left_sprite_s1_readdata,
	snake_head_left_sprite_s1_writedata,
	snake_head_left_sprite_s1_byteenable,
	snake_head_right_sprite_s1_address,
	snake_head_right_sprite_s1_debugaccess,
	snake_head_right_sprite_s1_clken,
	snake_head_right_sprite_s1_chipselect,
	snake_head_right_sprite_s1_write,
	snake_head_right_sprite_s1_readdata,
	snake_head_right_sprite_s1_writedata,
	snake_head_right_sprite_s1_byteenable,
	snake_head_up_sprite_s1_address,
	snake_head_up_sprite_s1_debugaccess,
	snake_head_up_sprite_s1_clken,
	snake_head_up_sprite_s1_chipselect,
	snake_head_up_sprite_s1_write,
	snake_head_up_sprite_s1_readdata,
	snake_head_up_sprite_s1_writedata,
	snake_head_up_sprite_s1_byteenable,
	snake_tail_down_sprite_s1_address,
	snake_tail_down_sprite_s1_debugaccess,
	snake_tail_down_sprite_s1_clken,
	snake_tail_down_sprite_s1_chipselect,
	snake_tail_down_sprite_s1_write,
	snake_tail_down_sprite_s1_readdata,
	snake_tail_down_sprite_s1_writedata,
	snake_tail_down_sprite_s1_byteenable,
	snake_tail_left_sprite_s1_address,
	snake_tail_left_sprite_s1_debugaccess,
	snake_tail_left_sprite_s1_clken,
	snake_tail_left_sprite_s1_chipselect,
	snake_tail_left_sprite_s1_write,
	snake_tail_left_sprite_s1_readdata,
	snake_tail_left_sprite_s1_writedata,
	snake_tail_left_sprite_s1_byteenable,
	snake_tail_right_sprite_s1_address,
	snake_tail_right_sprite_s1_debugaccess,
	snake_tail_right_sprite_s1_clken,
	snake_tail_right_sprite_s1_chipselect,
	snake_tail_right_sprite_s1_write,
	snake_tail_right_sprite_s1_readdata,
	snake_tail_right_sprite_s1_writedata,
	snake_tail_right_sprite_s1_byteenable);	

	input		clk_clk;
	output		hps_hps_io_emac1_inst_TX_CLK;
	output		hps_hps_io_emac1_inst_TXD0;
	output		hps_hps_io_emac1_inst_TXD1;
	output		hps_hps_io_emac1_inst_TXD2;
	output		hps_hps_io_emac1_inst_TXD3;
	input		hps_hps_io_emac1_inst_RXD0;
	inout		hps_hps_io_emac1_inst_MDIO;
	output		hps_hps_io_emac1_inst_MDC;
	input		hps_hps_io_emac1_inst_RX_CTL;
	output		hps_hps_io_emac1_inst_TX_CTL;
	input		hps_hps_io_emac1_inst_RX_CLK;
	input		hps_hps_io_emac1_inst_RXD1;
	input		hps_hps_io_emac1_inst_RXD2;
	input		hps_hps_io_emac1_inst_RXD3;
	inout		hps_hps_io_sdio_inst_CMD;
	inout		hps_hps_io_sdio_inst_D0;
	inout		hps_hps_io_sdio_inst_D1;
	output		hps_hps_io_sdio_inst_CLK;
	inout		hps_hps_io_sdio_inst_D2;
	inout		hps_hps_io_sdio_inst_D3;
	inout		hps_hps_io_usb1_inst_D0;
	inout		hps_hps_io_usb1_inst_D1;
	inout		hps_hps_io_usb1_inst_D2;
	inout		hps_hps_io_usb1_inst_D3;
	inout		hps_hps_io_usb1_inst_D4;
	inout		hps_hps_io_usb1_inst_D5;
	inout		hps_hps_io_usb1_inst_D6;
	inout		hps_hps_io_usb1_inst_D7;
	input		hps_hps_io_usb1_inst_CLK;
	output		hps_hps_io_usb1_inst_STP;
	input		hps_hps_io_usb1_inst_DIR;
	input		hps_hps_io_usb1_inst_NXT;
	output		hps_hps_io_spim1_inst_CLK;
	output		hps_hps_io_spim1_inst_MOSI;
	input		hps_hps_io_spim1_inst_MISO;
	output		hps_hps_io_spim1_inst_SS0;
	input		hps_hps_io_uart0_inst_RX;
	output		hps_hps_io_uart0_inst_TX;
	inout		hps_hps_io_i2c0_inst_SDA;
	inout		hps_hps_io_i2c0_inst_SCL;
	inout		hps_hps_io_i2c1_inst_SDA;
	inout		hps_hps_io_i2c1_inst_SCL;
	inout		hps_hps_io_gpio_inst_GPIO09;
	inout		hps_hps_io_gpio_inst_GPIO35;
	inout		hps_hps_io_gpio_inst_GPIO40;
	inout		hps_hps_io_gpio_inst_GPIO48;
	inout		hps_hps_io_gpio_inst_GPIO53;
	inout		hps_hps_io_gpio_inst_GPIO54;
	inout		hps_hps_io_gpio_inst_GPIO61;
	output	[14:0]	hps_ddr3_mem_a;
	output	[2:0]	hps_ddr3_mem_ba;
	output		hps_ddr3_mem_ck;
	output		hps_ddr3_mem_ck_n;
	output		hps_ddr3_mem_cke;
	output		hps_ddr3_mem_cs_n;
	output		hps_ddr3_mem_ras_n;
	output		hps_ddr3_mem_cas_n;
	output		hps_ddr3_mem_we_n;
	output		hps_ddr3_mem_reset_n;
	inout	[31:0]	hps_ddr3_mem_dq;
	inout	[3:0]	hps_ddr3_mem_dqs;
	inout	[3:0]	hps_ddr3_mem_dqs_n;
	output		hps_ddr3_mem_odt;
	output	[3:0]	hps_ddr3_mem_dm;
	input		hps_ddr3_oct_rzqin;
	input		reset_reset_n;
	output	[7:0]	vga_b;
	output		vga_blank_n;
	output		vga_clk;
	output	[7:0]	vga_g;
	output		vga_hs;
	output	[7:0]	vga_r;
	output		vga_sync_n;
	output		vga_vs;
	input	[7:0]	snake_body_bottomleft_sprite_s1_address;
	input		snake_body_bottomleft_sprite_s1_debugaccess;
	input		snake_body_bottomleft_sprite_s1_clken;
	input		snake_body_bottomleft_sprite_s1_chipselect;
	input		snake_body_bottomleft_sprite_s1_write;
	output	[15:0]	snake_body_bottomleft_sprite_s1_readdata;
	input	[15:0]	snake_body_bottomleft_sprite_s1_writedata;
	input	[1:0]	snake_body_bottomleft_sprite_s1_byteenable;
	input	[7:0]	snake_body_bottomright_snake_s1_address;
	input		snake_body_bottomright_snake_s1_debugaccess;
	input		snake_body_bottomright_snake_s1_clken;
	input		snake_body_bottomright_snake_s1_chipselect;
	input		snake_body_bottomright_snake_s1_write;
	output	[15:0]	snake_body_bottomright_snake_s1_readdata;
	input	[15:0]	snake_body_bottomright_snake_s1_writedata;
	input	[1:0]	snake_body_bottomright_snake_s1_byteenable;
	input	[9:0]	apple_sprite_s1_address;
	input		apple_sprite_s1_debugaccess;
	input		apple_sprite_s1_clken;
	input		apple_sprite_s1_chipselect;
	input		apple_sprite_s1_write;
	output	[15:0]	apple_sprite_s1_readdata;
	input	[15:0]	apple_sprite_s1_writedata;
	input	[1:0]	apple_sprite_s1_byteenable;
	input	[7:0]	snake_body_horizontal_sprite_s1_address;
	input		snake_body_horizontal_sprite_s1_debugaccess;
	input		snake_body_horizontal_sprite_s1_clken;
	input		snake_body_horizontal_sprite_s1_chipselect;
	input		snake_body_horizontal_sprite_s1_write;
	output	[15:0]	snake_body_horizontal_sprite_s1_readdata;
	input	[15:0]	snake_body_horizontal_sprite_s1_writedata;
	input	[1:0]	snake_body_horizontal_sprite_s1_byteenable;
	input	[7:0]	snake_body_topleft_sprite_s1_address;
	input		snake_body_topleft_sprite_s1_debugaccess;
	input		snake_body_topleft_sprite_s1_clken;
	input		snake_body_topleft_sprite_s1_chipselect;
	input		snake_body_topleft_sprite_s1_write;
	output	[15:0]	snake_body_topleft_sprite_s1_readdata;
	input	[15:0]	snake_body_topleft_sprite_s1_writedata;
	input	[1:0]	snake_body_topleft_sprite_s1_byteenable;
	input	[7:0]	snake_body_topright_sprite_s1_address;
	input		snake_body_topright_sprite_s1_debugaccess;
	input		snake_body_topright_sprite_s1_clken;
	input		snake_body_topright_sprite_s1_chipselect;
	input		snake_body_topright_sprite_s1_write;
	output	[15:0]	snake_body_topright_sprite_s1_readdata;
	input	[15:0]	snake_body_topright_sprite_s1_writedata;
	input	[1:0]	snake_body_topright_sprite_s1_byteenable;
	input	[7:0]	snake_body_vertical_sprite_s1_address;
	input		snake_body_vertical_sprite_s1_debugaccess;
	input		snake_body_vertical_sprite_s1_clken;
	input		snake_body_vertical_sprite_s1_chipselect;
	input		snake_body_vertical_sprite_s1_write;
	output	[15:0]	snake_body_vertical_sprite_s1_readdata;
	input	[15:0]	snake_body_vertical_sprite_s1_writedata;
	input	[1:0]	snake_body_vertical_sprite_s1_byteenable;
	input	[9:0]	wall_sprite_s1_address;
	input		wall_sprite_s1_debugaccess;
	input		wall_sprite_s1_clken;
	input		wall_sprite_s1_chipselect;
	input		wall_sprite_s1_write;
	output	[15:0]	wall_sprite_s1_readdata;
	input	[15:0]	wall_sprite_s1_writedata;
	input	[1:0]	wall_sprite_s1_byteenable;
	input	[7:0]	snake_head_down_sprite_s1_address;
	input		snake_head_down_sprite_s1_debugaccess;
	input		snake_head_down_sprite_s1_clken;
	input		snake_head_down_sprite_s1_chipselect;
	input		snake_head_down_sprite_s1_write;
	output	[15:0]	snake_head_down_sprite_s1_readdata;
	input	[15:0]	snake_head_down_sprite_s1_writedata;
	input	[1:0]	snake_head_down_sprite_s1_byteenable;
	input	[7:0]	snake_head_left_sprite_s1_address;
	input		snake_head_left_sprite_s1_debugaccess;
	input		snake_head_left_sprite_s1_clken;
	input		snake_head_left_sprite_s1_chipselect;
	input		snake_head_left_sprite_s1_write;
	output	[15:0]	snake_head_left_sprite_s1_readdata;
	input	[15:0]	snake_head_left_sprite_s1_writedata;
	input	[1:0]	snake_head_left_sprite_s1_byteenable;
	input	[7:0]	snake_head_right_sprite_s1_address;
	input		snake_head_right_sprite_s1_debugaccess;
	input		snake_head_right_sprite_s1_clken;
	input		snake_head_right_sprite_s1_chipselect;
	input		snake_head_right_sprite_s1_write;
	output	[15:0]	snake_head_right_sprite_s1_readdata;
	input	[15:0]	snake_head_right_sprite_s1_writedata;
	input	[1:0]	snake_head_right_sprite_s1_byteenable;
	input	[7:0]	snake_head_up_sprite_s1_address;
	input		snake_head_up_sprite_s1_debugaccess;
	input		snake_head_up_sprite_s1_clken;
	input		snake_head_up_sprite_s1_chipselect;
	input		snake_head_up_sprite_s1_write;
	output	[15:0]	snake_head_up_sprite_s1_readdata;
	input	[15:0]	snake_head_up_sprite_s1_writedata;
	input	[1:0]	snake_head_up_sprite_s1_byteenable;
	input	[7:0]	snake_tail_down_sprite_s1_address;
	input		snake_tail_down_sprite_s1_debugaccess;
	input		snake_tail_down_sprite_s1_clken;
	input		snake_tail_down_sprite_s1_chipselect;
	input		snake_tail_down_sprite_s1_write;
	output	[15:0]	snake_tail_down_sprite_s1_readdata;
	input	[15:0]	snake_tail_down_sprite_s1_writedata;
	input	[1:0]	snake_tail_down_sprite_s1_byteenable;
	input	[7:0]	snake_tail_left_sprite_s1_address;
	input		snake_tail_left_sprite_s1_debugaccess;
	input		snake_tail_left_sprite_s1_clken;
	input		snake_tail_left_sprite_s1_chipselect;
	input		snake_tail_left_sprite_s1_write;
	output	[15:0]	snake_tail_left_sprite_s1_readdata;
	input	[15:0]	snake_tail_left_sprite_s1_writedata;
	input	[1:0]	snake_tail_left_sprite_s1_byteenable;
	input	[7:0]	snake_tail_right_sprite_s1_address;
	input		snake_tail_right_sprite_s1_debugaccess;
	input		snake_tail_right_sprite_s1_clken;
	input		snake_tail_right_sprite_s1_chipselect;
	input		snake_tail_right_sprite_s1_write;
	output	[15:0]	snake_tail_right_sprite_s1_readdata;
	input	[15:0]	snake_tail_right_sprite_s1_writedata;
	input	[1:0]	snake_tail_right_sprite_s1_byteenable;
endmodule
