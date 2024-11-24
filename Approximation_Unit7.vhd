

--Choose A and B for make linear segmentation
--(IP3(i) + d1) /(IP3(i) + d3)
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;

entity Approximation_Unit7 is
Generic(Data_Width: integer:=32);
	 Port ( IP3 : in   SIGNED (Data_Width-1 downto 0);
           A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit7;

architecture Behavioral of Approximation_Unit7 is

	constant z1 : SIGNED (Data_Width-1 downto 0):=X"00000000";-- "000000000000000000000000000000000000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):=X"01000000";-- "000000000001011110101100110001001110111";
    constant z3 : SIGNED (Data_Width-1 downto 0):=X"01800000";-- "000000000011100011111110111011110101111";
    constant z4 : SIGNED (Data_Width-1 downto 0):=X"02000000";-- "000000001100010101001101111001111110101";
    constant z5 : SIGNED (Data_Width-1 downto 0):=X"03000000";-- "000000010010101100000010000011000100100";
    constant z6 : SIGNED (Data_Width-1 downto 0):=X"04000000";-- "000000011010000011111001000010010110101";
    constant z7 : SIGNED (Data_Width-1 downto 0):=X"06000000";-- "000000100110100101111000110101001111110";
   
   
   

begin
 



A       <= X"001C1263" when(IP3>= z1 and  IP3 < z2) else
		   X"001543E1" when(IP3>= z2 and  IP3 < z3 )else
           X"000ACC19" when(IP3>= z3 and  IP3 < z4 )else
           X"0005043B" when(IP3>= z4 and  IP3 < z5 )else
           X"0001F557" when(IP3>= z5 and  IP3 < z6 )else
           X"0000D63A" when(IP3>= z6 and  IP3 < z7 )else
          
		  	  (others => '0') ;
			  
			  
 B                      <= X"FFFD3C05" when(IP3>= z1 and  IP3 < z2) else
                           X"00040A87" when(IP3>= z2 and  IP3 < z3 )else
                           X"0013BE33" when(IP3>= z3 and  IP3 < z4 )else
                           X"001F4DEF" when(IP3>= z4 and  IP3 < z5 )else
                           X"00287A9A" when(IP3>= z5 and  IP3 < z6 )else
                           X"002CF70E" when(IP3>= z6 and  IP3 < z7 )else
                           
                                (others => '0') ;



-- constant z1 : SIGNED (Data_Width-1 downto 0):=X"00000000";--"000000000000000000000000000000000000000";
--    constant z2 : SIGNED (Data_Width-1 downto 0):= X"003779A7";--"000000001011101001011110001101010011111";
--    constant z3 : SIGNED (Data_Width-1 downto 0):= X"006EECC0";--"000000011010111000010100011110101110000";
--    constant z4 : SIGNED (Data_Width-1 downto 0):= X"00DDE00D";-- "000000110011001100110011001100110011001";
--    constant z5 : SIGNED (Data_Width-1 downto 0):= X"014CCCCD";-- "000001010011110101110000101000111101011";
   

--begin
 



--A       <= X"000ACC85" when(IP3>= z1 and  IP3 < z2) else
--		     X"001C0178" when(IP3>= z2 and  IP3 < z3 )else
--           X"0020D1E1" when(IP3>= z3 and  IP3 < z4 )else
--           X"0017E0A5" when(IP3>= z4 )else
          
--		  	  (others => '0') ;
			  
--B       <= X"FFFFA19F" when(IP3>= z1 and  IP3 < z2) else
--		     X"FFFBE712" when(IP3>= z2 and  IP3 < z3 )else
--           X"FFF9D111" when(IP3>= z3 and  IP3 < z4 )else
--           X"00019126" when(IP3>= z4 )else
          
--		  	  (others => '0') ;


end Behavioral;


