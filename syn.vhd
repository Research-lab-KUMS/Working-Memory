
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.ALL;
-----------------------------------------------------------------------------------------------------

entity syn is

    Generic(Data_Width: integer:=32;
    shift_param:integer:=16);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           V_Pre: in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
           V_Post: in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
           Iastro_neuron:in STD_LOGIC ;
           Isyn: out STD_LOGIC_VECTOR (Data_Width-1 downto 0)
        
           
           );
end syn;

architecture Arch of syn is
-----------------------------------------------------------------------------------------------------
signal  r_Weight  : signed(Data_Width-1 downto 0):=(others => '0');
signal  r_Isyn    : signed(Data_Width-1 downto 0):=(others => '0');
signal  r_Vpre    : signed(Data_Width-1 downto 0):=(others => '0');
signal  r_Vpost   : signed(Data_Width-1 downto 0):=(others => '0');
signal  dv        : signed(Data_Width-1 downto 0):=(others => '0');
signal  r_Func    : signed(Data_Width-1 downto 0):=(others => '0');
signal  r_Istro   : signed(Data_Width-1 downto 0):=(others => '0');
signal  S         : signed(Data_Width-1 downto 0):=(others => '0');
signal  A         : signed(Data_Width-1 downto 0):=(others => '0');
signal  B         : signed(Data_Width-1 downto 0):=(others => '0');
-----------------------------------------------------------------------------------------------------
signal  m_Func    : signed(2*Data_Width-1 downto 0):=(others => '0');
signal  m_S       : signed(2*Data_Width-1 downto 0):=(others => '0');
signal  m_dt      : signed(2*Data_Width-1 downto 0):=(others => '0');
signal  m_post    : signed(2*Data_Width-1 downto 0):=(others => '0');
signal  m_Weight  : signed(2*Data_Width-1 downto 0):=(others => '0');
signal  m_Isyn    : signed(2*Data_Width-1 downto 0):=(others => '0');
-----------------------------------------------------------------------------------------------------

constant  Gsyn  : signed(Data_Width-1 downto 0):= X"000007ae"; 
constant  aep   : signed(Data_Width-1 downto 0):= X"00013333"; 

constant  dt               : integer := 16; 

constant x  : integer := 16;
constant  Esyn       : signed(Data_Width-1 downto 0):=X"00000000"; -- -0
constant  Alpha_Shift_Left :  integer := 3;
constant  A_0       : signed(Data_Width-1 downto 0):=X"00008000";
constant  B_0       : signed(Data_Width-1 downto 0):=X"00008000";
constant r_Limit_1  : signed(Data_Width-1 downto 0):=X"FFD80000";
constant r_Limit_2  : signed(Data_Width-1 downto 0):=X"FFE80000";
constant r_Limit_3  : signed(Data_Width-1 downto 0):=X"FFEE0000";
constant r_Limit_4  : signed(Data_Width-1 downto 0):=X"FFF30000";
constant r_Limit_5  : signed(Data_Width-1 downto 0):=X"FFF90000";
constant r_Limit_6  : signed(Data_Width-1 downto 0):=X"00070000";
constant r_Limit_7  : signed(Data_Width-1 downto 0):=X"000A0000";
constant r_Limit_8  : signed(Data_Width-1 downto 0):=X"00110000";
constant r_Limit_9  : signed(Data_Width-1 downto 0):=X"001E0000";
------------------------------------------------------------------------------------------------------
constant Zeros      : signed(Data_Width-1 downto 0):=(others => '0');
constant Ones       : signed(Data_Width-1 downto 0):=X"00010000";--1
-----------------------------------------------------------------------------------------------------


begin


  A <=  
        X"00000000"  when r_Vpre <= r_Limit_1 else
        X"00000039"  when r_Vpre <= r_Limit_2 else
        X"0000015B"  when r_Vpre <= r_Limit_3 else
        X"000002A6"  when r_Vpre <= r_Limit_4 else
        X"00000593"  when r_Vpre <= r_Limit_5 else
        X"000009EE"  when r_Vpre <= r_Limit_6 else
        X"00000665"  when r_Vpre <= r_Limit_7 else
        X"000003F0"  when r_Vpre <= r_Limit_8 else
        X"000000E8"  when r_Vpre <= r_Limit_9 else                          
       Zeros; 

 B <=  
               X"FFFFFFFE"  when r_Vpre <= r_Limit_1 else
               X"000008E4"  when r_Vpre <= r_Limit_2 else
               X"0000241A"  when r_Vpre <= r_Limit_3 else
               X"00003B63"  when r_Vpre <= r_Limit_4 else
               X"00006162"  when r_Vpre <= r_Limit_5 else
               X"00007FE2"  when r_Vpre <= r_Limit_6 else
               X"000098A0"  when r_Vpre <= r_Limit_7 else
               X"0000B131"  when r_Vpre <= r_Limit_8 else
               X"0000E4B6"  when r_Vpre <= r_Limit_9 else                          
              ones;
-----------------------------------------------------------------------------------------------------
 m_Func  <= A * r_Vpre ; 
 r_Func  <= m_Func(x+31 downto x) + B; -------A*x+B

-----------------------------------------------------------------------------------------------------
 
 r_Weight <= aep+Gsyn  when (Iastro_neuron = '1') else Gsyn;----- gsync = params.gsyn + Iastro_neuron(Post).* params.aep;
 dv <= (Esyn-r_Vpost);
 m_post   <=  r_Func * dv; ----------S(Pre) .* (params.Esyn - V(Post));
 m_Isyn   <=  r_Weight  * m_post(x+31 downto x) ;---------  gsync .* S(Pre) .* (params.Esyn - V(Post));
-----------------------------------------------------------------------------------------------------

 r_Isyn <= m_Isyn (x+31 downto x);
 Isyn   <= std_logic_vector(r_Isyn); 
   r_Vpre   <= signed(V_pre);
   r_Vpost  <= signed(V_post);
    
end Arch;

