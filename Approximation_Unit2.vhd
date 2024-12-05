
--Choose A and B for make linear segmentation
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;



entity Approximation_Unit2 is
Generic(Data_Width: integer:=32);
    Port ( Ca2 : in   SIGNED (Data_Width-1 downto 0);
		   A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit2;

architecture Behavioral of Approximation_Unit2 is
    constant z1 : SIGNED (Data_Width-1 downto 0):= X"00000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):= X"002E147B";
    constant z3 : SIGNED (Data_Width-1 downto 0):= X"004D0E56";
    constant z4 : SIGNED (Data_Width-1 downto 0):= X"00800000";
    constant z5 : SIGNED (Data_Width-1 downto 0):= X"00AAACDA";
    constant z6 : SIGNED (Data_Width-1 downto 0):= X"00D55326";
    constant z7 : SIGNED (Data_Width-1 downto 0):= X"01000000";

begin


    A <=   X"01FE5D2F" when(Ca2>= z1 and  Ca2 < z2) else
		   X"0162FE28" when(Ca2>= z2 and  Ca2 < z3 )else
		   X"00BA3611" when(Ca2>= z3 and  Ca2 < z4 )else
		   X"00687142" when(Ca2>= z4 and  Ca2 < z5 )else
		   X"004A4686" when(Ca2>= z5 and  Ca2 < z6 )else
		   X"0034D50E" when(Ca2>= z6 and  Ca2 < z7 )else
		   (others => '0' ) ;
		  	 
		  	 
	B <=   X"FFF7D31B" when(Ca2>= z1 and  Ca2 < z2) else
		   X"0013CA9C" when(Ca2>= z2 and  Ca2 < z3 )else
           X"0046983F" when(Ca2>= z3 and  Ca2 < z4 )else
           X"006F7AA7" when(Ca2>= z4 and  Ca2 < z5 )else
           X"00839765" when(Ca2>= z5 and  Ca2 < z6 )else
           X"009575C6" when(Ca2>= z6 and  Ca2 < z7 )else
		   (others => '0') ;


end Behavioral;

