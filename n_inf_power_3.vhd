----------------------------------------------------------------------------------
-- linear Approximation for n_inf(i+1)=Ca2(i+1)/(Ca2(i+1)+d5);
-- n_inf(i+1)= A * Ca2 + B
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;

entity n_inf_power_3 is
Generic(Data_Width: integer:=32;
shift_param: integer:=24);
    Port ( 
           Enable       : in  STD_LOGIC;
	        Ca2          : in  SIGNED (Data_Width-1 downto 0):=(others =>'0');
           n_inf_power3 : out SIGNED (Data_Width-1 downto 0):=(others =>'0'));
end n_inf_power_3;

architecture Behavioral of n_inf_power_3 is
-------------Internal Signal--------------
signal reg1: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal reg2: SIGNED (Data_Width-1 downto 0):=(others =>'0');
signal A ,B: SIGNED (Data_Width-1 downto 0):=(others =>'0');
--------------ADD submodul ---------------
COMPONENT Approximation_Unit2 
     Port ( 
				Ca2 : in   SIGNED (Data_Width-1 downto 0);
			   A   : out  SIGNED (Data_Width-1 downto 0);
            B   : out  SIGNED (Data_Width-1 downto 0));
END COMPONENT;

begin
--------------Approximation Line ---------

U1 : Approximation_Unit2   
	  Port map( Ca2  ,A  ,B );

process(A ,Enable ,Ca2)
  begin
    if(Enable='1') then	  
reg1 <= A * Ca2 ;
 else 
 reg1 <= (others =>'0');
 end if;
end process;

process(B ,reg1, Enable)
  begin
    if(Enable='1') then	  
reg2 <= reg1(Data_width+shift_param-1 downto shift_param)+ B;
 else 
 reg2 <= (others =>'0');
 end if;
end process;


  n_inf_power3 <= reg2;


end Behavioral;

