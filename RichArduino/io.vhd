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
			d		: INOUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
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
	
--	read_pin:PROCESS(ce_l, oe_l, addr, reg0, 
--							reg1, reg2, reg3, reg4, 
--							reg5, reg6, reg7, reg8, 
--							reg9, reg10, reg11, reg12, 
--							reg13, reg14, reg15, reg16, 
--							reg17, reg18, reg19, reg20, 
--							reg21, pins_sync)
	read_pin:PROCESS(ce_l, oe_l, addr)
	BEGIN
		IF(ce_l = '0' AND oe_l = '0')THEN
			CASE(addr) IS
				WHEN("01010") => d <= "000000000000000000000000000000" & reg0(1)	& pins_sync(0);
				WHEN("01011") => d <= "000000000000000000000000000000" & reg1(1)	& pins_sync(1);
				WHEN("01100") => d <= "000000000000000000000000000000" & reg2(1)	& pins_sync(2);
				WHEN("01101") => d <= "000000000000000000000000000000" & reg3(1)	& pins_sync(3);
				WHEN("01110") => d <= "000000000000000000000000000000" & reg4(1)	& pins_sync(4);
				WHEN("01111") => d <= "000000000000000000000000000000" & reg5(1)	& pins_sync(5);
				WHEN("10000") => d <= "000000000000000000000000000000" & reg6(1)	& pins_sync(6);
				WHEN("10001") => d <= "000000000000000000000000000000" & reg7(1)	& pins_sync(7);
				WHEN("10010") => d <= "000000000000000000000000000000" & reg8(1)	& pins_sync(8);
				WHEN("10011") => d <= "000000000000000000000000000000" & reg9(1)	& pins_sync(9);
				WHEN("10100") => d <= "000000000000000000000000000000" & reg10(1)& pins_sync(10);
				WHEN("10101") => d <= "000000000000000000000000000000" & reg11(1)& pins_sync(11);
				WHEN("10110") => d <= "000000000000000000000000000000" & reg12(1)& pins_sync(12);
				WHEN("10111") => d <= "000000000000000000000000000000" & reg13(1)& pins_sync(13);
				WHEN("11000") => d <= "000000000000000000000000000000" & reg14(1)& pins_sync(14);
				WHEN("11001") => d <= "000000000000000000000000000000" & reg15(1)& pins_sync(15);
				WHEN("11010") => d <= "000000000000000000000000000000" & reg16(1)& pins_sync(16);
				WHEN("11011") => d <= "000000000000000000000000000000" & reg17(1)& pins_sync(17);
				WHEN("11100") => d <= "000000000000000000000000000000" & reg18(1)& pins_sync(18);
				WHEN("11101") => d <= "000000000000000000000000000000" & reg19(1)& pins_sync(19);
				WHEN("11110") => d <= "000000000000000000000000000000" & reg20(1)& pins_sync(20);
				WHEN OTHERS   => d <= "000000000000000000000000000000" & reg21(1)& pins_sync(21);
			END CASE;
		ELSE
			d <= (OTHERS => 'Z');
		END IF;
	END PROCESS read_pin;
	
	write_pin:PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk='1')THEN
			IF(ce_l = '0' AND we_l = '0')THEN
				CASE(addr) IS
					WHEN("01010") => reg0 	<= d(1 DOWNTO 0);
					WHEN("01011") => reg1 	<= d(1 DOWNTO 0);
					WHEN("01100") => reg2 	<= d(1 DOWNTO 0);
					WHEN("01101") => reg3 	<= d(1 DOWNTO 0);
					WHEN("01110") => reg4 	<= d(1 DOWNTO 0);
					WHEN("01111") => reg5 	<= d(1 DOWNTO 0);
					WHEN("10000") => reg6 	<= d(1 DOWNTO 0);
					WHEN("10001") => reg7 	<= d(1 DOWNTO 0);
					WHEN("10010") => reg8 	<= d(1 DOWNTO 0);
					WHEN("10011") => reg9 	<= d(1 DOWNTO 0);
					WHEN("10100") => reg10 	<= d(1 DOWNTO 0);
					WHEN("10101") => reg11 	<= d(1 DOWNTO 0);
					WHEN("10110") => reg12 	<= d(1 DOWNTO 0);
					WHEN("10111") => reg13 	<= d(1 DOWNTO 0);
					WHEN("11000") => reg14 	<= d(1 DOWNTO 0);
					WHEN("11001") => reg15 	<= d(1 DOWNTO 0);
					WHEN("11010") => reg16 	<= d(1 DOWNTO 0);
					WHEN("11011") => reg17 	<= d(1 DOWNTO 0);
					WHEN("11100") => reg18 	<= d(1 DOWNTO 0);
					WHEN("11101") => reg19 	<= d(1 DOWNTO 0);
					WHEN("11110") => reg20 	<= d(1 DOWNTO 0);
					WHEN OTHERS   => reg21 	<= d(1 DOWNTO 0);
				END CASE;
			END IF;
		END IF;
	END PROCESS write_pin;
	
	pins(0) <= reg0(0) WHEN (reg0(1) = '1') ELSE 'Z';
	pins(1) <= reg1(0) WHEN (reg1(1) = '1') ELSE 'Z';
	pins(2) <= reg2(0) WHEN (reg2(1) = '1') ELSE 'Z';
	pins(3) <= reg3(0) WHEN (reg3(1) = '1') ELSE 'Z';
	pins(4) <= reg4(0) WHEN (reg4(1) = '1') ELSE 'Z';
	pins(5) <= reg5(0) WHEN (reg5(1) = '1') ELSE 'Z';
	pins(6) <= reg6(0) WHEN (reg6(1) = '1') ELSE 'Z';
	pins(7) <= reg7(0) WHEN (reg7(1) = '1') ELSE 'Z';
	pins(8) <= reg8(0) WHEN (reg8(1) = '1') ELSE 'Z';
	pins(9) <= reg9(0) WHEN (reg9(1) = '1') ELSE 'Z';
	pins(10) <= reg10(0) WHEN (reg10(1) = '1') ELSE 'Z';
	pins(11) <= reg11(0) WHEN (reg11(1) = '1') ELSE 'Z';
	pins(12) <= reg12(0) WHEN (reg12(1) = '1') ELSE 'Z';
	pins(13) <= reg13(0) WHEN (reg13(1) = '1') ELSE 'Z';
	pins(14) <= reg14(0) WHEN (reg14(1) = '1') ELSE 'Z';
	pins(15) <= reg15(0) WHEN (reg15(1) = '1') ELSE 'Z';
	pins(16) <= reg16(0) WHEN (reg16(1) = '1') ELSE 'Z';
	pins(17) <= reg17(0) WHEN (reg17(1) = '1') ELSE 'Z';
	pins(18) <= reg18(0) WHEN (reg18(1) = '1') ELSE 'Z';
	pins(19) <= reg19(0) WHEN (reg19(1) = '1') ELSE 'Z';
	pins(20) <= reg20(0) WHEN (reg20(1) = '1') ELSE 'Z';
	pins(21) <= reg21(0) WHEN (reg21(1) = '1') ELSE 'Z';

end Behavioral;

