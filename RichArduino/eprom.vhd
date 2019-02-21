LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;
ENTITY eprom IS
   PORT (d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
         ce_l     : IN  STD_LOGIC ;
         oe_l     : IN  STD_LOGIC) ;
END eprom ;

ARCHITECTURE behavioral OF eprom IS

   SIGNAL data    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

------------- USB test program --------------
   WITH address  SELECT
   data <=
	  X"2f81ffff" WHEN "0000000000", --- la r30, -1
     X"2880000a" WHEN "0000000001", --- la r2, 10
	  X"087dffea" WHEN "0000000010", --- ld r1, -22(r30) Read USB
	  X"18bdffea" WHEN "0000000011", --- st r2, -22(r30) Write r2
	  X"08fdffe9" WHEN "0000000100", --- ld r3, -23(r30) Poll RXF
	  X"093dffe8" WHEN "0000000101", --- ld r4, -24(r30) Poll TXE
	  X"f8000000" WHEN "0000000110", --- stop
     X"00000000" WHEN OTHERS ;

------------ Stop program --------------
--   WITH address  SELECT
--   data <=
--     X"f8000000" WHEN "0000000000" , --- stop
--     X"00000000" WHEN OTHERS ;

   readprocess:PROCESS(ce_l,oe_l,data)
   begin
      IF (ce_l = '0' AND oe_l = '0') THEN
         d(31 DOWNTO 0) <= data ;
      else
	 d(31 DOWNTO 0) <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ; 

END behavioral ;
