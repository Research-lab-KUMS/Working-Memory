----------------------------------------------------------------------------------
-- linear Approximation for J_pump(i+1)=((Ca2(i+1)^2)/(k_ER^2+Ca2(i+1)^2));;
-- n_inf(i+1)= A * Ca2 + B
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;

entity J_pump_Hardware is
Generic(Data_Width: integer:=32;
shift_param: integer:=24);
    Port ( Enable : in  STD_LOGIC;
	        
	        Ca2    : in  SIGNED (Data_Width-1 downto 0):=(others =>'0');
           J_pump : out SIGNED (Data_Width-1 downto 0):=(others =>'0'));
end J_pump_Hardware;

architecture Behavioral of J_pump_Hardware is
-------------Internal Signal--------------
signal reg1: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal reg2: SIGNED (Data_Width-1 downto 0):=(others =>'0');
signal A ,B: SIGNED (Data_Width-1 downto 0):=(others =>'0');
--------------ADD submodul ---------------
COMPONENT Approximation_Unit3 
     Port ( 
	         Ca2 : in   SIGNED (Data_Width-1 downto 0);
			   A   : out  SIGNED (Data_Width-1 downto 0);
            B   : out  SIGNED (Data_Width-1 downto 0));
END COMPONENT;

begin
--------------Approximation Line ---------

U1 : Approximation_Unit3   
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
reg2 <= reg1(shift_param+Data_Width-1 downto shift_param)+ B;
 else 
 reg2 <= (others =>'0');
 end if;
end process;
--
--process(CLK)
--  begin
--    if(CLK'event and CLK='1') then

       J_pump <= reg2;

--    end if;
--end process;

end Behavioral;

