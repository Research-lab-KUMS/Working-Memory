

--Choose A and B for make linear segmentation
--(Ca2(i) + d1) /(Ca2(i) + d3)
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;

entity Approximation_Unit6 is
Generic(Data_Width: integer:=32);
	 Port ( Ca2 : in   SIGNED (Data_Width-1 downto 0);
           A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit6;

architecture Behavioral of Approximation_Unit6 is
	constant z1 : SIGNED (Data_Width-1 downto 0):= X"00000000";
	constant z2 : SIGNED (Data_Width-1 downto 0):= X"002AAAAB";
	constant z3 : SIGNED (Data_Width-1 downto 0):= X"00555555";
	constant z4 : SIGNED (Data_Width-1 downto 0):= X"00800000";
	constant z5 : SIGNED (Data_Width-1 downto 0):= X"00AAAAAB";
	constant z6 : SIGNED (Data_Width-1 downto 0):= X"00D55555";
	constant z7 : SIGNED (Data_Width-1 downto 0):= X"01000000";

begin
 
A <=     X"00305E09" when(Ca2>= z1 and  Ca2 < z2) else
		 X"0024D9D4" when(Ca2>= z2 and  Ca2 < z3 )else
		 X"001D4F56" when(Ca2>= z3 and  Ca2 < z4 )else
		 X"0017CB6F" when(Ca2>= z4 and  Ca2 < z5 )else
		 X"0013B20D" when(Ca2>= z5 and  Ca2 < z6 )else
		 X"0010A1AD" when(Ca2>= z6 and  Ca2 < z7 )else
         (others => '0' ) ;
             
B <=     X"000F8C52" when(Ca2>= z1 and  Ca2 < z2) else
		 X"001177B0" when(Ca2>= z2 and  Ca2 < z3 )else
		 X"0013FB30" when(Ca2>= z3 and  Ca2 < z4 )else
		 X"0016BD23" when(Ca2>= z4 and  Ca2 < z5 )else
		 X"001978B9" when(Ca2>= z5 and  Ca2 < z6 )else
		 X"001C065F" when(Ca2>= z6 and  Ca2 < z7 )else
         (others => '0' ) ;

end Behavioral;


