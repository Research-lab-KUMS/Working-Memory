

--Choose A and B for make linear segmentation
--(Ca2(i) + d1) /(Ca2(i) + d3)
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;

entity Approximation_Unit6 is
Generic(Data_Width: integer:=32);
	 Port ( Ca2 : in   SIGNED (Data_Width-1 downto 0);
           A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit6;

architecture Behavioral of Approximation_Unit6 is

	 constant z1 : SIGNED (Data_Width-1 downto 0):=    X"00000000";-- "000000000000000000000000000000000000000";
        constant z2 : SIGNED (Data_Width-1 downto 0):= X"002AAAAB";--   X"00058E22";-- "000000000010110001110001000011001011001";
        constant z3 : SIGNED (Data_Width-1 downto 0):= X"00555555";--   X"000C84B6";-- "000000000110010000100101101011101110011";
        constant z4 : SIGNED (Data_Width-1 downto 0):= X"00800000";--    X"002EC56D";-- "000000010111011000101011011010101110011";
        constant z5 : SIGNED (Data_Width-1 downto 0):= X"00AAAAAB";--   X"00416F00";-- "000000100000101101111000000000110100011";
        constant z6 : SIGNED (Data_Width-1 downto 0):= X"00D55555";--   X"005A71DE";-- "000000101101001110001110111100110100110";
        constant z7 : SIGNED (Data_Width-1 downto 0):= X"01000000";--   X"007C9EED";-- "000000111110010011110111011001011111110";
begin
 



  A <=           X"00305E09" when(Ca2>= z1 and  Ca2 < z2) else
                 X"0024D9D4" when(Ca2>= z2 and  Ca2 < z3 )else
                 X"001D4F56" when(Ca2>= z3 and  Ca2 < z4 )else
                 X"0017CB6F" when(Ca2>= z4 and  Ca2 < z5 )else
                 X"0013B20D" when(Ca2>= z5 and  Ca2 < z6 )else
                 X"0010A1AD" when(Ca2>= z6 and  Ca2 < z7 )else
--               X"0081758E" when(Ca2>= z7 and  Ca2 < z8 )else
--               X"004B573F" when(Ca2>= z8)else
             (others => '0' ) ;
             
 B <=                         X"000F8C52" when(Ca2>= z1 and  Ca2 < z2) else
                              X"001177B0" when(Ca2>= z2 and  Ca2 < z3 )else
                              X"0013FB30" when(Ca2>= z3 and  Ca2 < z4 )else
                              X"0016BD23" when(Ca2>= z4 and  Ca2 < z5 )else
                              X"001978B9" when(Ca2>= z5 and  Ca2 < z6 )else
                              X"001C065F" when(Ca2>= z6 and  Ca2 < z7 )else
           --               X"0081758E" when(Ca2>= z7 and  Ca2 < z8 )else
           --               X"004B573F" when(Ca2>= z8)else
                          (others => '0' ) ;

end Behavioral;


