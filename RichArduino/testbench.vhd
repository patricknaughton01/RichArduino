--- 2018 RSRC new "VGA Testbench" VHDL Code 
--- Current file name:  testbench.vhd
--- Last Revised:  8/22/2018; 10:03 a.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;

ENTITY testbench IS
   PORT(clk       : IN  STD_LOGIC;
        reset_l_usb   : IN  STD_LOGIC;
		  reset_l_but	 : IN STD_LOGIC;
		  txe_l		: IN  STD_LOGIC;
		  rxf_l		: IN	STD_LOGIC;
--        r         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
--        g         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
--        b         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
--        hs        : OUT STD_LOGIC ;
--        vs        : OUT STD_LOGIC ;
		  usb_bus	: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		  usb_rd		: OUT	STD_LOGIC ;
		  usb_wr		: OUT STD_LOGIC ;
		  TMDSp 		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
		  TMDSn 		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
		  TMDSp_clock : OUT STD_LOGIC ;
		  TMDSn_clock : OUT STD_LOGIC ;
		  pins		: INOUT STD_LOGIC_VECTOR(21 DOWNTO 0));
END testbench ;

ARCHITECTURE structure OF testbench IS

   COMPONENT mydcm
   PORT (clk_out1 : OUT STD_LOGIC;
			clk_out2 : OUT	STD_LOGIC;
			clk_out3 : OUT STD_LOGIC;
         clk_in1  : IN  STD_LOGIC);
   END COMPONENT;

   COMPONENT rsrc
   PORT(clk      : IN    STD_LOGIC ;
        reset_l  : IN    STD_LOGIC ;
        d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        read     : OUT   STD_LOGIC ;
        write    : OUT   STD_LOGIC ;
        done     : IN    STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT eprom
      PORT(d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
           ce_l     : IN  STD_LOGIC ;
           oe_l     : IN  STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT sram
      PORT (d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
            address  : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
            ce_l     : IN    STD_LOGIC ;
            oe_l     : IN    STD_LOGIC ;
            we_l     : IN    STD_LOGIC ;
            clk      : IN    STD_LOGIC) ;
   END COMPONENT ;
   
	COMPONENT myhdmi
	PORT( clka : IN STD_LOGIC ;
			clkb : IN STD_LOGIC ;
			ena : IN	STD_LOGIC ;
			wea : IN	STD_LOGIC_VECTOR(0 DOWNTO 0) ;
			addra : IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
			dina	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			TMDSp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSn : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) ;
			TMDSp_clock : OUT STD_LOGIC ;
			TMDSn_clock : OUT STD_LOGIC) ;
	END COMPONENT;
--   COMPONENT vga
--   PORT(clk      : IN  STD_LOGIC ;
--        ena      : IN  STD_LOGIC ;
--        wea      : IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
--        addra    : IN  STD_LOGIC_VECTOR(11 DOWNTO 0) ;
--        dina     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
--        r        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
--        g        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
--        b        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
--        hs       : OUT STD_LOGIC ;
--        vs       : OUT STD_LOGIC);
--   END COMPONENT ;   
		
	COMPONENT usb
	PORT (  d_bus		:	INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			  d_usb		:	INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  clk			:	IN		STD_LOGIC;
			  usb_rd_h	:	IN		STD_LOGIC;
			  usb_wr_h	:	IN		STD_LOGIC;
			  txe_oe_l	:	IN		STD_LOGIC;
			  rxf_oe_l	:	IN		STD_LOGIC;
			  txe_l		:	IN		STD_LOGIC;
			  rxf_l		:	IN		STD_LOGIC;
			  rd_l		:	OUT	STD_LOGIC;
			  wr_h		:	OUT	STD_LOGIC;
			  usb_done	:	INOUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT io
	PORT(	clk	: IN		STD_LOGIC;
			d		: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			addr	: IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
			ce_l	: IN		STD_LOGIC;
			we_l	: IN		STD_LOGIC;
			oe_l	: IN		STD_LOGIC;
			pins	: INOUT	STD_LOGIC_VECTOR(21 DOWNTO 0));
	END COMPONENT;

	SIGNAL reset_l		  : STD_LOGIC ;
   SIGNAL reset_l_temp : STD_LOGIC ;
   SIGNAL reset_l_sync : STD_LOGIC ;
   SIGNAL clk_out1     : STD_LOGIC ;
	SIGNAL clk_out2	  : STD_LOGIC ;
	SIGNAL clk_out3	  : STD_LOGIC ;
   SIGNAL d            : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL address      : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL read         : STD_LOGIC;
   SIGNAL write        : STD_LOGIC;
   SIGNAL done         : STD_LOGIC;
   SIGNAL eprom_ce_l   :  STD_LOGIC ;
   SIGNAL eprom_oe_l   :  STD_LOGIC ;
   SIGNAL sram_ce_l    :  STD_LOGIC ;
   SIGNAL sram_oe_l    :  STD_LOGIC ;
   SIGNAL sram_we_l    :  STD_LOGIC ;
   SIGNAL hdmi_ena	  : STD_LOGIC;
   SIGNAL hdmi_wea     : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
	SIGNAL usb_done	  : STD_LOGIC ;
	SIGNAL usb_oe_h	  : STD_LOGIC ;
	SIGNAL usb_we_h	  : STD_LOGIC ;
	SIGNAL usb_txe_oe_l : STD_LOGIC ;
	SIGNAL usb_rxf_oe_l : STD_LOGIC ;
	SIGNAL io_ce_l		  : STD_LOGIC ;
	SIGNAL io_we_l		  : STD_LOGIC ;
	SIGNAL io_oe_l		  : STD_LOGIC ;

BEGIN

   mydcm1:mydcm
   PORT MAP(clk_out1 => clk_out1 ,
				clk_out2 => clk_out2 ,
				clk_out3 => clk_out3,
            clk_in1  => clk) ;
				
	reset_l <= reset_l_usb AND reset_l_but;

   --syncprocess:PROCESS(clk_out2)
	syncprocess:PROCESS(clk_out1)
   begin
      --IF (clk_out2 = '1' AND clk_out2'event) THEN
		IF (clk_out1 = '1' AND clk_out1'event) THEN
         reset_l_temp <= reset_l ;
         reset_l_sync <= reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;

   eprom_ce_l <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   sram_ce_l  <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;

   eprom_oe_l <= '0' WHEN read = '1' ELSE '1' ;
   sram_oe_l  <= '0' WHEN read = '1' ELSE '1' ;

   sram_we_l  <= '0' WHEN write = '1' ELSE '1' ;

	usb_oe_h <= '1' WHEN (address = "11111111111111111111111111101001" AND read = '1') ELSE '0';
	usb_we_h <= '1' WHEN (address = "11111111111111111111111111101001" AND write = '1') ELSE '0';
	usb_txe_oe_l <= '0' WHEN(address = "11111111111111111111111111100111" AND read = '1') ELSE '1';
	usb_rxf_oe_l <= '0' WHEN(address = "11111111111111111111111111101000" AND read = '1') ELSE '1';

	io_ce_l <= '0' WHEN(address >= "11111111111111111111111111101010" AND (read = '1' OR write = '1')) ELSE '1';
	io_we_l <= '0' WHEN write = '1' ELSE '1';
	io_oe_l <= '0' WHEN read = '1' ELSE '1';

--   done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR vga_ena = '1') ELSE '0' ;
   done <= '1' WHEN 
		(eprom_ce_l = '0' 
			OR sram_ce_l = '0' 
			OR hdmi_ena = '1'
			OR usb_done = '1'
			OR usb_txe_oe_l = '0'
			OR usb_rxf_oe_l = '0'
			OR io_ce_l = '0') ELSE '0' ;
	
   rsrc1:rsrc      
   PORT MAP(--clk       => clk_out2,
				clk       => clk_out1,
            reset_l   => reset_l_sync,
            d         => d,
            address   => address,
            read      => read,
            write     => write,
            done      => done);

   erpom1:eprom    
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => eprom_ce_l,
               oe_l      => eprom_oe_l);
 
   sram1: sram
      PORT MAP(d         => d,
               address   => address(11 DOWNTO 2),
               ce_l      => sram_ce_l,
               oe_l      => sram_oe_l,
               we_l      => sram_we_l,
               --clk       => clk_out2);
					clk       => clk_out1);

   hdmi_ena <= '1' WHEN address(31 DOWNTO 14) = "000000000000000001" ELSE '0' ;
   hdmi_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;

--   vga1:vga
--   PORT MAP(clk       => clk_out,
--            ena       => vga_ena,
--            wea       => vga_wea,
--            addra     => address(13 DOWNTO 2),
--            dina      => d(7 DOWNTO 0),
--            r         => r,
--            g         => g,
--            b         => b,
--            hs        => hs,
--            vs        => vs);
	hdmi1:myhdmi
	PORT MAP(clka			=> clk_out1,
				clkb			=> clk_out3,
				ena			=> hdmi_ena,
				wea			=> hdmi_wea,
				addra			=> address(13 DOWNTO 2),
				dina 			=> d(7 DOWNTO 0),
				TMDSp 		=>	TMDSp,
				TMDSn 		=> TMDSn,
				TMDSp_clock => TMDSp_clock,
				TMDSn_clock	=> TMDSn_clock);

	io1:io
	PORT MAP(--clk	=> clk_out2,
				clk	=> clk_out1,
				d		=> d,
				addr	=> address(4 DOWNTO 0),
				ce_l	=> io_ce_l,
				we_l	=> io_we_l,
				oe_l	=> io_oe_l,
				pins	=> pins);

		usb1:usb
		PORT MAP(  d_bus		=> d(31 DOWNTO 0),
					  d_usb		=> usb_bus(7 DOWNTO 0),
					  --clk			=> clk_out2,
					  clk			=> clk_out1,
					  usb_rd_h	=> usb_oe_h,
					  usb_wr_h	=> usb_we_h,
					  txe_oe_l	=> usb_txe_oe_l,
					  rxf_oe_l	=> usb_rxf_oe_l,
					  txe_l		=> txe_l,
					  rxf_l		=> rxf_l,
					  rd_l		=> usb_rd,
					  wr_h		=> usb_wr,
					  usb_done	=> usb_done);

END structure;
