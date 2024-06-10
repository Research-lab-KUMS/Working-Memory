
--Choose A and B for make linear segmentation
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;



entity Approximation_Unit2 is
Generic(Data_Width: integer:=32);
    Port ( 
	        Ca2 : in   SIGNED (Data_Width-1 downto 0);
			  A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit2;

  

architecture Behavioral of Approximation_Unit2 is
    constant z1 : SIGNED (Data_Width-1 downto 0):=    X"00000000";-- "000000000000000000000000000000000000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):= X"002E147B";--   X"00058E22";-- "000000000010110001110001000011001011001";
    constant z3 : SIGNED (Data_Width-1 downto 0):= X"004D0E56";--   X"000C84B6";-- "000000000110010000100101101011101110011";
    constant z4 : SIGNED (Data_Width-1 downto 0):=X"00800000";--    X"002EC56D";-- "000000010111011000101011011010101110011";
    constant z5 : SIGNED (Data_Width-1 downto 0):= X"00AAACDA";--   X"00416F00";-- "000000100000101101111000000000110100011";
    constant z6 : SIGNED (Data_Width-1 downto 0):= X"00D55326";--   X"005A71DE";-- "000000101101001110001110111100110100110";
    constant z7 : SIGNED (Data_Width-1 downto 0):= X"01000000";--   X"007C9EED";-- "000000111110010011110111011001011111110";
--    constant z8 : SIGNED (Data_Width-1 downto 0):=    X"00AA786C";-- "000001010101001111000011011000010001001";
begin


----A       <= "000000010111000010100011110101110000101" when(Ca2>= z1 and  Ca2 < z2) else
----		   "000001101101001110001110111100110100110" when(Ca2>= z2 and  Ca2 < z3 )else
----           "000011011000001001110101001001010100011" when(Ca2>= z3 and  Ca2 < z4 )else
----           "000010101100110110011110100000111110010" when(Ca2>= z4 and  Ca2 < z5 )else
----           "000010000111001101001101011010100001011" when(Ca2>= z5 and  Ca2 < z6 )else
----           "000001011110101001111110111110011101101" when(Ca2>= z6 and  Ca2 < z7 )else
----           "000001000000101110101100011100010000110" when(Ca2>= z7 and  Ca2 < z8 )else
----           "000000100101101010111001111101010101100" when(Ca2>= z8)else
----		  	  (others => "0") ;
-- A       <=X"002E147B" when(Ca2>= z1 and  Ca2 < z2) else
--		       X"00DA71DE" when(Ca2>= z2 and  Ca2 < z3 )else
--               X"01B04EA5" when(Ca2>= z3 and  Ca2 < z4 )else
--               X"0159B3D0" when(Ca2>= z4 and  Ca2 < z5 )else
--               X"010E69AD" when(Ca2>= z5 and  Ca2 < z6 )else
--               X"00BD4FDF" when(Ca2>= z6 and  Ca2 < z7 )else
--               X"0081758E" when(Ca2>= z7 and  Ca2 < z8 )else
--               X"004B573F" when(Ca2>= z8)else
--		  	 (others => '0' ) ;
----B       <= "000000000000000000000000000000000000000" when(Ca2>= z1 and  Ca2 < z2) else
----		   "111111111110001011101011000111000100001" when(Ca2>= z2 and  Ca2 < z3 )else
----           "111111111000111100100111101110110010111" when(Ca2>= z3 and  Ca2 < z4 )else
----           "000000000000110000010101010011001001100" when(Ca2>= z4 and  Ca2 < z5 )else
----           "000000001010100001011000011110010011110" when(Ca2>= z5 and  Ca2 < z6 )else
----           "000000011000110000010101010011001001100" when(Ca2>= z6 and  Ca2 < z7 )else
----           "000000100111010100100101010001100000101" when(Ca2>= z7 and  Ca2 < z8 )else
----           "000000111001010110000001000001100010010" when(Ca2>= z8)else
----			  (others => "0") ;
--B       <= X"00000000" when(Ca2>= z1 and  Ca2 < z2) else
--		       X"FFFC5D64" when(Ca2>= z2 and  Ca2 < z3 )else
--               X"FFF1E4F7" when(Ca2>= z3 and  Ca2 < z4 )else
--               X"000182AA" when(Ca2>= z4 and  Ca2 < z5 )else
--               X"00150B0F" when(Ca2>= z5 and  Ca2 < z6 )else
--               X"003182AA" when(Ca2>= z6 and  Ca2 < z7 )else
--               X"004EA4A9" when(Ca2>= z7 and  Ca2 < z8 )else
--               X"0072B021" when(Ca2>= z8)else
--			  (others => '0') ;
			  
			  
			  
			  
--A       <= "000000010111000010100011110101110000101" when(Ca2>= z1 and  Ca2 < z2) else
--		   "000001101101001110001110111100110100110" when(Ca2>= z2 and  Ca2 < z3 )else
--           "000011011000001001110101001001010100011" when(Ca2>= z3 and  Ca2 < z4 )else
--           "000010101100110110011110100000111110010" when(Ca2>= z4 and  Ca2 < z5 )else
--           "000010000111001101001101011010100001011" when(Ca2>= z5 and  Ca2 < z6 )else
--           "000001011110101001111110111110011101101" when(Ca2>= z6 and  Ca2 < z7 )else
--           "000001000000101110101100011100010000110" when(Ca2>= z7 and  Ca2 < z8 )else
--           "000000100101101010111001111101010101100" when(Ca2>= z8)else
--		  	  (others => "0") ;
-- A           <=X"020505DA" when(Ca2>= z1 and  Ca2 < z2) else
--		       X"01600E89" when(Ca2>= z2 and  Ca2 < z3 )else
--               X"00BA9EEC" when(Ca2>= z3 and  Ca2 < z4 )else
--               X"00683E9E" when(Ca2>= z4 and  Ca2 < z5 )else
--               X"004A5E51" when(Ca2>= z5 and  Ca2 < z6 )else
--               X"0034AD48" when(Ca2>= z6 and  Ca2 < z7 )else
----               X"0081758E" when(Ca2>= z7 and  Ca2 < z8 )else
----               X"004B573F" when(Ca2>= z8)else
--		  	 (others => '0' ) ;
		   A <=    X"01FE5D2F" when(Ca2>= z1 and  Ca2 < z2) else
		           X"0162FE28" when(Ca2>= z2 and  Ca2 < z3 )else
                   X"00BA3611" when(Ca2>= z3 and  Ca2 < z4 )else
                   X"00687142" when(Ca2>= z4 and  Ca2 < z5 )else
                   X"004A4686" when(Ca2>= z5 and  Ca2 < z6 )else
                   X"0034D50E" when(Ca2>= z6 and  Ca2 < z7 )else
--               X"0081758E" when(Ca2>= z7 and  Ca2 < z8 )else
--               X"004B573F" when(Ca2>= z8)else
		  	 (others => '0' ) ;
		  	 
		  	 
--B       <= "000000000000000000000000000000000000000" when(Ca2>= z1 and  Ca2 < z2) else
--		   "111111111110001011101011000111000100001" when(Ca2>= z2 and  Ca2 < z3 )else
--           "111111111000111100100111101110110010111" when(Ca2>= z3 and  Ca2 < z4 )else
--           "000000000000110000010101010011001001100" when(Ca2>= z4 and  Ca2 < z5 )else
--           "000000001010100001011000011110010011110" when(Ca2>= z5 and  Ca2 < z6 )else
--           "000000011000110000010101010011001001100" when(Ca2>= z6 and  Ca2 < z7 )else
--           "000000100111010100100101010001100000101" when(Ca2>= z7 and  Ca2 < z8 )else
--           "000000111001010110000001000001100010010" when(Ca2>= z8)else
--			  (others => "0") ;
B       <= X"FFF7D31B" when(Ca2>= z1 and  Ca2 < z2) else
		   X"0013CA9C" when(Ca2>= z2 and  Ca2 < z3 )else
           X"0046983F" when(Ca2>= z3 and  Ca2 < z4 )else
           X"006F7AA7" when(Ca2>= z4 and  Ca2 < z5 )else
           X"00839765" when(Ca2>= z5 and  Ca2 < z6 )else
           X"009575C6" when(Ca2>= z6 and  Ca2 < z7 )else
--               X"004EA4A9" when(Ca2>= z7 and  Ca2 < z8 )else
--               X"0072B021" when(Ca2>= z8)else
			  (others => '0') ;


end Behavioral;

