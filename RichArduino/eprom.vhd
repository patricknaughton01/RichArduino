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

---------------------IO TEST-------------------------
--	WITH address  SELECT
--   data <=
--     X"2f81ffff" WHEN "0000000000" , --- la r30, -1
--	  X"28400003" WHEN "0000000001" , --- la r1, 3
--	  X"28800016" WHEN "0000000010" , --- la r2, 22 
--	  X"28c00014" WHEN "0000000011" , --- la r3, LOOP
--	  X"29000024" WHEN "0000000100" , --- la r4, LOOP2
--	  X"187c0000" WHEN "0000000101" , --- st r1, 0(r30)
--	  X"6fbdffff" WHEN "0000000110" , --- addi r30, r30, -1
--	  X"6885ffff" WHEN "0000000111" , --- addi r2, r2, -1
--	  X"40062003" WHEN "0000001000" , --- brnz r3, r2
--	  X"6fbc0001" WHEN "0000001001" , --- addi r30, r30, 1
--	  X"097c0000" WHEN "0000001010" , --- ld r5, 0(r30)
--	  X"4009e005" WHEN "0000001011" , --- brmi r4, r30
--	  X"f8000000" WHEN "0000001100" , --- stop
--     X"00000000" WHEN OTHERS ;
------------- HDMI test program, clear screen --------------
--	WITH address  SELECT
--   data <=
--     X"28404000" WHEN "0000000000" , --- la r1, 16384
--	  X"28800fff" WHEN "0000000001" , --- la r2, 4095
--	  X"28c00000" WHEN "0000000010" , --- la r3, 0
--	  X"2f800010" WHEN "0000000011" , --- la r30, LOOP
--	  X"18c20000" WHEN "0000000100" , --- st r3, 0(r1)
--	  X"68420004" WHEN "0000000101" , --- addi r1, r1, 4
--	  X"6885ffff" WHEN "0000000110" , --- addi r2, r2, -1
--	  X"403c2004" WHEN "0000000111" , --- brpl r30, r2
--	  X"f8000000" WHEN "0000001000" , --- stop
--     X"00000000" WHEN OTHERS ;

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
