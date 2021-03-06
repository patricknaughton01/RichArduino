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
	SIGNAL sel     : STD_LOGIC_VECTOR(31 DOWNTO 0) ;


BEGIN

--------------------USB WRITE !--------------------------
--	sel <= "00000000000000000000" & address & "00" ;
--
--   WITH sel  SELECT
--   data <=
--      X"2fc1ffe7" WHEN X"00000000" , 
--      X"2f81ffe9" WHEN X"00000004" , 
--      X"2f400010" WHEN X"00000008" , 
--      X"2f000021" WHEN X"0000000c" , 
--      X"083e0000" WHEN X"00000010" , 
--      X"403a0003" WHEN X"00000014" , 
--      X"1f3c0000" WHEN X"00000018" , 
--      X"403a0001" WHEN X"0000001c" , 
--      X"00000000" WHEN OTHERS ;

---------------------USB Write Pin High-------------------------
--	sel <= "00000000000000000000" & address & "00" ;
--
--   WITH sel  SELECT
--   data <=
--      X"2fc1ffe8" WHEN X"00000000" , 
--      X"2f81ffe9" WHEN X"00000004" , 
--      X"2f41ffea" WHEN X"00000008" , 
--      X"2f00001c" WHEN X"0000000c" , 
--      X"28800003" WHEN X"00000010" , 
--      X"28c00000" WHEN X"00000014" , 
--      X"18fa0000" WHEN X"00000018" , 
--      X"083e0000" WHEN X"0000001c" , 
--      X"40380003" WHEN X"00000020" , 
--      X"087c0000" WHEN X"00000024" , 
--      X"18ba0000" WHEN X"00000028" , 
--      X"00000000" WHEN OTHERS ;

---------------------USB ECHO-------------------------
--	WITH address  SELECT
--   data <=
--     X"2fc1ffff" WHEN "0000000000" , --- la r31, -1
--	  X"2f80000c" WHEN "0000000001" , --- la r30, CHECK_READ
--	  X"2f400018" WHEN "0000000010" , --- la r29, CHECK_WRITE 
--	  X"087fffe9" WHEN "0000000011" , --- CHECK_READ:   ld r1, -23(r31)
--	  X"403c1003" WHEN "0000000100" , --- brnz r30, r1
--	  X"087fffea" WHEN "0000000101" , --- ld r1, -22(r31)
--	  X"08bfffe8" WHEN "0000000110" , --- CHECK_WRITE:  ld r2, -24(r31)
--	  X"403a2003" WHEN "0000000111" , --- brnz r29, r2
--	  X"187fffea" WHEN "0000001000" , --- st r1, -22(r31)
--	  X"403c0001" WHEN "0000001001" , --- br r30
--     X"00000000" WHEN OTHERS ;

-----------Monitor program test---------
sel <= "00000000000000000000" & address & "00" ;

   WITH sel  SELECT
   data <=
      X"2fc1ffe9" WHEN X"00000000" , 
      X"2f81ffe8" WHEN X"00000004" , 
      X"2f400050" WHEN X"00000008" , 
      X"2bc00000" WHEN X"0000000c" , 
      X"2f00001c" WHEN X"00000010" , 
      X"2ec00034" WHEN X"00000014" , 
      X"28401000" WHEN X"00000018" , 
      X"08bc0000" WHEN X"0000001c" , 
      X"40382003" WHEN X"00000020" , 
      X"08fe0000" WHEN X"00000024" , 
      X"63de3000" WHEN X"00000028" , 
      X"70c7d000" WHEN X"0000002c" , 
      X"40383003" WHEN X"00000030" , 
      X"08bc0000" WHEN X"00000034" , 
      X"40362003" WHEN X"00000038" , 
      X"08fe0000" WHEN X"0000003c" , 
      X"63de3000" WHEN X"00000040" , 
      X"2ec00048" WHEN X"00000044" , 
      X"08bc0000" WHEN X"00000048" , 
      X"40362003" WHEN X"0000004c" , 
      X"093e0000" WHEN X"00000050" , 
      X"63de4000" WHEN X"00000054" , 
      X"2ec0005c" WHEN X"00000058" , 
      X"08bc0000" WHEN X"0000005c" , 
      X"40362003" WHEN X"00000060" , 
      X"097e0000" WHEN X"00000064" , 
      X"63de5000" WHEN X"00000068" , 
      X"2ec00070" WHEN X"0000006c" , 
      X"08bc0000" WHEN X"00000070" , 
      X"40362003" WHEN X"00000074" , 
      X"09be0000" WHEN X"00000078" , 
      X"63de6000" WHEN X"0000007c" , 
      X"e1080008" WHEN X"00000080" , 
      X"e14a0010" WHEN X"00000084" , 
      X"e18c0018" WHEN X"00000088" , 
      X"b14a6000" WHEN X"0000008c" , 
      X"b1085000" WHEN X"00000090" , 
      X"b0c64000" WHEN X"00000094" , 
      X"6a860000" WHEN X"00000098" , 
      X"2ec000a0" WHEN X"0000009c" , 
      X"08bc0000" WHEN X"000000a0" , 
      X"40362003" WHEN X"000000a4" , 
      X"08fe0000" WHEN X"000000a8" , 
      X"63de3000" WHEN X"000000ac" , 
      X"2ec000b4" WHEN X"000000b0" , 
      X"08bc0000" WHEN X"000000b4" , 
      X"40362003" WHEN X"000000b8" , 
      X"093e0000" WHEN X"000000bc" , 
      X"63de4000" WHEN X"000000c0" , 
      X"2ec000c8" WHEN X"000000c4" , 
      X"08bc0000" WHEN X"000000c8" , 
      X"40362003" WHEN X"000000cc" , 
      X"097e0000" WHEN X"000000d0" , 
      X"63de5000" WHEN X"000000d4" , 
      X"2ec000dc" WHEN X"000000d8" , 
      X"08bc0000" WHEN X"000000dc" , 
      X"40362003" WHEN X"000000e0" , 
      X"09be0000" WHEN X"000000e4" , 
      X"63de6000" WHEN X"000000e8" , 
      X"e1080008" WHEN X"000000ec" , 
      X"e14a0010" WHEN X"000000f0" , 
      X"e18c0018" WHEN X"000000f4" , 
      X"b14a6000" WHEN X"000000f8" , 
      X"b1085000" WHEN X"000000fc" , 
      X"b0c64000" WHEN X"00000100" , 
      X"18c20000" WHEN X"00000104" , 
      X"68420004" WHEN X"00000108" , 
      X"2ec000a0" WHEN X"0000010c" , 
      X"6a95ffff" WHEN X"00000110" , 
      X"4036a003" WHEN X"00000114" , 
      X"28401000" WHEN X"00000118" , 
      X"2f400128" WHEN X"0000011c" , 
      X"2ec00041" WHEN X"00000120" , 
      X"2f81ffe7" WHEN X"00000124" , 
      X"0f3c0000" WHEN X"00000128" , 
      X"403bc003" WHEN X"0000012c" , 
      X"1bfe0000" WHEN X"00000130" , 
      X"40020001" WHEN X"00000134" , 
      X"00000000" WHEN OTHERS ;

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

----------- USB test program --------------
--   WITH address  SELECT
--   data <=
--	  X"2f81ffff" WHEN "0000000000", --- la r30, -1
--     X"2880000a" WHEN "0000000001", --- la r2, 10
--	  X"087dffea" WHEN "0000000010", --- ld r1, -22(r30) Read USB
--	  X"18bdffea" WHEN "0000000011", --- st r2, -22(r30) Write r2
--	  X"08fdffe9" WHEN "0000000100", --- ld r3, -23(r30) Poll RXF
--	  X"093dffe8" WHEN "0000000101", --- ld r4, -24(r30) Poll TXE
--	  X"f8000000" WHEN "0000000110", --- stop
--     X"00000000" WHEN OTHERS ;

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
