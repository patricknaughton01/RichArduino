----------------------------------------------------------------------------------
-- Company: CSE 462 Blue Team
-- Engineer: Patrick Naughton
-- 
-- Create Date:    10:30:43 02/22/2019 
-- Design Name: RichArduino
-- Module Name:    io - Behavioral 
-- Project Name: RichArduino
-- Target Devices: Spartan 6
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity io is
	PORT(	clk	: IN		STD_LOGIC ;
			d		: INOUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr	: IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
			ce_l	: IN		STD_LOGIC;
			we_l	: IN		STD_LOGIC;
			oe_l	: IN		STD_LOGIC;
			pins	: INOUT	STD_LOGIC_VECTOR(21 DOWNTO 0));
end io;

architecture Behavioral of io is
	
	SIGNAL pins_tmp	: STD_LOGIC_VECTOR(21 DOWNTO 0);
	SIGNAL pins_sync	: STD_LOGIC_VECTOR(21 DOWNTO 0);
	SIGNAL reg0    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg1    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg2    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg3    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg4    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg5    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg6    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg7    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg8    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg9    : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg10   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg11   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg12   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg13   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg14   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg15   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg16   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg17   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg18   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg19   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg20   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
   SIGNAL reg21   : STD_LOGIC_VECTOR(1 DOWNTO 0) ;

begin

	sync:PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk='1')THEN
			pins_tmp <= pins;
			pins_sync <= pins_tmp;
		END IF;
	END PROCESS sync;
	
	read_pin:PROCESS(clk)
	BEGIN
		IF(clk='1' AND clk'EVENT)THEN
			IF(ce_l = '0' AND oe_l = '0')THEN
				CASE(addr) IS
					WHEN("01010") => d <= reg0(1)	& pins_sync(0);
					WHEN("01011") => d <= reg1(1)	& pins_sync(0);
					WHEN("01100") => d <= reg2(1)	& pins_sync(0);
					WHEN("01101") => d <= reg3(1)	& pins_sync(0);
					WHEN("01110") => d <= reg4(1)	& pins_sync(0);
					WHEN("01111") => d <= reg5(1)	& pins_sync(0);
					WHEN("10000") => d <= reg6(1)	& pins_sync(0);
					WHEN("10001") => d <= reg7(1)	& pins_sync(0);
					WHEN("10010") => d <= reg8(1)	& pins_sync(0);
					WHEN("10011") => d <= reg9(1)	& pins_sync(0);
					WHEN("10100") => d <= reg10(1)& pins_sync(0);
					WHEN("10101") => d <= reg11(1)& pins_sync(0);
					WHEN("10110") => d <= reg12(1)& pins_sync(0);
					WHEN("10111") => d <= reg13(1)& pins_sync(0);
					WHEN("11000") => d <= reg14(1)& pins_sync(0);
					WHEN("11001") => d <= reg15(1)& pins_sync(0);
					WHEN("11010") => d <= reg16(1)& pins_sync(0);
					WHEN("11011") => d <= reg17(1)& pins_sync(0);
					WHEN("11100") => d <= reg18(1)& pins_sync(0);
					WHEN("11101") => d <= reg19(1)& pins_sync(0);
					WHEN("11110") => d <= reg20(1)& pins_sync(0);
					WHEN("11111") => d <= reg21(1)& pins_sync(0);
				END CASE;
			ELSE
				d <= (OTHERS => 'Z');
			END IF;
		END IF;
	END PROCESS read_pin;

end Behavioral;

