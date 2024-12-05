
--Choose A and B for make linear segmentation
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;



entity Approximation_Unit3 is
Generic(Data_Width: integer:=32);
    Port ( Ca2 : in   SIGNED (Data_Width-1 downto 0);
		   A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit3;

  

architecture Behavioral of Approximation_Unit3 is
    constant z1 : SIGNED (Data_Width-1 downto 0):=X"00000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):=X"0002F599";
    constant z3 : SIGNED (Data_Width-1 downto 0):=X"00071FDE";
    constant z4 : SIGNED (Data_Width-1 downto 0):=X"0018A9BD";
    constant z5 : SIGNED (Data_Width-1 downto 0):=X"00256042";
    constant z6 : SIGNED (Data_Width-1 downto 0):=X"00341F21";
    constant z7 : SIGNED (Data_Width-1 downto 0):=X"004D2F1B";
    constant z8 : SIGNED (Data_Width-1 downto 0):=X"007D4952";
    constant z9 : SIGNED (Data_Width-1 downto 0):=X"01000000";

begin

A  <=      X"0216354F" when(Ca2>= z1 and  Ca2 < z2) else
		   X"07598513" when(Ca2>= z2 and  Ca2 < z3 )else
           X"0DA25460" when(Ca2>= z3 and  Ca2 < z4 )else
           X"08D12651" when(Ca2>= z4 and  Ca2 < z5 )else
           X"04BE2C1C" when(Ca2>= z5 and  Ca2 < z6 )else
           X"02225CFE" when(Ca2>= z6 and  Ca2 < z7 )else
           X"00ADAC76" when(Ca2>= z7 and  Ca2 < z8 )else
           X"001EFE52" when(Ca2>= z8 and  Ca2 < z9 )else
		   (others => '0') ;
			  
B  <=      X"00000744" when(Ca2>= z1 and  Ca2 < z2) else
		   X"FFF0664B" when(Ca2>= z2 and  Ca2 < z3 )else
           X"FFC3ACB7" when(Ca2>= z3 and  Ca2 < z4 )else
           X"003A6E0D" when(Ca2>= z4 and  Ca2 < z5 )else
           X"00D2B45F" when(Ca2>= z5 and  Ca2 < z6 )else
           X"015AABA6" when(Ca2>= z6 and  Ca2 < z7 )else
           X"01CB0952" when(Ca2>= z7 and  Ca2 < z8 )else
           X"0210DD37" when(Ca2>= z8 and  Ca2 < z9 )else
           (others => '0') ;

		  	  
end Behavioral;

