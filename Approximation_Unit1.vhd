
--Choose A and B for make linear segmentation
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;



entity Approximation_Unit1 is
Generic(Data_Width: integer:=32);
    Port ( 
	        IP3 : in   SIGNED (Data_Width-1 downto 0);
			  A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit1;

  

architecture Behavioral of Approximation_Unit1 is
    constant z1 : SIGNED (Data_Width-1 downto 0):= X"00000000";--"000000000000000000000000000000000000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):=X"00666666";--"000000000011111001000010010110101110111";
    constant z3 : SIGNED (Data_Width-1 downto 0):=X"00D9999A";-- "000000000111101001111000011011000010001";
    constant z4 : SIGNED (Data_Width-1 downto 0):=X"01666666";--"000000100001010001111010111000010100011";
    constant z5 : SIGNED (Data_Width-1 downto 0):=X"02000000";-- "000000101010111110110111111010010000111";
    constant z6 : SIGNED (Data_Width-1 downto 0):= X"03000000";-- "000000111001010001000110011100111000000";
    constant z7 : SIGNED (Data_Width-1 downto 0):= X"06000000";-- "000001010000000011010001101101110001011";
begin


--A       <= "000000010111000010100011110101110000101" when(IP3>= z1 and  IP3 < z2) else
--		     "000001101010100111000111011110011010011" when(IP3>= z2 and  IP3 < z3 )else
--           "000010101010111011000110101111001110100" when(IP3>= z3 and  IP3 < z4 )else
--           "000010000011101010010010101000110000010" when(IP3>= z4 and  IP3 < z5 )else
--           "000001100110000101000111101011100001010" when(IP3>= z5 and  IP3 < z6 )else
--           "000001001110001111110001010000010010000" when(IP3>= z6 and  IP3 < z7 )else
--           "000000101011100010111010110001110001000" when(IP3>= z7)else
--		  	  (others => '0') ;
			  
--B       <= "000000000000000000000000000000000000000" when(IP3>= z1 and  IP3 < z2) else
--		     "111111111101011101110011000110001111110" when(IP3>= z2 and  IP3 < z3 )else
--           "111111111001011111000001101111011010010" when(IP3>= z3 and  IP3 < z4 )else
--           "000000000011110100111100001101100001000" when(IP3>= z4 and  IP3 < z5 )else
--           "000000001101110000101000111101011100001" when(IP3>= z5 and  IP3 < z6 )else
--           "000000011000011011000010001001101000000" when(IP3>= z6 and  IP3 < z7 )else
--           "000000101110000111100100111101110110010" when(IP3>= z7)else
--		  	  (others => '0') ;
		  	  
A       <= X"01244EA5" when(IP3>= z1 and  IP3 < z2) else
		   X"007D6CA1" when(IP3>= z2 and  IP3 < z3 )else
           X"00302F87" when(IP3>= z3 and  IP3 < z4 )else
           X"0019C2B7" when(IP3>= z4 and  IP3 < z5 )else
           X"000E7120" when(IP3>= z5 and  IP3 < z6 )else
           X"0004E049" when(IP3>= z6 and  IP3 < z7 )else
          
		  	  (others => '0') ;
			  
B       <= X"FFFD2C39" when(IP3>= z1 and  IP3 < z2) else
		   X"003FED07" when(IP3>= z2 and  IP3 < z3 )else
           X"00819429" when(IP3>= z3 and  IP3 < z4 )else
           X"00A0F94C" when(IP3>= z4 and  IP3 < z5 )else
           X"00B79C7A" when(IP3>= z5 and  IP3 < z6 )else
           X"00D44F00" when(IP3>= z6 and  IP3 < z7 )else
          
		  	  (others => '0') ;


end Behavioral;

