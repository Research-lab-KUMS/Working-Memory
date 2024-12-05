----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;


entity h_Hardware is
Generic(Data_Width: integer:=32;
shift_param: integer:=24;
 Clk_period : integer := 50);
    Port ( CLK     : in  STD_LOGIC;
	        Enable  : in  STD_LOGIC;
	        hi    : in  SIGNED (Data_width-1 downto 0);
           IP3     : in  SIGNED (Data_Width-1 downto 0);
           Ca2     : in  SIGNED (Data_Width-1 downto 0);
           h1      : out SIGNED (Data_Width-1 downto 0));
end h_Hardware;

architecture Behavioral of h_Hardware is
-------------Internal Signals--------------
signal multipl1 ,multipl2: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal multipl3 ,multipl4: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal multipl5 ,multipl6: SIGNED (2*Data_Width-1 downto 0):=(others =>'0');
signal sum1 ,sum2, Q2 ,h : SIGNED (Data_Width-1 downto 0):=(others =>'0');
signal hh    : SIGNED (Data_Width-1 downto 0):=X"00E2E579";

-------------Internal Constants--------------
constant dclk : integer:=(Clk_period/50);
constant a2    : SIGNED(Data_Width-1 downto 0) :=X"0023D70A";
constant d2    : SIGNED(Data_Width-1 downto 0) :=X"010C8B44";
constant dt    : SIGNED(Data_Width-1 downto 0) :=X"0000068E";
constant k     : SIGNED(Data_Width-1 downto 0) :=X"01000000";
-------------ADD submoduls ------------------
COMPONENT Q2_Hardware 
     Port (
	        IP3    : in  SIGNED (Data_Width-1 downto 0);
           Q2     : out SIGNED (Data_Width-1 downto 0));
END COMPONENT;
----------------------------------------------

begin


U1 : Q2_Hardware   
	  Port map(  IP3 , Q2);

----------------------------------------------
h <=hi;

---------------------------
process(Enable ,h )
begin
if(Enable='1') then
sum1 <= k - h;
else
sum1 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable ,multipl1 ,Q2 )
begin
if(Enable='1') then
multipl2 <= a2 * Q2 ;
else
multipl2 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable ,multipl2 ,sum1 )
begin
if(Enable='1') then
multipl3 <= multipl2(Data_Width+shift_param-1 downto shift_param) * sum1 ;
else
multipl3 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable , h )
begin
if(Enable='1') then
multipl4 <= a2 * h;
else
multipl4 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable ,multipl4 ,Ca2)
begin
if(Enable='1') then
multipl5 <= multipl4(Data_Width+shift_param-1 downto shift_param) * Ca2 ;
else
multipl5 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable ,multipl3 ,multipl5)
begin
if(Enable='1') then
sum2 <= multipl3(Data_Width+shift_param-1 downto shift_param) - multipl5(Data_Width+shift_param-1 downto shift_param) ;
else
sum2 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable ,sum2)
begin
if(Enable='1') then
multipl6 <= sum2 * dt ;
else
multipl6 <= (others =>'0');
end if;
end process;
---------------------------
process(Enable ,multipl6 ,h)
begin
if(Enable='1') then
hh <= multipl6(Data_Width+shift_param-1 downto shift_param) + h ;
else
hh <= X"00E2E579";
end if;
end process;
---------------------------
process(CLK ,Enable)
  begin
  if(Enable='0') then
  h1 <= X"00E2E579";
  else
  if(CLK'event and CLK='1') then
  h1 <= hh;
  end if;
  end if;
end process;


end Behavioral;

