LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga IS
   PORT (clk       : IN  STD_LOGIC ;
         ena       : IN  STD_LOGIC ;
         wea       : IN  STD_LOGIC_VECTOR(0 DOWNTO 0) ;
         addra     : IN  STD_LOGIC_VECTOR(11 DOWNTO 0) ;
         dina      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0) ;
         r         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
         g         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
         b         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) ;
         hs        : OUT STD_LOGIC ;
         vs        : OUT STD_LOGIC);
END vga ;

ARCHITECTURE mine OF vga IS

BEGIN


END mine ;
