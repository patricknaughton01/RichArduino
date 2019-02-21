----------------------------------------------------------------------------------
-- Company: CSE 462
-- Engineer: Patrick Naughton
-- 
-- Create Date:    18:36:49 02/19/2019 
-- Design Name: 
-- Module Name:    usb - Behavioral 
-- Project Name: RichArduino
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity usb is
    Port ( d_bus		:	INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
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
end usb;

architecture Behavioral of usb is

	SIGNAL rd_count		:	STD_LOGIC_VECTOR(2 DOWNTO 0)	:= (OTHERS => '0');
	SIGNAL wr_count		:	STD_LOGIC_VECTOR(2 DOWNTO 0)	:= (OTHERS => '0');
	SIGNAL txe_l_tmp		:	STD_LOGIC;
	SIGNAL txe_l_sync		:	STD_LOGIC;
	SIGNAL rxf_l_tmp		:	STD_LOGIC;
	SIGNAL rxf_l_sync		:	STD_LOGIC;
	SIGNAL rd_done			:	STD_LOGIC;
	SIGNAL wr_done			:	STD_LOGIC;
	

begin

	sync:PROCESS(clk)
	BEGIN
		IF(clk='1' AND clk'EVENT)THEN
			txe_l_tmp <= txe_l;
			txe_l_sync <= txe_l_tmp;
			rxf_l_tmp <= rxf_l;
			rxf_l_sync <= rxf_l_tmp;
		END IF;
	END PROCESS sync;
	
	poll_txe:PROCESS(clk)
	BEGIN
		IF(txe_oe_l = '0')THEN
			d_bus <= "0000000" & txe_l_sync;
		ELSE
			d_bus <= (OTHERS => 'Z');
		END IF;
	END PROCESS poll_txe;
	
	poll_rxf:PROCESS(clk)
	BEGIN
		IF(rxf_oe_l = '0')THEN
			d_bus <= "0000000" & rxf_l_sync;
		ELSE
			d_bus <= (OTHERS => 'Z');
		END IF;
	END PROCESS poll_rxf;
	
	-- Assert rd_l for two clock ticks before we read in the data.
	read_usb:PROCESS(clk)
	BEGIN
		IF(clk='1' AND clk'EVENT)THEN
			IF(usb_rd_h='1')THEN
				IF(rd_count > 3)THEN
					rd_count <= "000";
					rd_l <= '1';
					rd_done <= '1';
					d_bus <= d_usb;
				ELSE
					rd_count <= rd_count + '1';
					d_bus <= (OTHERS => 'Z');
					IF(rd_count > 0)THEN
						rd_l <= '0';
					ELSE
						rd_l <= '1';
					END IF;
				END IF;
			ELSE
				rd_l <= '1';
				d_bus <= (OTHERS => 'Z');
				rd_count <= "000";
			END IF;
			IF(rd_done='1')THEN
				rd_done <= '0';
			END IF;
		END IF;
	END PROCESS read_usb;
	
	-- Assert wr_h for one clock tick before we write data
	-- and hold for at least 50ns (3 clock ticks total).
	-- Assumes a 50 MHz clock
	write_usb:PROCESS(clk)
	BEGIN
		IF(clk='1' AND clk'EVENT)THEN
			IF(usb_wr_h='1')THEN
				IF(wr_count > 3)THEN
					wr_count <= "000";
					wr_h <= '0';
					d_usb <= (OTHERS => 'Z');
					wr_done <= '1';
				ELSIF(wr_count > 1)THEN
					wr_count <= wr_count + 1;
					wr_h <= '1';
					d_usb <= d_bus;
				ELSIF(wr_count > 0)THEN
					wr_count <= wr_count + 1;
					wr_h <= '1';
					d_usb <= (OTHERS => 'Z');
				ELSE
					wr_count <= wr_count + 1;
					wr_h <= '0';
					d_usb <= (OTHERS => 'Z');
				END IF;
			ELSE
				wr_count <= "000";
				wr_h <= '0';
				d_usb <= (OTHERS => 'Z');
			END IF;
			IF(wr_done='1')THEN
				wr_done <= '0';
			END IF;
		END IF;
	END PROCESS write_usb;

	done_output:PROCESS(rd_done, wr_done)
	BEGIN
		usb_done <= rd_done OR wr_done;
	END PROCESS done_output;

end Behavioral;

