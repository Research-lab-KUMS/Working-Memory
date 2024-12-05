-------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;
-------------------------------------------------------------------------------------------------------------
entity ca_module is
    Generic( Data_Width  : integer :=32;
             shift_param : integer :=24;
             Clk_period : integer := 50
           );

    Port ( CLK     : in std_logic;
           ca_i    : in std_logic_vector (Data_width-1 downto 0);
           diff_ca : in std_logic_vector (Data_width-1 downto 0);
           ip_i    : in std_logic_vector (Data_width-1 downto 0);
           diff_ip : in std_logic_vector (Data_width-1 downto 0);
           h_i     : in std_logic_vector (Data_width-1 downto 0);
           jglu    : in std_logic_vector (Data_width-1 downto 0);
           in_IP3  : out std_logic_vector (Data_width-1 downto 0);
           Ca21    : out std_logic_vector (Data_width-1 downto 0);
           h_o     : out std_logic_vector (Data_width-1 downto 0)
		  );
end ca_module;
-------------------------------------------------------------------------------------------------------------

architecture Behavioral of ca_module is

-------------Internal Signals--------------
signal multipl1 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal multipl2 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal multipl3 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal multipl4 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal multipl5 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal multipl6 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal multipl7 : SIGNED (2*Data_width-1 downto 0):=(others =>'0');
signal jout     : SIGNED (2*Data_width-1 downto 0):=(others =>'0');

signal J_pump   : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal result   : SIGNED (Data_width-1 downto 0):=X"00128F08";
signal result1  : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal Jin      : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal J_out    : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal n_inf_power3 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal m_inf_power3 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal sum1 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal sum2 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal sum3 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal sum4 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal sum5 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal sum6 : SIGNED (Data_width-1 downto 0):=(others =>'0');

signal h    : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal hi   : SIGNED (Data_width-1 downto 0):=(others =>'0');

signal E      : std_logic_vector(50 downto 0):=(others =>'0');
signal Enable : std_logic:='0';
-------------Internal Constants--------------
constant dclk : integer:=(Clk_period/50);
constant C0   : SIGNED(Data_width-1 downto 0) := X"0ACF914C";
constant C1   : SIGNED(Data_width-1 downto 0) := X"0667C8A6";
constant V_ER : SIGNED(Data_width-1 downto 0) := X"02333333";
constant rl   : SIGNED(Data_width-1 downto 0) := X"000535A8";
constant rc   : SIGNED(Data_width-1 downto 0) := X"011C28F6";
constant dt   : SIGNED(Data_width-1 downto 0) := X"0000068E";
------------------------------------------
signal h_power3 : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal IP3      : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal Ca2      : SIGNED (Data_width-1 downto 0):=(others =>'0');
signal Ca_o     : SIGNED (Data_width-1 downto 0):=X"00128F08";
signal ip_o     : SIGNED (Data_width-1 downto 0):=(others =>'0');

-------------------------------------------------------------------------------------------------------------
-------------ADD submoduls ----------------
COMPONENT IP3_hardware
Generic(Data_Width: integer:=32;
shift_param: integer:=24;
 Clk_period : integer := 50);
    Port ( CLK     : in STD_LOGIC;
	       Enable  : in STD_LOGIC;
	       Ca2     : in SIGNED (Data_width-1 downto 0);
	       ip_i    : in SIGNED (Data_Width-1 downto 0);
	       diff_ip : in SIGNED (Data_Width-1 downto 0);
	       j_glu   : in SIGNED (Data_Width-1 downto 0);
           IP3     : OUT SIGNED (Data_width-1 downto 0));
end COMPONENT;
-------------------------------------------------------------------------------------------------------------
COMPONENT n_inf_power_3 
     Port ( Enable       : in  STD_LOGIC;
	        Ca2          : in  SIGNED (Data_width-1 downto 0);
            n_inf_power3 : out SIGNED (Data_width-1 downto 0));
END COMPONENT;
-------------------------------------------------------------------------------------------------------------
COMPONENT m_inf_power_3 
     Port ( Enable       : in  STD_LOGIC;
	        IP3          : in  SIGNED (Data_width-1 downto 0);
            m_inf_power3 : out SIGNED (Data_width-1 downto 0));
END COMPONENT;
-------------------------------------------------------------------------------------------------------------
COMPONENT J_pump_Hardware 
     Port ( Enable : in  STD_LOGIC;
	        Ca2    : in  SIGNED (Data_width-1 downto 0);
            J_pump : out SIGNED (Data_width-1 downto 0));
END COMPONENT;
-------------------------------------------------------------------------------------------------------------
COMPONENT J_in 
     Port ( Enable : in  STD_LOGIC;
	        IP3    : in  SIGNED (Data_width-1 downto 0);
            Jin    : out SIGNED (Data_width-1 downto 0));
END COMPONENT;
-------------------------------------------------------------------------------------------------------------
COMPONENT h_Hardware is
Generic(Data_Width: integer:=32;
shift_param: integer:=24;
 Clk_period : integer := 50);
    Port ( CLK    : in  STD_LOGIC;
	       Enable : in  STD_LOGIC;
	       hi     : in  SIGNED (Data_width-1 downto 0);
           IP3    : in  SIGNED (Data_width-1 downto 0);
           Ca2    : in  SIGNED (Data_width-1 downto 0);
           h1     : out SIGNED (Data_width-1 downto 0));
END COMPONENT;
-------------------------------------------------------------------------------------------------------------
COMPONENT h_power_3 is
    Port ( Enable   : in  STD_LOGIC;
	       h        : in  SIGNED (Data_width-1 downto 0):=(others =>'0');
           h_power3 : out SIGNED (Data_width-1 downto 0):=(others =>'0'));
END COMPONENT;
-------------------------------------------------------------------------------------------------------------

begin

U1 : n_inf_power_3   
	  Port map( Enable       => Enable , 
	            Ca2          => Ca2 ,
	            n_inf_power3 => n_inf_power3
	           );
      
U2 : m_inf_power_3   
	  Port map( Enable       => Enable , 
	            IP3          => IP3 ,
	            m_inf_power3 => m_inf_power3
	            );
	  
U3 : J_pump_Hardware   
	  Port map( Enable  => Enable , 
	            Ca2     => Ca2 ,
	            J_pump  => J_pump
	            );	  
	            
U4 : h_Hardware 
Generic map(Data_Width => 32,
            shift_param=> 24,
            Clk_period => Clk_period)
     Port map( CLK    => CLK    , 
               Enable => Enable , 
               hi     => hi     ,
               IP3    => IP3    ,
               Ca2    => Ca2    ,
               h1     => h
              );
    
U5 : h_power_3   
	  Port map( Enable   => Enable , 
	            h        => h ,
	            h_power3 => h_power3
	            );	  	  
	  
U8 : IP3_hardware 
    Generic map(
          Data_Width  => 32,
          shift_param => 24,
          Clk_period  => Clk_period)
    Port map( CLK     => CLK,
              Enable  => Enable,
              Ca2     => Ca2,
              ip_i    => IP3,
              diff_ip => signed(diff_ip),
              j_glu   => signed(jglu),
              IP3     => ip_o 
            );
  
U9 : J_in 
    Port map( Enable => Enable ,
              IP3    => IP3    , 
              Jin    => Jin 
             );
-------------------------------------------------------------------------------------------------------------
in_IP3 <= std_logic_vector(ip_o);
Ca2    <= signed(ca_i);
IP3    <= signed(ip_i);
hi     <= signed(h_i);
-------------------------------------------------------------------------------------------------------------
process(CLK)
 begin
  if rising_edge(CLK)then
    E <= E+1;
  end if;
end process;
Enable   <= '1' when( e >= 1) else '0';

-------------------------------------------------------------------------------------------------------------
--sum1     <= 1 + C1;
process(Enable ,m_inf_power3 )
 begin
  if(Enable='1') then
    multipl1 <= rc * m_inf_power3 ;
  else
    multipl1 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,n_inf_power3 ,h_power3)
 begin
  if(Enable='1') then
    multipl2 <= h_power3 * n_inf_power3 ;
  else
    multipl2 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,multipl1 ,multipl2 )
 begin
  if(Enable='1') then
    multipl3 <= multipl1(shift_param+Data_Width-1 downto shift_param) * multipl2(shift_param+Data_Width-1 downto shift_param) ;-----rc * m^3 *h^3 * n^3
  else
    multipl3 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,sum1 ,Ca2)
 begin
  if(Enable='1') then
    multipl4 <= Ca2 * C1 ;----------ca2 * (1+c1)
  else
    multipl4 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,multipl3 )
 begin
  if(Enable='1') then
    sum2 <= rl + multipl3(shift_param+Data_Width-1 downto shift_param) ;--------rl+rc * m^3 *h^3 * n^3
  else
    sum2 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,multipl4 )
 begin
  if(Enable='1') then
    sum3 <= C0 - multipl4(shift_param+Data_Width-1 downto shift_param) ;----- c0-ca2 * (1+c1)
  else
    sum3 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,sum2 ,sum3 )
 begin
  if(Enable='1') then
    multipl5 <= sum2 * sum3 ;--------- (rl+rc * m^3 *h^3 * n^3 )*(c0-ca2 * (1+c1))= jer+jleak
  else
    multipl5 <= (others =>'0');
  end if;
end process;

-------------------------------------------------------------------------------------------------------------
process(Enable ,multipl5 ,J_pump )
 begin
  if(Enable='1') then
    sum4 <= multipl5(shift_param+Data_Width-1 downto shift_param) - J_pump ;----jer+jleak-jpump
  else
    sum4 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,sum4,Jin )
 begin
  if(Enable='1') then
    sum5 <= sum4+Jin ;----------jer+jleak-jpump+jin
  else
    sum5 <= (others =>'0');
  end if;
end process;

-------------------------------------------------------------------------------------------------------------
process(Enable ,sum5,Ca2 )
 begin
  if(Enable='1') then
    sum6 <= sum5-shift_right(Ca2,1);
  else
    sum6 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,sum6 )
 begin
  if(Enable='1') then
    multipl7 <= dt * sum6 ;
  else
    multipl7 <= (others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(Enable ,multipl7 ,Ca2 )
 begin
  if(Enable='1') then
    result1 <= multipl7(shift_param+Data_Width-1 downto shift_param) + Ca2 ;
  else
    result1 <=(others =>'0');
  end if;
end process;
-------------------------------------------------------------------------------------------------------------
process(result1,diff_ca )   --Enable ,
 begin

    result <= result1 + signed(diff_ca) ;

end process;
-------------------------------------------------------------------------------------------------------------
process(result ) --,Enable
 begin

    Ca_o <= result;

end process;
-------------------------------------------------------------------------------------------------------------

Ca21 <= STD_LOGIC_VECTOR(Ca_o);

h_o <= STD_LOGIC_VECTOR (h);

end Behavioral;

