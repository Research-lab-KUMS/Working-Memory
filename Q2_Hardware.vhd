----------------------------------------------------------------------------------
-- linear Approximation for Q2(i+1)=(IP3(i+1)+d1)/(IP3(i+1)+d3);
-- Q2(i+1)= A * IP3 + B
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;

entity Q2_Hardware is
Generic(Data_Width: integer:=32;
shift_param: integer:=24);
    Port ( 
           IP3    : in   SIGNED (Data_Width-1 downto 0);
           Q2     : out  SIGNED (Data_Width-1 downto 0));
end Q2_Hardware;

architecture Behavioral of Q2_Hardware is
-------------Internal Signal--------------
signal reg1: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal reg2: SIGNED (Data_Width-1 downto 0):=(others =>'0');
signal A ,B: SIGNED (Data_Width-1 downto 0):=(others =>'0');
--------------ADD submodul ---------------
COMPONENT Approximation_Unit5 
     Port ( IP3 : in   SIGNED (Data_Width-1 downto 0);
			   A   : out  SIGNED (Data_Width-1 downto 0);
            B   : out  SIGNED (Data_Width-1 downto 0));
END COMPONENT;

begin
--------------Approximation Line ---------

U1 : Approximation_Unit5   
	  Port map(IP3  ,A  ,B );
      reg1 <= A * IP3 ;

------------------------------------
   
  reg2 <= reg1(Data_Width+shift_param-1 downto shift_param)+ B;
  Q2 <= reg2;

end Behavioral;
