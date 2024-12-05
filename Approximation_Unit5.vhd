

--Choose A and B for make linear segmentation
--(IP3(i) + d1) /(IP3(i) + d3)
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;

entity Approximation_Unit5 is
Generic(Data_Width: integer:=32);
	 Port ( IP3 : in   SIGNED (Data_Width-1 downto 0);
           A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit5;

architecture Behavioral of Approximation_Unit5 is

	constant z1 : SIGNED (Data_Width-1 downto 0):=X"00000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):=X"00B33333";
    constant z3 : SIGNED (Data_Width-1 downto 0):=X"0119999A";
    constant z4 : SIGNED (Data_Width-1 downto 0):=X"02000000";
    constant z5 : SIGNED (Data_Width-1 downto 0):=X"03000000";
    constant z6 : SIGNED (Data_Width-1 downto 0):=X"04000000";
    constant z7 : SIGNED (Data_Width-1 downto 0):=X"06000000";

begin
 

A <=   X"00874F83" when(IP3>= z1 and  IP3 < z2) else
	   X"00369011" when(IP3>= z2 and  IP3 < z3 )else
	   X"0024EFC6" when(IP3>= z3 and  IP3 < z4 )else
	   X"00118825" when(IP3>= z4 and  IP3 < z5 )else
	   X"000B6937" when(IP3>= z5 and  IP3 < z6 )else
       X"00067400" when(IP3>= z6 and  IP3 < z7 )else
       (others => '0') ;
			  
			  
B <=   X"002E3DC4" when(IP3>= z1 and  IP3 < z2) else
	   X"0066C3C6" when(IP3>= z2 and  IP3 < z3 )else
	   X"007A274D" when(IP3>= z3 and  IP3 < z4 )else
	   X"00A0F68E" when(IP3>= z4 and  IP3 < z5 )else
	   X"00B35357" when(IP3>= z5 and  IP3 < z6 )else
	   X"00C72836" when(IP3>= z6 and  IP3 < z7 )else
       (others => '0') ;
end Behavioral;


