
--Choose A and B for make linear segmentation
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;



entity Approximation_Unit4 is
Generic(Data_Width: integer:=32);
    Port ( h  : in   SIGNED (Data_Width-1 downto 0);
			  A  : out  SIGNED (Data_Width-1 downto 0);
           B  : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit4;

  

architecture Behavioral of Approximation_Unit4 is
    constant z1 : SIGNED (Data_Width-1 downto 0):=X"00B33333";-- "000000000000000000000000000000000000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):=X"00BBBBBC";-- "000000010001101110100101111000110101001";
    constant z3 : SIGNED (Data_Width-1 downto 0):=X"00C44444";-- "000000100101001100100110000101111100000";
    constant z4 : SIGNED (Data_Width-1 downto 0):=X"00CCCCCD";-- "000000110100011100010000110010110010100";
    constant z5 : SIGNED (Data_Width-1 downto 0):=X"00D55555";-- "000001000110101001111110111110011101101";
    constant z6 : SIGNED (Data_Width-1 downto 0):=X"00DDDDDE";-- "000001011000110101001111110111110011101";
    constant z7 : SIGNED (Data_Width-1 downto 0):=X"00E66666";-- "000001101010011111101111100111011011001";

begin
 

--A       <= "000000000001001000111010001010011100011" when(h >= z1 and  h  < z2) else
--		     "000000010001011010000111001010110000001" when(h >= z2 and  h  < z3 )else
--           "000000101110111101101001010001000110011" when(h >= z3 and  h  < z4 )else
--           "000001010110101101010000101100001111001" when(h >= z4 and  h  < z5 )else
--           "000010010101111100111011011001000101101" when(h >= z5 and  h  < z6 )else
--           "000011100000101101000011100101011000000" when(h >= z6 and  h  < z7 )else
--           "000100110111011110011010011010110101000" when(h >= z7 )else
--		  	  (others => '0') ;
			  
--B       <= "000000000000000000000000000000000000000" when(h >= z1 and  h  < z2) else
--		     "111111111101101111110100100001111111110" when(h >= z2 and  h  < z3 )else
--           "111111110101001010001000110011100111000" when(h >= z3 and  h  < z4 )else
--           "111111100100111000000111010111110110111" when(h >= z4 and  h  < z5 )else
--           "111111000001111110111110011101101100100" when(h >= z5 and  h  < z6 )else
--           "111110001110000111100100111101110110010" when(h >= z6 and  h  < z7 )else
--           "111101000110001010000010010000001011011" when(h >= z7 )else
--		  	  (others => '0') ;

A       <= X"01888B8E" when(h >= z1 and  h  < z2) else
		   X"01B01FDD" when(h >= z2 and  h  < z3 )else
           X"01D82F91" when(h >= z3 and  h  < z4 )else
           X"01FEE4D4" when(h >= z4 and  h  < z5 )else
           X"022BBE67" when(h >= z5 and  h  < z6 )else
           X"0254A3CF" when(h >= z6 and  h  < z7 )else
           
		  	  (others => '0') ;
			  
B       <= X"FF44F8FE" when(h >= z1 and  h  < z2) else
		   X"FF27F2A2" when(h >= z2 and  h  < z3 )else
           X"FF093BED" when(h >= z3 and  h  < z4 )else
           X"FEEA4484" when(h >= z4 and  h  < z5 )else
           X"FEC4E489" when(h >= z5 and  h  < z6 )else
           X"FEA1730D" when(h >= z6 and  h  < z7 )else
          
		  	  (others => '0') ;
		  	  
end Behavioral;

