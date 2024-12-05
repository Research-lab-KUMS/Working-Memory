
--Choose A and B for make linear segmentation
----------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;


entity Approximation_Unit1 is
Generic(Data_Width: integer:=32);
    Port ( 
	        IP3 : in   SIGNED (Data_Width-1 downto 0);
			  A   : out  SIGNED (Data_Width-1 downto 0);
           B   : out  SIGNED (Data_Width-1 downto 0));
end Approximation_Unit1;

  

architecture Behavioral of Approximation_Unit1 is
    constant z1 : SIGNED (Data_Width-1 downto 0):= X"00000000";
    constant z2 : SIGNED (Data_Width-1 downto 0):= X"00666666";
    constant z3 : SIGNED (Data_Width-1 downto 0):= X"00D9999A";
    constant z4 : SIGNED (Data_Width-1 downto 0):= X"01666666";
    constant z5 : SIGNED (Data_Width-1 downto 0):= X"02000000";
    constant z6 : SIGNED (Data_Width-1 downto 0):= X"03000000";
    constant z7 : SIGNED (Data_Width-1 downto 0):= X"06000000";
begin
	  	  
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

