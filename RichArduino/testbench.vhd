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
        reset_l   : IN  STD_LOGIC;
		  txe_l		: IN  STD_LOGIC;
		  rxf_l		: IN	STD_LOGIC;
        r         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        g         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        b         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
        hs        : OUT STD_LOGIC ;
        vs        : OUT STD_LOGIC ;
		  usb_bus	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) ;
		  usb_rd		: OUT	STD_LOGIC ;
		  usb_wr		: OUT STD_LOGIC);
END testbench ;

ARCHITECTURE structure OF testbench IS

   COMPONENT mydcm
   PORT (clk_out1 : OUT STD_LOGIC;
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
	PORT (  d_bus		:	INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
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

   SIGNAL reset_l_temp : STD_LOGIC ;
   SIGNAL reset_l_sync : STD_LOGIC ;
   SIGNAL clk_out      : STD_LOGIC ;
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
   SIGNAL vga_ena      : STD_LOGIC;
   SIGNAL vga_wea      : STD_LOGIC_VECTOR(0 DOWNTO 0) ;
	SIGNAL usb_done	  : STD_LOGIC ;
	SIGNAL usb_oe_h	  : STD_LOGIC ;
	SIGNAL usb_we_h	  : STD_LOGIC ;
	SIGNAL usb_txe_oe_l : STD_LOGIC ;
	SIGNAL usb_rxf_oe_l : STD_LOGIC ;

BEGIN

   mydcm1:mydcm
   PORT MAP(clk_out1 => clk_out ,
            clk_in1  => clk) ;

   syncprocess:PROCESS(clk_out)
   begin
      IF (clk_out = '1' AND clk_out'event) THEN
         reset_l_temp <= reset_l ;
         reset_l_sync <= reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;

   eprom_ce_l <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   sram_ce_l  <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;

   eprom_oe_l <= '0' WHEN read = '1' ELSE '1' ;
   sram_oe_l  <= '0' WHEN read = '1' ELSE '1' ;

   sram_we_l  <= '0' WHEN write = '1' ELSE '1' ;

--   done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR vga_ena = '1') ELSE '0' ;
   done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR usb_done = '1') ELSE '0' ;
	
   rsrc1:rsrc      
   PORT MAP(clk       => clk_out,
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
               clk       => clk_out);

--   vga_ena <= '1' WHEN address(31 DOWNTO 14) = "000000000000000001" ELSE '0' ;
--   vga_wea <= CONV_STD_LOGIC_VECTOR(write,1) ;

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
		usb1:usb
		PORT MAP(  d_bus		=> d(7 DOWNTO 0),
					  d_usb		=> usb_bus,
					  clk			=> clk_out,
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
