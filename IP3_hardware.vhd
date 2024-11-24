----------------------------------------------------------------------------------
-- IP3(i+1)=IP3(i)+dt*(((IP3_star-IP3(i))/tau_IP3)+(r_IP3*AG(i)));
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;

entity IP3_hardware is
Generic(Data_Width: integer:=32;
shift_param: integer:=24;
 Clk_period : integer := 50);
    Port ( CLK     : in  STD_LOGIC;
	        Enable  : in  STD_LOGIC;
	        Ca2          : in  SIGNED (Data_width-1 downto 0);
			ip_i  : in  SIGNED(Data_Width-1 downto 0);
			diff_ip :in SIGNED(Data_Width-1 downto 0);
			j_glu :in SIGNED(Data_Width-1 downto 0);
           IP3     : OUT SIGNED(Data_Width-1 downto 0));
end IP3_hardware;

architecture Behavioral of IP3_hardware is
-------------Internal Signal--------------
constant dclk : integer:=(Clk_period/50);
constant dt     : SIGNED (Data_Width-1 downto 0):=X"0000068E"; --*(to_signed(dclk,data_width/2));
constant Tau_inv: SIGNED (Data_Width-1 downto 0):=X"0023D70A";--"000000010010010010010010010000110110010";
constant Aglu: SIGNED (Data_Width-1 downto 0):=X"05000000";
--constant r_IP3  : SIGNED (Data_Width-1 downto 0):=X"00800000";--"000001000000000000000000000000000000000";
constant IP3_star: SIGNED (Data_Width-1 downto 0):=X"0028F5C3";--"000000010100011110101110000101000111101";
signal multipl2,multipl3: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal sum1,sum2,result,result1,Jplc,IP33  : SIGNED (Data_Width-1 downto 0):=(others =>'0');
signal Ca21: SIGNED (Data_width-1 downto 0);
--------------ADD submodul -----------------
COMPONENT J_plc 
     Port (
	        Enable : in  STD_LOGIC;
	        Ca2    : in  SIGNED (Data_width-1 downto 0);
           J_plc : out SIGNED (Data_width-1 downto 0));
END COMPONENT;
----------------------------------------------

begin
U9 : J_plc   
	  Port map( Enable , Ca21 ,Jplc);

--------------Approximation Line ---------
IP33 <= ip_i;

Ca21 <= Ca2;
process(Enable ,IP33)
begin
if(Enable='1') then
sum1 <= IP3_star-IP33 ;
else
sum1 <= (others =>'0');
end if;
end process;


process(Enable ,sum1  )
begin
if(Enable='1') then
multipl2 <= sum1*Tau_inv ;
else
multipl2 <= (others =>'0');
end if;
end process;

process(Enable ,Jplc,multipl2  )
begin
if(Enable='1') then
sum2 <=Jplc+multipl2(Data_Width+shift_param-1 downto shift_param) ;
else
sum2 <= (others =>'0');
end if;
end process;

process(Enable ,sum2  )
begin
if(Enable='1') then
multipl3 <= dt*sum2 ;
else
multipl3 <= (others =>'0');
end if;
end process;

process(Enable ,multipl3 ,IP33)
begin
if(Enable='1') then
result1 <= multipl3(Data_Width+shift_param-1 downto shift_param) + IP33 ;
else
result1<=(others =>'0');-- "000000010100011110101110000101000111101";
end if;
end process;


process(Enable ,result1,j_glu,diff_ip)
begin
if(Enable='1') then
result <= result1+diff_ip+j_glu ;
else
result<=X"00D1F8E4";-- "000000010100011110101110000101000111101";
end if;
end process;

---------------------------
process(result ,Enable)
  begin
  if(Enable='0') then
--  IP33 <=X"0028F5C3";-- "000000010100011110101110000101000111101";
  IP3  <=X"00D1F8E4";-- "000000010100011110101110000101000111101";
  else
--  if(CLK'event and CLK='1') then
  IP3 <= result;
--  IP3  <= IP33;
  end if;
--  end if;
  
end process;
 

end Behavioral;

