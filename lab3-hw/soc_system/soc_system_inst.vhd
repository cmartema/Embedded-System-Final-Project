	component soc_system is
		port (
			clk_clk                                     : in    std_logic                     := 'X';             -- clk
			hps_hps_io_emac1_inst_TX_CLK                : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_hps_io_emac1_inst_TXD0                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_hps_io_emac1_inst_TXD1                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_hps_io_emac1_inst_TXD2                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_hps_io_emac1_inst_TXD3                  : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_hps_io_emac1_inst_RXD0                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_hps_io_emac1_inst_MDIO                  : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_hps_io_emac1_inst_MDC                   : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_hps_io_emac1_inst_RX_CTL                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_hps_io_emac1_inst_TX_CTL                : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_hps_io_emac1_inst_RX_CLK                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_hps_io_emac1_inst_RXD1                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_hps_io_emac1_inst_RXD2                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_hps_io_emac1_inst_RXD3                  : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_hps_io_sdio_inst_CMD                    : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_hps_io_sdio_inst_D0                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_hps_io_sdio_inst_D1                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_hps_io_sdio_inst_CLK                    : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_hps_io_sdio_inst_D2                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_hps_io_sdio_inst_D3                     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_hps_io_usb1_inst_D0                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_hps_io_usb1_inst_D1                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_hps_io_usb1_inst_D2                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_hps_io_usb1_inst_D3                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_hps_io_usb1_inst_D4                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_hps_io_usb1_inst_D5                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_hps_io_usb1_inst_D6                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_hps_io_usb1_inst_D7                     : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_hps_io_usb1_inst_CLK                    : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_hps_io_usb1_inst_STP                    : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_hps_io_usb1_inst_DIR                    : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_hps_io_usb1_inst_NXT                    : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_hps_io_spim1_inst_CLK                   : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_hps_io_spim1_inst_MOSI                  : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_hps_io_spim1_inst_MISO                  : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_hps_io_spim1_inst_SS0                   : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_hps_io_uart0_inst_RX                    : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_hps_io_uart0_inst_TX                    : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_hps_io_i2c0_inst_SDA                    : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_hps_io_i2c0_inst_SCL                    : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_hps_io_i2c1_inst_SDA                    : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_hps_io_i2c1_inst_SCL                    : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_hps_io_gpio_inst_GPIO09                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_hps_io_gpio_inst_GPIO35                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_hps_io_gpio_inst_GPIO40                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_hps_io_gpio_inst_GPIO48                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_hps_io_gpio_inst_GPIO53                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_hps_io_gpio_inst_GPIO54                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_hps_io_gpio_inst_GPIO61                 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			hps_ddr3_mem_a                              : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_ddr3_mem_ba                             : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_ddr3_mem_ck                             : out   std_logic;                                        -- mem_ck
			hps_ddr3_mem_ck_n                           : out   std_logic;                                        -- mem_ck_n
			hps_ddr3_mem_cke                            : out   std_logic;                                        -- mem_cke
			hps_ddr3_mem_cs_n                           : out   std_logic;                                        -- mem_cs_n
			hps_ddr3_mem_ras_n                          : out   std_logic;                                        -- mem_ras_n
			hps_ddr3_mem_cas_n                          : out   std_logic;                                        -- mem_cas_n
			hps_ddr3_mem_we_n                           : out   std_logic;                                        -- mem_we_n
			hps_ddr3_mem_reset_n                        : out   std_logic;                                        -- mem_reset_n
			hps_ddr3_mem_dq                             : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_ddr3_mem_dqs                            : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_ddr3_mem_dqs_n                          : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_ddr3_mem_odt                            : out   std_logic;                                        -- mem_odt
			hps_ddr3_mem_dm                             : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_ddr3_oct_rzqin                          : in    std_logic                     := 'X';             -- oct_rzqin
			reset_reset_n                               : in    std_logic                     := 'X';             -- reset_n
			vga_b                                       : out   std_logic_vector(7 downto 0);                     -- b
			vga_blank_n                                 : out   std_logic;                                        -- blank_n
			vga_clk                                     : out   std_logic;                                        -- clk
			vga_g                                       : out   std_logic_vector(7 downto 0);                     -- g
			vga_hs                                      : out   std_logic;                                        -- hs
			vga_r                                       : out   std_logic_vector(7 downto 0);                     -- r
			vga_sync_n                                  : out   std_logic;                                        -- sync_n
			vga_vs                                      : out   std_logic;                                        -- vs
			snake_body_bottomleft_sprite_s1_address     : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_body_bottomleft_sprite_s1_debugaccess : in    std_logic                     := 'X';             -- debugaccess
			snake_body_bottomleft_sprite_s1_clken       : in    std_logic                     := 'X';             -- clken
			snake_body_bottomleft_sprite_s1_chipselect  : in    std_logic                     := 'X';             -- chipselect
			snake_body_bottomleft_sprite_s1_write       : in    std_logic                     := 'X';             -- write
			snake_body_bottomleft_sprite_s1_readdata    : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_body_bottomleft_sprite_s1_writedata   : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_body_bottomleft_sprite_s1_byteenable  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_body_bottomright_snake_s1_address     : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_body_bottomright_snake_s1_debugaccess : in    std_logic                     := 'X';             -- debugaccess
			snake_body_bottomright_snake_s1_clken       : in    std_logic                     := 'X';             -- clken
			snake_body_bottomright_snake_s1_chipselect  : in    std_logic                     := 'X';             -- chipselect
			snake_body_bottomright_snake_s1_write       : in    std_logic                     := 'X';             -- write
			snake_body_bottomright_snake_s1_readdata    : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_body_bottomright_snake_s1_writedata   : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_body_bottomright_snake_s1_byteenable  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			apple_sprite_s1_address                     : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			apple_sprite_s1_debugaccess                 : in    std_logic                     := 'X';             -- debugaccess
			apple_sprite_s1_clken                       : in    std_logic                     := 'X';             -- clken
			apple_sprite_s1_chipselect                  : in    std_logic                     := 'X';             -- chipselect
			apple_sprite_s1_write                       : in    std_logic                     := 'X';             -- write
			apple_sprite_s1_readdata                    : out   std_logic_vector(15 downto 0);                    -- readdata
			apple_sprite_s1_writedata                   : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			apple_sprite_s1_byteenable                  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_body_horizontal_sprite_s1_address     : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_body_horizontal_sprite_s1_debugaccess : in    std_logic                     := 'X';             -- debugaccess
			snake_body_horizontal_sprite_s1_clken       : in    std_logic                     := 'X';             -- clken
			snake_body_horizontal_sprite_s1_chipselect  : in    std_logic                     := 'X';             -- chipselect
			snake_body_horizontal_sprite_s1_write       : in    std_logic                     := 'X';             -- write
			snake_body_horizontal_sprite_s1_readdata    : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_body_horizontal_sprite_s1_writedata   : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_body_horizontal_sprite_s1_byteenable  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_body_topleft_sprite_s1_address        : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_body_topleft_sprite_s1_debugaccess    : in    std_logic                     := 'X';             -- debugaccess
			snake_body_topleft_sprite_s1_clken          : in    std_logic                     := 'X';             -- clken
			snake_body_topleft_sprite_s1_chipselect     : in    std_logic                     := 'X';             -- chipselect
			snake_body_topleft_sprite_s1_write          : in    std_logic                     := 'X';             -- write
			snake_body_topleft_sprite_s1_readdata       : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_body_topleft_sprite_s1_writedata      : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_body_topleft_sprite_s1_byteenable     : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_body_topright_sprite_s1_address       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_body_topright_sprite_s1_debugaccess   : in    std_logic                     := 'X';             -- debugaccess
			snake_body_topright_sprite_s1_clken         : in    std_logic                     := 'X';             -- clken
			snake_body_topright_sprite_s1_chipselect    : in    std_logic                     := 'X';             -- chipselect
			snake_body_topright_sprite_s1_write         : in    std_logic                     := 'X';             -- write
			snake_body_topright_sprite_s1_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_body_topright_sprite_s1_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_body_topright_sprite_s1_byteenable    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_body_vertical_sprite_s1_address       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_body_vertical_sprite_s1_debugaccess   : in    std_logic                     := 'X';             -- debugaccess
			snake_body_vertical_sprite_s1_clken         : in    std_logic                     := 'X';             -- clken
			snake_body_vertical_sprite_s1_chipselect    : in    std_logic                     := 'X';             -- chipselect
			snake_body_vertical_sprite_s1_write         : in    std_logic                     := 'X';             -- write
			snake_body_vertical_sprite_s1_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_body_vertical_sprite_s1_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_body_vertical_sprite_s1_byteenable    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			wall_sprite_s1_address                      : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			wall_sprite_s1_debugaccess                  : in    std_logic                     := 'X';             -- debugaccess
			wall_sprite_s1_clken                        : in    std_logic                     := 'X';             -- clken
			wall_sprite_s1_chipselect                   : in    std_logic                     := 'X';             -- chipselect
			wall_sprite_s1_write                        : in    std_logic                     := 'X';             -- write
			wall_sprite_s1_readdata                     : out   std_logic_vector(15 downto 0);                    -- readdata
			wall_sprite_s1_writedata                    : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			wall_sprite_s1_byteenable                   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_head_down_sprite_s1_address           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_head_down_sprite_s1_debugaccess       : in    std_logic                     := 'X';             -- debugaccess
			snake_head_down_sprite_s1_clken             : in    std_logic                     := 'X';             -- clken
			snake_head_down_sprite_s1_chipselect        : in    std_logic                     := 'X';             -- chipselect
			snake_head_down_sprite_s1_write             : in    std_logic                     := 'X';             -- write
			snake_head_down_sprite_s1_readdata          : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_head_down_sprite_s1_writedata         : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_head_down_sprite_s1_byteenable        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_head_left_sprite_s1_address           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_head_left_sprite_s1_debugaccess       : in    std_logic                     := 'X';             -- debugaccess
			snake_head_left_sprite_s1_clken             : in    std_logic                     := 'X';             -- clken
			snake_head_left_sprite_s1_chipselect        : in    std_logic                     := 'X';             -- chipselect
			snake_head_left_sprite_s1_write             : in    std_logic                     := 'X';             -- write
			snake_head_left_sprite_s1_readdata          : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_head_left_sprite_s1_writedata         : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_head_left_sprite_s1_byteenable        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_head_right_sprite_s1_address          : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_head_right_sprite_s1_debugaccess      : in    std_logic                     := 'X';             -- debugaccess
			snake_head_right_sprite_s1_clken            : in    std_logic                     := 'X';             -- clken
			snake_head_right_sprite_s1_chipselect       : in    std_logic                     := 'X';             -- chipselect
			snake_head_right_sprite_s1_write            : in    std_logic                     := 'X';             -- write
			snake_head_right_sprite_s1_readdata         : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_head_right_sprite_s1_writedata        : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_head_right_sprite_s1_byteenable       : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_head_up_sprite_s1_address             : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_head_up_sprite_s1_debugaccess         : in    std_logic                     := 'X';             -- debugaccess
			snake_head_up_sprite_s1_clken               : in    std_logic                     := 'X';             -- clken
			snake_head_up_sprite_s1_chipselect          : in    std_logic                     := 'X';             -- chipselect
			snake_head_up_sprite_s1_write               : in    std_logic                     := 'X';             -- write
			snake_head_up_sprite_s1_readdata            : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_head_up_sprite_s1_writedata           : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_head_up_sprite_s1_byteenable          : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_tail_down_sprite_s1_address           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_tail_down_sprite_s1_debugaccess       : in    std_logic                     := 'X';             -- debugaccess
			snake_tail_down_sprite_s1_clken             : in    std_logic                     := 'X';             -- clken
			snake_tail_down_sprite_s1_chipselect        : in    std_logic                     := 'X';             -- chipselect
			snake_tail_down_sprite_s1_write             : in    std_logic                     := 'X';             -- write
			snake_tail_down_sprite_s1_readdata          : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_tail_down_sprite_s1_writedata         : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_tail_down_sprite_s1_byteenable        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_tail_left_sprite_s1_address           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_tail_left_sprite_s1_debugaccess       : in    std_logic                     := 'X';             -- debugaccess
			snake_tail_left_sprite_s1_clken             : in    std_logic                     := 'X';             -- clken
			snake_tail_left_sprite_s1_chipselect        : in    std_logic                     := 'X';             -- chipselect
			snake_tail_left_sprite_s1_write             : in    std_logic                     := 'X';             -- write
			snake_tail_left_sprite_s1_readdata          : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_tail_left_sprite_s1_writedata         : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_tail_left_sprite_s1_byteenable        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			snake_tail_right_sprite_s1_address          : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			snake_tail_right_sprite_s1_debugaccess      : in    std_logic                     := 'X';             -- debugaccess
			snake_tail_right_sprite_s1_clken            : in    std_logic                     := 'X';             -- clken
			snake_tail_right_sprite_s1_chipselect       : in    std_logic                     := 'X';             -- chipselect
			snake_tail_right_sprite_s1_write            : in    std_logic                     := 'X';             -- write
			snake_tail_right_sprite_s1_readdata         : out   std_logic_vector(15 downto 0);                    -- readdata
			snake_tail_right_sprite_s1_writedata        : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			snake_tail_right_sprite_s1_byteenable       : in    std_logic_vector(1 downto 0)  := (others => 'X')  -- byteenable
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			clk_clk                                     => CONNECTED_TO_clk_clk,                                     --                             clk.clk
			hps_hps_io_emac1_inst_TX_CLK                => CONNECTED_TO_hps_hps_io_emac1_inst_TX_CLK,                --                             hps.hps_io_emac1_inst_TX_CLK
			hps_hps_io_emac1_inst_TXD0                  => CONNECTED_TO_hps_hps_io_emac1_inst_TXD0,                  --                                .hps_io_emac1_inst_TXD0
			hps_hps_io_emac1_inst_TXD1                  => CONNECTED_TO_hps_hps_io_emac1_inst_TXD1,                  --                                .hps_io_emac1_inst_TXD1
			hps_hps_io_emac1_inst_TXD2                  => CONNECTED_TO_hps_hps_io_emac1_inst_TXD2,                  --                                .hps_io_emac1_inst_TXD2
			hps_hps_io_emac1_inst_TXD3                  => CONNECTED_TO_hps_hps_io_emac1_inst_TXD3,                  --                                .hps_io_emac1_inst_TXD3
			hps_hps_io_emac1_inst_RXD0                  => CONNECTED_TO_hps_hps_io_emac1_inst_RXD0,                  --                                .hps_io_emac1_inst_RXD0
			hps_hps_io_emac1_inst_MDIO                  => CONNECTED_TO_hps_hps_io_emac1_inst_MDIO,                  --                                .hps_io_emac1_inst_MDIO
			hps_hps_io_emac1_inst_MDC                   => CONNECTED_TO_hps_hps_io_emac1_inst_MDC,                   --                                .hps_io_emac1_inst_MDC
			hps_hps_io_emac1_inst_RX_CTL                => CONNECTED_TO_hps_hps_io_emac1_inst_RX_CTL,                --                                .hps_io_emac1_inst_RX_CTL
			hps_hps_io_emac1_inst_TX_CTL                => CONNECTED_TO_hps_hps_io_emac1_inst_TX_CTL,                --                                .hps_io_emac1_inst_TX_CTL
			hps_hps_io_emac1_inst_RX_CLK                => CONNECTED_TO_hps_hps_io_emac1_inst_RX_CLK,                --                                .hps_io_emac1_inst_RX_CLK
			hps_hps_io_emac1_inst_RXD1                  => CONNECTED_TO_hps_hps_io_emac1_inst_RXD1,                  --                                .hps_io_emac1_inst_RXD1
			hps_hps_io_emac1_inst_RXD2                  => CONNECTED_TO_hps_hps_io_emac1_inst_RXD2,                  --                                .hps_io_emac1_inst_RXD2
			hps_hps_io_emac1_inst_RXD3                  => CONNECTED_TO_hps_hps_io_emac1_inst_RXD3,                  --                                .hps_io_emac1_inst_RXD3
			hps_hps_io_sdio_inst_CMD                    => CONNECTED_TO_hps_hps_io_sdio_inst_CMD,                    --                                .hps_io_sdio_inst_CMD
			hps_hps_io_sdio_inst_D0                     => CONNECTED_TO_hps_hps_io_sdio_inst_D0,                     --                                .hps_io_sdio_inst_D0
			hps_hps_io_sdio_inst_D1                     => CONNECTED_TO_hps_hps_io_sdio_inst_D1,                     --                                .hps_io_sdio_inst_D1
			hps_hps_io_sdio_inst_CLK                    => CONNECTED_TO_hps_hps_io_sdio_inst_CLK,                    --                                .hps_io_sdio_inst_CLK
			hps_hps_io_sdio_inst_D2                     => CONNECTED_TO_hps_hps_io_sdio_inst_D2,                     --                                .hps_io_sdio_inst_D2
			hps_hps_io_sdio_inst_D3                     => CONNECTED_TO_hps_hps_io_sdio_inst_D3,                     --                                .hps_io_sdio_inst_D3
			hps_hps_io_usb1_inst_D0                     => CONNECTED_TO_hps_hps_io_usb1_inst_D0,                     --                                .hps_io_usb1_inst_D0
			hps_hps_io_usb1_inst_D1                     => CONNECTED_TO_hps_hps_io_usb1_inst_D1,                     --                                .hps_io_usb1_inst_D1
			hps_hps_io_usb1_inst_D2                     => CONNECTED_TO_hps_hps_io_usb1_inst_D2,                     --                                .hps_io_usb1_inst_D2
			hps_hps_io_usb1_inst_D3                     => CONNECTED_TO_hps_hps_io_usb1_inst_D3,                     --                                .hps_io_usb1_inst_D3
			hps_hps_io_usb1_inst_D4                     => CONNECTED_TO_hps_hps_io_usb1_inst_D4,                     --                                .hps_io_usb1_inst_D4
			hps_hps_io_usb1_inst_D5                     => CONNECTED_TO_hps_hps_io_usb1_inst_D5,                     --                                .hps_io_usb1_inst_D5
			hps_hps_io_usb1_inst_D6                     => CONNECTED_TO_hps_hps_io_usb1_inst_D6,                     --                                .hps_io_usb1_inst_D6
			hps_hps_io_usb1_inst_D7                     => CONNECTED_TO_hps_hps_io_usb1_inst_D7,                     --                                .hps_io_usb1_inst_D7
			hps_hps_io_usb1_inst_CLK                    => CONNECTED_TO_hps_hps_io_usb1_inst_CLK,                    --                                .hps_io_usb1_inst_CLK
			hps_hps_io_usb1_inst_STP                    => CONNECTED_TO_hps_hps_io_usb1_inst_STP,                    --                                .hps_io_usb1_inst_STP
			hps_hps_io_usb1_inst_DIR                    => CONNECTED_TO_hps_hps_io_usb1_inst_DIR,                    --                                .hps_io_usb1_inst_DIR
			hps_hps_io_usb1_inst_NXT                    => CONNECTED_TO_hps_hps_io_usb1_inst_NXT,                    --                                .hps_io_usb1_inst_NXT
			hps_hps_io_spim1_inst_CLK                   => CONNECTED_TO_hps_hps_io_spim1_inst_CLK,                   --                                .hps_io_spim1_inst_CLK
			hps_hps_io_spim1_inst_MOSI                  => CONNECTED_TO_hps_hps_io_spim1_inst_MOSI,                  --                                .hps_io_spim1_inst_MOSI
			hps_hps_io_spim1_inst_MISO                  => CONNECTED_TO_hps_hps_io_spim1_inst_MISO,                  --                                .hps_io_spim1_inst_MISO
			hps_hps_io_spim1_inst_SS0                   => CONNECTED_TO_hps_hps_io_spim1_inst_SS0,                   --                                .hps_io_spim1_inst_SS0
			hps_hps_io_uart0_inst_RX                    => CONNECTED_TO_hps_hps_io_uart0_inst_RX,                    --                                .hps_io_uart0_inst_RX
			hps_hps_io_uart0_inst_TX                    => CONNECTED_TO_hps_hps_io_uart0_inst_TX,                    --                                .hps_io_uart0_inst_TX
			hps_hps_io_i2c0_inst_SDA                    => CONNECTED_TO_hps_hps_io_i2c0_inst_SDA,                    --                                .hps_io_i2c0_inst_SDA
			hps_hps_io_i2c0_inst_SCL                    => CONNECTED_TO_hps_hps_io_i2c0_inst_SCL,                    --                                .hps_io_i2c0_inst_SCL
			hps_hps_io_i2c1_inst_SDA                    => CONNECTED_TO_hps_hps_io_i2c1_inst_SDA,                    --                                .hps_io_i2c1_inst_SDA
			hps_hps_io_i2c1_inst_SCL                    => CONNECTED_TO_hps_hps_io_i2c1_inst_SCL,                    --                                .hps_io_i2c1_inst_SCL
			hps_hps_io_gpio_inst_GPIO09                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO09,                 --                                .hps_io_gpio_inst_GPIO09
			hps_hps_io_gpio_inst_GPIO35                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO35,                 --                                .hps_io_gpio_inst_GPIO35
			hps_hps_io_gpio_inst_GPIO40                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO40,                 --                                .hps_io_gpio_inst_GPIO40
			hps_hps_io_gpio_inst_GPIO48                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO48,                 --                                .hps_io_gpio_inst_GPIO48
			hps_hps_io_gpio_inst_GPIO53                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO53,                 --                                .hps_io_gpio_inst_GPIO53
			hps_hps_io_gpio_inst_GPIO54                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO54,                 --                                .hps_io_gpio_inst_GPIO54
			hps_hps_io_gpio_inst_GPIO61                 => CONNECTED_TO_hps_hps_io_gpio_inst_GPIO61,                 --                                .hps_io_gpio_inst_GPIO61
			hps_ddr3_mem_a                              => CONNECTED_TO_hps_ddr3_mem_a,                              --                        hps_ddr3.mem_a
			hps_ddr3_mem_ba                             => CONNECTED_TO_hps_ddr3_mem_ba,                             --                                .mem_ba
			hps_ddr3_mem_ck                             => CONNECTED_TO_hps_ddr3_mem_ck,                             --                                .mem_ck
			hps_ddr3_mem_ck_n                           => CONNECTED_TO_hps_ddr3_mem_ck_n,                           --                                .mem_ck_n
			hps_ddr3_mem_cke                            => CONNECTED_TO_hps_ddr3_mem_cke,                            --                                .mem_cke
			hps_ddr3_mem_cs_n                           => CONNECTED_TO_hps_ddr3_mem_cs_n,                           --                                .mem_cs_n
			hps_ddr3_mem_ras_n                          => CONNECTED_TO_hps_ddr3_mem_ras_n,                          --                                .mem_ras_n
			hps_ddr3_mem_cas_n                          => CONNECTED_TO_hps_ddr3_mem_cas_n,                          --                                .mem_cas_n
			hps_ddr3_mem_we_n                           => CONNECTED_TO_hps_ddr3_mem_we_n,                           --                                .mem_we_n
			hps_ddr3_mem_reset_n                        => CONNECTED_TO_hps_ddr3_mem_reset_n,                        --                                .mem_reset_n
			hps_ddr3_mem_dq                             => CONNECTED_TO_hps_ddr3_mem_dq,                             --                                .mem_dq
			hps_ddr3_mem_dqs                            => CONNECTED_TO_hps_ddr3_mem_dqs,                            --                                .mem_dqs
			hps_ddr3_mem_dqs_n                          => CONNECTED_TO_hps_ddr3_mem_dqs_n,                          --                                .mem_dqs_n
			hps_ddr3_mem_odt                            => CONNECTED_TO_hps_ddr3_mem_odt,                            --                                .mem_odt
			hps_ddr3_mem_dm                             => CONNECTED_TO_hps_ddr3_mem_dm,                             --                                .mem_dm
			hps_ddr3_oct_rzqin                          => CONNECTED_TO_hps_ddr3_oct_rzqin,                          --                                .oct_rzqin
			reset_reset_n                               => CONNECTED_TO_reset_reset_n,                               --                           reset.reset_n
			vga_b                                       => CONNECTED_TO_vga_b,                                       --                             vga.b
			vga_blank_n                                 => CONNECTED_TO_vga_blank_n,                                 --                                .blank_n
			vga_clk                                     => CONNECTED_TO_vga_clk,                                     --                                .clk
			vga_g                                       => CONNECTED_TO_vga_g,                                       --                                .g
			vga_hs                                      => CONNECTED_TO_vga_hs,                                      --                                .hs
			vga_r                                       => CONNECTED_TO_vga_r,                                       --                                .r
			vga_sync_n                                  => CONNECTED_TO_vga_sync_n,                                  --                                .sync_n
			vga_vs                                      => CONNECTED_TO_vga_vs,                                      --                                .vs
			snake_body_bottomleft_sprite_s1_address     => CONNECTED_TO_snake_body_bottomleft_sprite_s1_address,     -- snake_body_bottomleft_sprite_s1.address
			snake_body_bottomleft_sprite_s1_debugaccess => CONNECTED_TO_snake_body_bottomleft_sprite_s1_debugaccess, --                                .debugaccess
			snake_body_bottomleft_sprite_s1_clken       => CONNECTED_TO_snake_body_bottomleft_sprite_s1_clken,       --                                .clken
			snake_body_bottomleft_sprite_s1_chipselect  => CONNECTED_TO_snake_body_bottomleft_sprite_s1_chipselect,  --                                .chipselect
			snake_body_bottomleft_sprite_s1_write       => CONNECTED_TO_snake_body_bottomleft_sprite_s1_write,       --                                .write
			snake_body_bottomleft_sprite_s1_readdata    => CONNECTED_TO_snake_body_bottomleft_sprite_s1_readdata,    --                                .readdata
			snake_body_bottomleft_sprite_s1_writedata   => CONNECTED_TO_snake_body_bottomleft_sprite_s1_writedata,   --                                .writedata
			snake_body_bottomleft_sprite_s1_byteenable  => CONNECTED_TO_snake_body_bottomleft_sprite_s1_byteenable,  --                                .byteenable
			snake_body_bottomright_snake_s1_address     => CONNECTED_TO_snake_body_bottomright_snake_s1_address,     -- snake_body_bottomright_snake_s1.address
			snake_body_bottomright_snake_s1_debugaccess => CONNECTED_TO_snake_body_bottomright_snake_s1_debugaccess, --                                .debugaccess
			snake_body_bottomright_snake_s1_clken       => CONNECTED_TO_snake_body_bottomright_snake_s1_clken,       --                                .clken
			snake_body_bottomright_snake_s1_chipselect  => CONNECTED_TO_snake_body_bottomright_snake_s1_chipselect,  --                                .chipselect
			snake_body_bottomright_snake_s1_write       => CONNECTED_TO_snake_body_bottomright_snake_s1_write,       --                                .write
			snake_body_bottomright_snake_s1_readdata    => CONNECTED_TO_snake_body_bottomright_snake_s1_readdata,    --                                .readdata
			snake_body_bottomright_snake_s1_writedata   => CONNECTED_TO_snake_body_bottomright_snake_s1_writedata,   --                                .writedata
			snake_body_bottomright_snake_s1_byteenable  => CONNECTED_TO_snake_body_bottomright_snake_s1_byteenable,  --                                .byteenable
			apple_sprite_s1_address                     => CONNECTED_TO_apple_sprite_s1_address,                     --                 apple_sprite_s1.address
			apple_sprite_s1_debugaccess                 => CONNECTED_TO_apple_sprite_s1_debugaccess,                 --                                .debugaccess
			apple_sprite_s1_clken                       => CONNECTED_TO_apple_sprite_s1_clken,                       --                                .clken
			apple_sprite_s1_chipselect                  => CONNECTED_TO_apple_sprite_s1_chipselect,                  --                                .chipselect
			apple_sprite_s1_write                       => CONNECTED_TO_apple_sprite_s1_write,                       --                                .write
			apple_sprite_s1_readdata                    => CONNECTED_TO_apple_sprite_s1_readdata,                    --                                .readdata
			apple_sprite_s1_writedata                   => CONNECTED_TO_apple_sprite_s1_writedata,                   --                                .writedata
			apple_sprite_s1_byteenable                  => CONNECTED_TO_apple_sprite_s1_byteenable,                  --                                .byteenable
			snake_body_horizontal_sprite_s1_address     => CONNECTED_TO_snake_body_horizontal_sprite_s1_address,     -- snake_body_horizontal_sprite_s1.address
			snake_body_horizontal_sprite_s1_debugaccess => CONNECTED_TO_snake_body_horizontal_sprite_s1_debugaccess, --                                .debugaccess
			snake_body_horizontal_sprite_s1_clken       => CONNECTED_TO_snake_body_horizontal_sprite_s1_clken,       --                                .clken
			snake_body_horizontal_sprite_s1_chipselect  => CONNECTED_TO_snake_body_horizontal_sprite_s1_chipselect,  --                                .chipselect
			snake_body_horizontal_sprite_s1_write       => CONNECTED_TO_snake_body_horizontal_sprite_s1_write,       --                                .write
			snake_body_horizontal_sprite_s1_readdata    => CONNECTED_TO_snake_body_horizontal_sprite_s1_readdata,    --                                .readdata
			snake_body_horizontal_sprite_s1_writedata   => CONNECTED_TO_snake_body_horizontal_sprite_s1_writedata,   --                                .writedata
			snake_body_horizontal_sprite_s1_byteenable  => CONNECTED_TO_snake_body_horizontal_sprite_s1_byteenable,  --                                .byteenable
			snake_body_topleft_sprite_s1_address        => CONNECTED_TO_snake_body_topleft_sprite_s1_address,        --    snake_body_topleft_sprite_s1.address
			snake_body_topleft_sprite_s1_debugaccess    => CONNECTED_TO_snake_body_topleft_sprite_s1_debugaccess,    --                                .debugaccess
			snake_body_topleft_sprite_s1_clken          => CONNECTED_TO_snake_body_topleft_sprite_s1_clken,          --                                .clken
			snake_body_topleft_sprite_s1_chipselect     => CONNECTED_TO_snake_body_topleft_sprite_s1_chipselect,     --                                .chipselect
			snake_body_topleft_sprite_s1_write          => CONNECTED_TO_snake_body_topleft_sprite_s1_write,          --                                .write
			snake_body_topleft_sprite_s1_readdata       => CONNECTED_TO_snake_body_topleft_sprite_s1_readdata,       --                                .readdata
			snake_body_topleft_sprite_s1_writedata      => CONNECTED_TO_snake_body_topleft_sprite_s1_writedata,      --                                .writedata
			snake_body_topleft_sprite_s1_byteenable     => CONNECTED_TO_snake_body_topleft_sprite_s1_byteenable,     --                                .byteenable
			snake_body_topright_sprite_s1_address       => CONNECTED_TO_snake_body_topright_sprite_s1_address,       --   snake_body_topright_sprite_s1.address
			snake_body_topright_sprite_s1_debugaccess   => CONNECTED_TO_snake_body_topright_sprite_s1_debugaccess,   --                                .debugaccess
			snake_body_topright_sprite_s1_clken         => CONNECTED_TO_snake_body_topright_sprite_s1_clken,         --                                .clken
			snake_body_topright_sprite_s1_chipselect    => CONNECTED_TO_snake_body_topright_sprite_s1_chipselect,    --                                .chipselect
			snake_body_topright_sprite_s1_write         => CONNECTED_TO_snake_body_topright_sprite_s1_write,         --                                .write
			snake_body_topright_sprite_s1_readdata      => CONNECTED_TO_snake_body_topright_sprite_s1_readdata,      --                                .readdata
			snake_body_topright_sprite_s1_writedata     => CONNECTED_TO_snake_body_topright_sprite_s1_writedata,     --                                .writedata
			snake_body_topright_sprite_s1_byteenable    => CONNECTED_TO_snake_body_topright_sprite_s1_byteenable,    --                                .byteenable
			snake_body_vertical_sprite_s1_address       => CONNECTED_TO_snake_body_vertical_sprite_s1_address,       --   snake_body_vertical_sprite_s1.address
			snake_body_vertical_sprite_s1_debugaccess   => CONNECTED_TO_snake_body_vertical_sprite_s1_debugaccess,   --                                .debugaccess
			snake_body_vertical_sprite_s1_clken         => CONNECTED_TO_snake_body_vertical_sprite_s1_clken,         --                                .clken
			snake_body_vertical_sprite_s1_chipselect    => CONNECTED_TO_snake_body_vertical_sprite_s1_chipselect,    --                                .chipselect
			snake_body_vertical_sprite_s1_write         => CONNECTED_TO_snake_body_vertical_sprite_s1_write,         --                                .write
			snake_body_vertical_sprite_s1_readdata      => CONNECTED_TO_snake_body_vertical_sprite_s1_readdata,      --                                .readdata
			snake_body_vertical_sprite_s1_writedata     => CONNECTED_TO_snake_body_vertical_sprite_s1_writedata,     --                                .writedata
			snake_body_vertical_sprite_s1_byteenable    => CONNECTED_TO_snake_body_vertical_sprite_s1_byteenable,    --                                .byteenable
			wall_sprite_s1_address                      => CONNECTED_TO_wall_sprite_s1_address,                      --                  wall_sprite_s1.address
			wall_sprite_s1_debugaccess                  => CONNECTED_TO_wall_sprite_s1_debugaccess,                  --                                .debugaccess
			wall_sprite_s1_clken                        => CONNECTED_TO_wall_sprite_s1_clken,                        --                                .clken
			wall_sprite_s1_chipselect                   => CONNECTED_TO_wall_sprite_s1_chipselect,                   --                                .chipselect
			wall_sprite_s1_write                        => CONNECTED_TO_wall_sprite_s1_write,                        --                                .write
			wall_sprite_s1_readdata                     => CONNECTED_TO_wall_sprite_s1_readdata,                     --                                .readdata
			wall_sprite_s1_writedata                    => CONNECTED_TO_wall_sprite_s1_writedata,                    --                                .writedata
			wall_sprite_s1_byteenable                   => CONNECTED_TO_wall_sprite_s1_byteenable,                   --                                .byteenable
			snake_head_down_sprite_s1_address           => CONNECTED_TO_snake_head_down_sprite_s1_address,           --       snake_head_down_sprite_s1.address
			snake_head_down_sprite_s1_debugaccess       => CONNECTED_TO_snake_head_down_sprite_s1_debugaccess,       --                                .debugaccess
			snake_head_down_sprite_s1_clken             => CONNECTED_TO_snake_head_down_sprite_s1_clken,             --                                .clken
			snake_head_down_sprite_s1_chipselect        => CONNECTED_TO_snake_head_down_sprite_s1_chipselect,        --                                .chipselect
			snake_head_down_sprite_s1_write             => CONNECTED_TO_snake_head_down_sprite_s1_write,             --                                .write
			snake_head_down_sprite_s1_readdata          => CONNECTED_TO_snake_head_down_sprite_s1_readdata,          --                                .readdata
			snake_head_down_sprite_s1_writedata         => CONNECTED_TO_snake_head_down_sprite_s1_writedata,         --                                .writedata
			snake_head_down_sprite_s1_byteenable        => CONNECTED_TO_snake_head_down_sprite_s1_byteenable,        --                                .byteenable
			snake_head_left_sprite_s1_address           => CONNECTED_TO_snake_head_left_sprite_s1_address,           --       snake_head_left_sprite_s1.address
			snake_head_left_sprite_s1_debugaccess       => CONNECTED_TO_snake_head_left_sprite_s1_debugaccess,       --                                .debugaccess
			snake_head_left_sprite_s1_clken             => CONNECTED_TO_snake_head_left_sprite_s1_clken,             --                                .clken
			snake_head_left_sprite_s1_chipselect        => CONNECTED_TO_snake_head_left_sprite_s1_chipselect,        --                                .chipselect
			snake_head_left_sprite_s1_write             => CONNECTED_TO_snake_head_left_sprite_s1_write,             --                                .write
			snake_head_left_sprite_s1_readdata          => CONNECTED_TO_snake_head_left_sprite_s1_readdata,          --                                .readdata
			snake_head_left_sprite_s1_writedata         => CONNECTED_TO_snake_head_left_sprite_s1_writedata,         --                                .writedata
			snake_head_left_sprite_s1_byteenable        => CONNECTED_TO_snake_head_left_sprite_s1_byteenable,        --                                .byteenable
			snake_head_right_sprite_s1_address          => CONNECTED_TO_snake_head_right_sprite_s1_address,          --      snake_head_right_sprite_s1.address
			snake_head_right_sprite_s1_debugaccess      => CONNECTED_TO_snake_head_right_sprite_s1_debugaccess,      --                                .debugaccess
			snake_head_right_sprite_s1_clken            => CONNECTED_TO_snake_head_right_sprite_s1_clken,            --                                .clken
			snake_head_right_sprite_s1_chipselect       => CONNECTED_TO_snake_head_right_sprite_s1_chipselect,       --                                .chipselect
			snake_head_right_sprite_s1_write            => CONNECTED_TO_snake_head_right_sprite_s1_write,            --                                .write
			snake_head_right_sprite_s1_readdata         => CONNECTED_TO_snake_head_right_sprite_s1_readdata,         --                                .readdata
			snake_head_right_sprite_s1_writedata        => CONNECTED_TO_snake_head_right_sprite_s1_writedata,        --                                .writedata
			snake_head_right_sprite_s1_byteenable       => CONNECTED_TO_snake_head_right_sprite_s1_byteenable,       --                                .byteenable
			snake_head_up_sprite_s1_address             => CONNECTED_TO_snake_head_up_sprite_s1_address,             --         snake_head_up_sprite_s1.address
			snake_head_up_sprite_s1_debugaccess         => CONNECTED_TO_snake_head_up_sprite_s1_debugaccess,         --                                .debugaccess
			snake_head_up_sprite_s1_clken               => CONNECTED_TO_snake_head_up_sprite_s1_clken,               --                                .clken
			snake_head_up_sprite_s1_chipselect          => CONNECTED_TO_snake_head_up_sprite_s1_chipselect,          --                                .chipselect
			snake_head_up_sprite_s1_write               => CONNECTED_TO_snake_head_up_sprite_s1_write,               --                                .write
			snake_head_up_sprite_s1_readdata            => CONNECTED_TO_snake_head_up_sprite_s1_readdata,            --                                .readdata
			snake_head_up_sprite_s1_writedata           => CONNECTED_TO_snake_head_up_sprite_s1_writedata,           --                                .writedata
			snake_head_up_sprite_s1_byteenable          => CONNECTED_TO_snake_head_up_sprite_s1_byteenable,          --                                .byteenable
			snake_tail_down_sprite_s1_address           => CONNECTED_TO_snake_tail_down_sprite_s1_address,           --       snake_tail_down_sprite_s1.address
			snake_tail_down_sprite_s1_debugaccess       => CONNECTED_TO_snake_tail_down_sprite_s1_debugaccess,       --                                .debugaccess
			snake_tail_down_sprite_s1_clken             => CONNECTED_TO_snake_tail_down_sprite_s1_clken,             --                                .clken
			snake_tail_down_sprite_s1_chipselect        => CONNECTED_TO_snake_tail_down_sprite_s1_chipselect,        --                                .chipselect
			snake_tail_down_sprite_s1_write             => CONNECTED_TO_snake_tail_down_sprite_s1_write,             --                                .write
			snake_tail_down_sprite_s1_readdata          => CONNECTED_TO_snake_tail_down_sprite_s1_readdata,          --                                .readdata
			snake_tail_down_sprite_s1_writedata         => CONNECTED_TO_snake_tail_down_sprite_s1_writedata,         --                                .writedata
			snake_tail_down_sprite_s1_byteenable        => CONNECTED_TO_snake_tail_down_sprite_s1_byteenable,        --                                .byteenable
			snake_tail_left_sprite_s1_address           => CONNECTED_TO_snake_tail_left_sprite_s1_address,           --       snake_tail_left_sprite_s1.address
			snake_tail_left_sprite_s1_debugaccess       => CONNECTED_TO_snake_tail_left_sprite_s1_debugaccess,       --                                .debugaccess
			snake_tail_left_sprite_s1_clken             => CONNECTED_TO_snake_tail_left_sprite_s1_clken,             --                                .clken
			snake_tail_left_sprite_s1_chipselect        => CONNECTED_TO_snake_tail_left_sprite_s1_chipselect,        --                                .chipselect
			snake_tail_left_sprite_s1_write             => CONNECTED_TO_snake_tail_left_sprite_s1_write,             --                                .write
			snake_tail_left_sprite_s1_readdata          => CONNECTED_TO_snake_tail_left_sprite_s1_readdata,          --                                .readdata
			snake_tail_left_sprite_s1_writedata         => CONNECTED_TO_snake_tail_left_sprite_s1_writedata,         --                                .writedata
			snake_tail_left_sprite_s1_byteenable        => CONNECTED_TO_snake_tail_left_sprite_s1_byteenable,        --                                .byteenable
			snake_tail_right_sprite_s1_address          => CONNECTED_TO_snake_tail_right_sprite_s1_address,          --      snake_tail_right_sprite_s1.address
			snake_tail_right_sprite_s1_debugaccess      => CONNECTED_TO_snake_tail_right_sprite_s1_debugaccess,      --                                .debugaccess
			snake_tail_right_sprite_s1_clken            => CONNECTED_TO_snake_tail_right_sprite_s1_clken,            --                                .clken
			snake_tail_right_sprite_s1_chipselect       => CONNECTED_TO_snake_tail_right_sprite_s1_chipselect,       --                                .chipselect
			snake_tail_right_sprite_s1_write            => CONNECTED_TO_snake_tail_right_sprite_s1_write,            --                                .write
			snake_tail_right_sprite_s1_readdata         => CONNECTED_TO_snake_tail_right_sprite_s1_readdata,         --                                .readdata
			snake_tail_right_sprite_s1_writedata        => CONNECTED_TO_snake_tail_right_sprite_s1_writedata,        --                                .writedata
			snake_tail_right_sprite_s1_byteenable       => CONNECTED_TO_snake_tail_right_sprite_s1_byteenable        --                                .byteenable
		);

