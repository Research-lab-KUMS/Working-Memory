---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;
use work.buffer_type.all;
use work.wm_package.all;
use std.textio.all;
use ieee.std_logic_textio.all;
-------------------------------------------------------------------------------------------------------------
entity ca_nn is
    Generic(Data_Width       : integer := 32  ;
            shift_param      : integer := 24  ;
            Number_of_Neuron : integer := 100 ;
            astro_size       : integer := 25; ---9
            Clk_period : integer := 50
           );
Port ( CLK         : in std_logic;
       clk_s       : in std_logic;
       enable      : in std_logic;
       I_neuron    : in std_logic_vector(0 to Number_of_Neuron-1);
       T_test      : in std_logic;
       neuron_astro_indx   : in std_logic_vector (6 downto 0);
       V_neuron    : out std_logic_vector(Data_Width-1 downto 0);
       Glu_neuron  : out std_logic_vector(Data_width-1 downto 0);
       ip3_astro   : out std_logic_vector(Data_width-1 downto 0);
       Ca_astro    : out std_logic_vector(Data_width-1 downto 0)    
		);
end ca_nn; 
-------------------------------------------------------------------------------------------------------------

architecture Behavioral of ca_nn is

constant r_indx : integer :=1;  

constant dclk     : integer:=(Clk_period/50); 
constant dtca     : std_logic_vector(Data_width-1 downto 0) := X"00000032";
constant dtip     : std_logic_vector(Data_width-1 downto 0) := X"00000032";
constant counterj_max:integer:=600*(Clk_period/50);
constant J_astron : std_logic_vector(Data_width-1 downto 0) := X"000020C5";
constant Ca_thr   : std_logic_vector(Data_width-1 downto 0) := X"00400000";

signal diff_tempc  : std_logic_vector(2*Data_width-1 downto 0) :=(others => '0'); 
signal diff_tempip : std_logic_vector(2*Data_width-1 downto 0) :=(others => '0'); 
-------------------------------------------------------------------------------------------------------------
type astro_array is array (0 to astro_size-1) of  STD_LOGIC_VECTOR (Data_width-1 downto 0);
type mult_array  is array (0 to astro_size-1) of STD_LOGIC_VECTOR (2*Data_width-1 downto 0);
------------------------------ping pong signals v ----------------
signal ca_buffer1 : astro_array := (others => (X"00128F08")); -----------------buffers
signal ca_buffer2 : astro_array := (others => (X"00128F08")); -----------------buffers

signal ca_diff    : astro_array := (others => (others => '0')); -----------------buffers

signal ca_process_buffer : integer range 0 to astro_size-1:=0; --------------pointers
signal ca_record_buffer  : integer range 0 to astro_size-1:=0; --------------pointers
signal ca_pp_prt         : integer range 0 to astro_size-1:=0; --------------pointers
signal r_astro_indx    : integer range 0 to Number_of_Neuron:=0 ;
---------------------- u &g  buffer----------------
signal ip_buffer1   : astro_array := (others => (X"00D1F8E4"));
signal ip_buffer2   : astro_array := (others => (X"00D1F8E4"));
signal ip_diff      : astro_array := (others => (others => '0'));

signal J_glu        : astro_array := (others => (others => '0'));
signal h_buffer1    : astro_array := (others => (X"00E2E579"));
signal h_buffer2    : astro_array := (others => (X"00E2E579"));

-------------------------------------------------------------------------------------------------------------
signal  cao     : std_logic_vector(Data_width-1 downto 0):=(others => '0');
signal  temp_ca : std_logic_vector(Data_width-1 downto 0):=X"00128F08";
signal  temp_ip : std_logic_vector(Data_width-1 downto 0):= X"00D1F8E4";
signal  ipo     : std_logic_vector(Data_width-1 downto 0):=(others => '0');
signal  temp_h  : std_logic_vector(Data_width-1 downto 0):=X"00E2E579";
signal  ho      : std_logic_vector(Data_width-1 downto 0):=(others => '0');


signal Glu  : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others => '0');
signal jglu : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others => '0'); 
--signal V    : STD_LOGIC_VECTOR (Data_Width-1 downto 0); 
--signal Glu_n    :STD_LOGIC_VECTOR (Data_Width-1 downto 0);
signal V_n      : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others => '0'); 
signal r_Glu_n  :STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others => '0');

signal G_indx        : STD_LOGIC_VECTOR (6 downto 0):=(others => '0');
signal ca_indx       : STD_LOGIC_VECTOR (3 downto 0):=(others => '0');
signal Mask          : STD_LOGIC :='0';
signal Iastro_neuronn: STD_LOGIC :='0';
signal Ijglu         : STD_LOGIC :='0';

signal Iastro_neuronca1 : STD_LOGIC:='0';
signal Iastro_neuronca2 : STD_LOGIC:='0';
signal Iastro_neuronca3 : STD_LOGIC:='0';
signal Iastro_neuronca4 : STD_LOGIC:='0';
signal Iastro_neuronca5 : STD_LOGIC:='0';
signal Iastro_neuronca6 : STD_LOGIC:='0';
signal Iastro_neuronca7 : STD_LOGIC:='0';
signal Iastro_neuronca8 : STD_LOGIC:='0';
signal Iastro_neuronca9 : STD_LOGIC:='0';
signal Iastro_neuronca10 : STD_LOGIC:='0';
signal Iastro_neuronca11 : STD_LOGIC:='0';
signal Iastro_neuronca12 : STD_LOGIC:='0';
signal Iastro_neuronca13 : STD_LOGIC:='0';
signal Iastro_neuronca14 : STD_LOGIC:='0';
signal Iastro_neuronca15 : STD_LOGIC:='0';
signal Iastro_neuronca16 : STD_LOGIC:='0';
signal Iastro_neuronca17 : STD_LOGIC:='0';
signal Iastro_neuronca18 : STD_LOGIC:='0';
signal Iastro_neuronca19 : STD_LOGIC:='0';
signal Iastro_neuronca20 : STD_LOGIC:='0';
signal Iastro_neuronca21 : STD_LOGIC:='0';
signal Iastro_neuronca22 : STD_LOGIC:='0';
signal Iastro_neuronca23 : STD_LOGIC:='0';
signal Iastro_neuronca24 : STD_LOGIC:='0';
signal Iastro_neuronca25 : STD_LOGIC:='0';

signal Iastro_j     : STD_LOGIC_vector (0 to astro_size-1):=(others => '0');
signal Iastro_ca    : STD_LOGIC_vector (0 to astro_size-1):=(others => '0');
signal Iastro_spike : STD_LOGIC_vector (0 to astro_size-1):=(others => '0');

signal Iastro_out: STD_LOGIC_vector  (0 to Number_of_Neuron-1):=(others => '0');

signal divisor   : integer:=0;
signal divisor2   : integer:=0;
signal divisor_n : integer:=0;
signal divisor_b : integer:=0;
signal divisor_bc : integer:=0;
signal cao_indx  : integer range 0 to 25:=0;

signal clk_ca  : std_logic:='0';
signal clk_ca2 : std_logic:='0';
signal clk_bca : std_logic:='0';
signal tmp     : std_logic:='0';
signal tmp_ca2 : std_logic:='0';
signal clk_n   : std_logic:='0';
signal clk_b   : std_logic:='0';
signal tmp_n   : std_logic:='0';
signal tmp_b   : std_logic:='0';
signal tmp_bc  : std_logic:='0';
signal co_en   : std_logic:='0';

signal counterj1  : integer:=0;
signal counterj2  : integer:=0;
signal counterj3  : integer:=0;
signal counterj4  : integer:=0;
signal counterj5  : integer:=0;
signal counterj6  : integer:=0;
signal counterj7  : integer:=0;
signal counterj8  : integer:=0;
signal counterj9  : integer:=0;
signal counterj10 : integer:=0;
signal counterj11 : integer:=0;
signal counterj12 : integer:=0;
signal counterj13 : integer:=0;
signal counterj14 : integer:=0;
signal counterj15 : integer:=0;
signal counterj16 : integer:=0;
signal counterj17 : integer:=0;
signal counterj18 : integer:=0;
signal counterj19 : integer:=0;
signal counterj20 : integer:=0;
signal counterj21 : integer:=0;
signal counterj22 : integer:=0;
signal counterj23 : integer:=0;
signal counterj24 : integer:=0;
signal counterj25 : integer:=0;

signal r_counter : std_logic_vector(31 downto 0):=(others => '0');

signal reg1_CLK_ca : std_logic :='0';
signal reg2_CLK_ca : std_logic :='0';
signal reg3_CLK_ca : std_logic :='0';
signal   count_clk1    : integer range 0 to 5:=0;
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
COMPONENT Ca_module
Generic( Data_Width  : integer :=32;
             shift_param : integer :=24
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
end COMPONENT;
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
COMPONENT astro_nn
Generic( Data_Width: integer:=32;
         shift_param:integer:=16;
         Number_of_Neuron : integer := 100;
         astro_size:integer:=25 ;
         Clk_period : integer := 50);

    Port( clk           : in std_logic;
          enable        : in std_logic;
          Glu           : in std_logic_vector (Data_Width-1 downto 0); 
          G_indx        : in std_logic_vector (6 downto 0);
          Mask          : in std_logic;
          Iastro_spike  : out std_logic_vector (0 to astro_size-1);
          Iastro_neuron : out std_logic_vector (0 to astro_size-1)
         -- Iastro_ca:in std_logic_vector  (0 to astro_size-1)
         );
end COMPONENT;
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
COMPONENT multi_nn 
Generic(Data_Width       : integer := 32;
        shift_param      : integer := 16;
        Number_of_Neuron : integer := 100;
        Num_connection   : integer := 20;
        Clk_period : integer := 50
        );
    Port ( clk           : in STD_LOGIC;
           clk_s         : in STD_LOGIC;
           clk_n         : in STD_LOGIC;
           clk_b         : in std_logic;
           enable        : in STD_LOGIC;
           I_neuron      : in std_logic_vector (0 to Number_of_Neuron-1);
           T_test        : in std_logic;
           neuron_astro_indx   : in std_logic_vector (6 downto 0);
           Iastro_neuron : in STD_LOGIC_vector  (0 to Number_of_Neuron-1);
           Glu           : out STD_LOGIC_VECTOR (Data_Width-1 downto 0); 
           G_indx        : out STD_LOGIC_VECTOR (6 downto 0);    -- G_indx: out integer:=0;
           V_neuron      : out STD_LOGIC_VECTOR (Data_Width-1 downto 0);
           Glu_neuron    : out std_logic_vector (Data_Width-1 downto 0);
           Mask          : out STD_LOGIC
           );
end COMPONENT;
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
COMPONENT neuron_astro
    Port( clk_s        : in std_logic;
          enable       : in std_logic;
          ca_indx      : in std_logic_vector (3 downto 0);
          Iastro_spike : in std_logic_vector (0 to astro_size-1);
          Iastro_ca    : in std_logic_vector (0 to astro_size-1);
          Iastro_out   : out std_logic_vector (0 to Number_of_Neuron-1)
         );
end COMPONENT;
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

begin

process(clk)
 begin
 
 if(rising_edge(clk)) then
 divisor_n <= divisor_n + 1;
  if(divisor_n=9) then 
 divisor_n <= 0;
 tmp_n <= not tmp_n;
 end if;
 end if;
 end process;
clk_n <= tmp_n;
----------------------------------------------------------
process(clk)
 begin
  if(rising_edge(clk)) then
         divisor_b <= divisor_b + 1;
      if(divisor_b=2) then 
        divisor_b <= 0;
        tmp_b <= not tmp_b;
      end if;
    end if;
  end process;

clk_b <= tmp_b;
-------------------------------------------------------------------------------------------------------------

process(clk_n)
 begin
  if(rising_edge(clk_n)) then
         divisor <= divisor + 1;
      if(divisor=1) then 
        divisor <= 0;
        tmp <= not tmp;
      end if;
    end if;
 end process;
clk_ca <= tmp;

process(clk_n)
 begin
  if(rising_edge(clk_n)) then
    if(divisor2=0) then 
      divisor2 <= divisor2 + 1;
    elsif(divisor2=1) then 
      tmp_ca2 <= not tmp_ca2;
    end if;  
  end if;
 end process;
clk_ca2 <= tmp_ca2;
--------------------------------
process(clk_n)
 begin
  if(rising_edge(clk_n)) then
       divisor_bc <= divisor_bc + 1;
      if(divisor_bc=2) then 
        divisor_bc <= 0;
        tmp_bc <= not tmp_bc;
      end if;
    end if;
end process;

clk_bca <= tmp_bc;
-------------------------------------------------------------------------------------------------------------
U1:Ca_module
Generic map( Data_Width  => 32,
             shift_param => 24
                    )
    port map( CLK     => clk_ca,
              ca_i    => temp_ca,
              diff_ca => diff_tempc(shift_param+Data_Width-1 downto shift_param),
              ip_i    => temp_ip,
              diff_ip => diff_tempip(shift_param+Data_Width-1 downto shift_param),
              h_i     => temp_h,
              jglu    => Jglu,
              in_IP3  => ipo,
              Ca21    => cao,
              h_o     => ho
             );


U2:multi_nn
Generic map
       (Data_Width       => 32,
        shift_param      => 16,
        Number_of_Neuron => 100,
        Num_connection   => 20,
        Clk_period       => Clk_period
        )
    port map( clk           => clk,
              clk_s         => clk_s,
              clk_n         => clk_n,
              clk_b         => clk_b,
              enable        => enable,
              I_neuron      => I_neuron,
              T_test        => T_Test,
              neuron_astro_indx   => neuron_astro_indx,
              Iastro_neuron => Iastro_out,
              Glu           => Glu,
              G_indx        => G_indx,
              V_neuron      => V_n    ,
              Glu_neuron    => r_Glu_n ,
              Mask          => Mask
             );

U3:astro_nn
Generic map( Data_Width       => 32,
         shift_param      => 16,
         Number_of_Neuron => 100,
         astro_size       =>25 ,
         Clk_period     => Clk_period)
    port map( clk           => clk_n,
              enable        => enable,
              Glu           => Glu,
              G_indx        => G_indx,
              Mask          => Mask,
              Iastro_spike  => Iastro_spike,
              Iastro_neuron => Iastro_j
             );

U4:neuron_astro
    port map(clk_s        => clk,
             enable       => enable,
             ca_indx      => ca_indx,
             Iastro_spike => Iastro_spike,
             Iastro_ca    => Iastro_ca,
             Iastro_out   => Iastro_out
            );
-------------------------------------------------------------------------------------------------------------
ca_indx <= std_logic_vector(to_unsigned(ca_record_buffer,4));
-------------------------------------------------------------------------------------------------------------

process( clk_ca) --uo,
 begin
 if rising_edge(CLK_ca) then
  
    if ca_pp_prt=0 then
    
        ca_buffer1(ca_record_buffer)<= cao;
     
    else
   
        ca_buffer2(ca_record_buffer)<= cao;
      
    end if;
  end if;
end process;


process( clk_ca2) --uo,
 begin
 
    
    if rising_edge(clk_ca2) then 

    if ca_pp_prt=0 then
    
      temp_ca <= ca_buffer2 (ca_process_buffer);
    else
      
      temp_ca <= ca_buffer1 (ca_process_buffer);
    end if;
   
  end if;

end process;
------------------------------------------
process(clk_ca)  --enable, 
 begin
 if rising_edge(CLK_ca) then
   
 if ca_record_buffer < astro_size-1 then
     ca_record_buffer <= ca_record_buffer+1;--------- update counter
     else
     ca_record_buffer <= 0;
     if ca_pp_prt=0 then
       ca_pp_prt <=1;
       else
       ca_pp_prt <=0;
       end if;
 end if;
 if ca_process_buffer < astro_size-1 then
     ca_process_buffer <= ca_process_buffer+1;--------- update counter
     else
     ca_process_buffer <= 0;
     

 end if;
   end if;  
   
   end process; 
   

process (clk_ca) --uo,
 begin
 
   if rising_edge(CLK_ca) then
    
    if ca_pp_prt=0 then
    
        ip_buffer1(ca_record_buffer)<= ipo;
     
    else
   
        ip_buffer2(ca_record_buffer)<= ipo;
      
    end if;
  end if;
 

end process;


process(clk_ca2) --uo,
 begin

    if rising_edge(clk_ca2) then 
 
    if ca_pp_prt=0 then
    
      temp_ip <= ip_buffer2 (ca_process_buffer);
    else
      
      temp_ip <= ip_buffer1 (ca_process_buffer);
  
  end if;
  end if;
 
end process;
 
 ------------------
 process(clk_ca) 
  begin
  
    if rising_edge(CLK_ca) then
     
     if ca_pp_prt=0 then
     
         h_buffer1(ca_record_buffer)<= ho;
      
     else
    
         h_buffer2(ca_record_buffer)<= ho;
       
     end if;
   end if;
  end process;
 
 
 process(clk_ca2) 
  begin
       if rising_edge(clk_ca2) then 

     if ca_pp_prt=0 then
     
       temp_h <= h_buffer2 (ca_process_buffer);
     else
       
       temp_h <= h_buffer1 (ca_process_buffer);
     end if;
    end if;
 end process;
 ----------------------------------------------

 process(enable,clk) 
  begin
  if (enable='0') then
    Iastro_ca <= (others => '0');
  else
    if rising_edge(clk) then
      if (ca_pp_prt=0) then
       if ca_buffer1(ca_record_buffer) > ca_thr then
       Iastro_ca (ca_record_buffer) <= '1';
       else
      Iastro_ca (ca_record_buffer) <= '0';
      end if;
      else
      if ca_buffer2(ca_record_buffer) > ca_thr then
        Iastro_ca (ca_record_buffer) <= '1';
        else
       Iastro_ca (ca_record_buffer) <= '0';
       end if;
      end if;
    end if;
  end if;   
 end process;
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------

process (enable, clk_ca2)
begin
if (enable='0') then 
ca_diff <= (others => (others => '0'));
ip_diff <= (others => (others => '0'));
else

if rising_edge(clk_ca2) then
if (ca_pp_prt=0) then

ca_diff (0) <= ca_buffer2(1)+ca_buffer2(5)-ca_buffer2(0)-ca_buffer2(0);
ip_diff(0)<= (ip_buffer2(1)+ip_buffer2(5)-ip_buffer2(0)-ip_buffer2(0));

ca_diff(1) <= (ca_buffer2(0)+ca_buffer2(6)+ca_buffer2(2)-ca_buffer2(1)-ca_buffer2(1)-ca_buffer2(1));
ip_diff(1) <= (ip_buffer2(0)+ip_buffer2(6)+ip_buffer2(2)-ip_buffer2(1)-ip_buffer2(1)-ip_buffer2(1));

 ca_diff(2) <= ca_buffer2(1)+ca_buffer2(3)+ca_buffer2(7)-ca_buffer2(2)-ca_buffer2(2)-ca_buffer2(2);
 ip_diff(2) <= ip_buffer2(1)+ip_buffer2(3)+ip_buffer2(7)-ip_buffer2(2)-ip_buffer2(2)-ip_buffer2(2);

ca_diff(3) <= ca_buffer2(2)+ca_buffer2(8)+ca_buffer2(4)-ca_buffer2(3)-ca_buffer2(3)-ca_buffer2(3); 
ip_diff(3) <= ip_buffer2(2)+ip_buffer2(8)+ip_buffer2(4)-ip_buffer2(3)-ip_buffer2(3)-ip_buffer2(3); 
                                                                                                 
ca_diff(4) <= ca_buffer2(3)+ca_buffer2(9)-ca_buffer2(4)-ca_buffer2(4); 
ip_diff(4) <= ip_buffer2(3)+ip_buffer2(9)-ip_buffer2(4)-ip_buffer2(4); 
                                                                                                 
ca_diff(5) <= ca_buffer2(0)+ca_buffer2(6)+ca_buffer2(10)-ca_buffer2(5)-ca_buffer2(5)-ca_buffer2(5);
ip_diff(5) <= ip_buffer2(0)+ip_buffer2(6)+ip_buffer2(10)-ip_buffer2(5)-ip_buffer2(5)-ip_buffer2(5); 

ca_diff(6) <= ca_buffer2(5)+ca_buffer2(1)+ca_buffer2(7)+ca_buffer2(11)-ca_buffer2(6)-ca_buffer2(6)-ca_buffer2(6)-ca_buffer2(6);
ip_diff(6) <= ip_buffer2(5)+ip_buffer2(1)+ip_buffer2(7)+ip_buffer2(11)-ip_buffer2(6)-ip_buffer2(6)-ip_buffer2(6)-ip_buffer2(6);
                                                                                                
ca_diff(7) <= ca_buffer2(6)+ca_buffer2(2)+ca_buffer2(8)+ca_buffer2(12)-ca_buffer2(7)-ca_buffer2(7)-ca_buffer2(7)-ca_buffer2(7);
ip_diff(7) <= ip_buffer2(6)+ip_buffer2(2)+ip_buffer2(8)+ip_buffer2(12)-ip_buffer2(7)-ip_buffer2(7)-ip_buffer2(7)-ip_buffer2(7);
                                                                                                
ca_diff(8) <= ca_buffer2(7)+ca_buffer2(3)+ca_buffer2(9)+ca_buffer2(13)-ca_buffer2(8)-ca_buffer2(8)-ca_buffer2(8)-ca_buffer2(8);
ip_diff(8) <= ip_buffer2(7)+ip_buffer2(3)+ip_buffer2(9)+ip_buffer2(13)-ip_buffer2(8)-ip_buffer2(8)-ip_buffer2(8)-ip_buffer2(8);
--------------------------------
ca_diff (9) <= ca_buffer2(4)+ca_buffer2(8)+ca_buffer2(14)-ca_buffer2(9)-ca_buffer2(9)-ca_buffer2(9);
ip_diff(9)<= (ip_buffer2(4)+ip_buffer2(8)+ip_buffer2(14)-ip_buffer2(9)-ip_buffer2(9)-ip_buffer2(9));

ca_diff(10) <= (ca_buffer2(5)+ca_buffer2(11)+ca_buffer2(15)-ca_buffer2(10)-ca_buffer2(10)-ca_buffer2(10));
ip_diff(10) <= (ip_buffer2(5)+ip_buffer2(11)+ip_buffer2(15)-ip_buffer2(10)-ip_buffer2(10)-ip_buffer2(10));

 ca_diff(11) <= ca_buffer2(10)+ca_buffer2(6)+ca_buffer2(12)+ca_buffer2(16)-ca_buffer2(11)-ca_buffer2(11)-ca_buffer2(11)-ca_buffer2(11);
 ip_diff(11) <= ip_buffer2(10)+ip_buffer2(6)+ip_buffer2(12)+ip_buffer2(16)-ip_buffer2(11)-ip_buffer2(11)-ip_buffer2(11)-ip_buffer2(11);

ca_diff(12) <= ca_buffer2(11)+ca_buffer2(7)+ca_buffer2(13)+ca_buffer2(17)-ca_buffer2(12)-ca_buffer2(12)-ca_buffer2(12)-ca_buffer2(12); 
ip_diff(12) <= ip_buffer2(11)+ip_buffer2(7)+ip_buffer2(13)+ip_buffer2(17)-ip_buffer2(12)-ip_buffer2(12)-ip_buffer2(12)-ip_buffer2(12); 
                                                                                                 
ca_diff(13) <= ca_buffer2(12)+ca_buffer2(8)+ca_buffer2(14)+ca_buffer2(18)-ca_buffer2(13)-ca_buffer2(13)-ca_buffer2(13)-ca_buffer2(13); 
ip_diff(13) <= ip_buffer2(12)+ip_buffer2(8)+ip_buffer2(14)+ip_buffer2(18)-ip_buffer2(13)-ip_buffer2(13)-ip_buffer2(13)-ip_buffer2(13); 
                                                                                                 
ca_diff(14) <= ca_buffer2(9)+ca_buffer2(13)+ca_buffer2(19)-ca_buffer2(14)-ca_buffer2(14)-ca_buffer2(14);
ip_diff(14) <= ip_buffer2(9)+ip_buffer2(13)+ip_buffer2(19)-ip_buffer2(14)-ip_buffer2(14)-ip_buffer2(14); 

ca_diff(15) <= ca_buffer2(10)+ca_buffer2(16)+ca_buffer2(20)-ca_buffer2(15)-ca_buffer2(15)-ca_buffer2(15);
ip_diff(15) <= ip_buffer2(10)+ip_buffer2(16)+ip_buffer2(20)-ip_buffer2(15)-ip_buffer2(15)-ip_buffer2(15);
                                                                                                
ca_diff(16) <= ca_buffer2(15)+ca_buffer2(11)+ca_buffer2(17)+ca_buffer2(21)-ca_buffer2(16)-ca_buffer2(16)-ca_buffer2(16)-ca_buffer2(16);
ip_diff(16) <= ip_buffer2(15)+ip_buffer2(11)+ip_buffer2(17)+ip_buffer2(21)-ip_buffer2(16)-ip_buffer2(16)-ip_buffer2(16)-ip_buffer2(16);
                                                                                                
ca_diff(17) <= ca_buffer2(16)+ca_buffer2(12)+ca_buffer2(18)+ca_buffer2(22)-ca_buffer2(17)-ca_buffer2(17)-ca_buffer2(17)-ca_buffer2(17);
ip_diff(17) <=ip_buffer2(16)+ip_buffer2(12)+ip_buffer2(18)+ip_buffer2(22)-ip_buffer2(17)-ip_buffer2(17)-ip_buffer2(17)-ip_buffer2(17);

ca_diff (18) <= ca_buffer2(17)+ca_buffer2(13)+ca_buffer2(19)+ca_buffer2(23)-ca_buffer2(18)-ca_buffer2(18)-ca_buffer2(18)-ca_buffer2(18);
ip_diff(18) <= ip_buffer2(17)+ip_buffer2(13)+ip_buffer2(19)+ip_buffer2(23)-ip_buffer2(18)-ip_buffer2(18)-ip_buffer2(18)-ip_buffer2(18);

ca_diff(19) <= (ca_buffer2(14)+ca_buffer2(18)+ca_buffer2(24)-ca_buffer2(19)-ca_buffer2(19)-ca_buffer2(19));
ip_diff(19) <= (ip_buffer2(14)+ip_buffer2(18)+ip_buffer2(24)-ip_buffer2(19)-ip_buffer2(19)-ip_buffer2(19));

 ca_diff(20) <= ca_buffer2(15)+ca_buffer2(21)-ca_buffer2(20)-ca_buffer2(20);
 ip_diff(20) <= ip_buffer2(15)+ip_buffer2(21)-ip_buffer2(20)-ip_buffer2(20);

ca_diff(21) <= ca_buffer2(20)+ca_buffer2(16)+ca_buffer2(22)-ca_buffer2(21)-ca_buffer2(21)-ca_buffer2(21);
ip_diff(21) <=ip_buffer2(20)+ip_buffer2(16)+ip_buffer2(22)-ip_buffer2(21)-ip_buffer2(21)-ip_buffer2(21);
                                                                                                 
ca_diff(22) <= ca_buffer2(21)+ca_buffer2(17)+ca_buffer2(23)-ca_buffer2(22)-ca_buffer2(22)-ca_buffer2(22); 
ip_diff(22) <= ip_buffer2(21)+ip_buffer2(17)+ip_buffer2(23)-ip_buffer2(22)-ip_buffer2(22)-ip_buffer2(22); 
                                                                                                 
ca_diff(23) <= ca_buffer2(18)+ca_buffer2(22)+ca_buffer2(24)-ca_buffer2(23)-ca_buffer2(23)-ca_buffer2(23);
ip_diff(23) <= ip_buffer2(18)+ip_buffer2(22)+ip_buffer2(24)-ip_buffer2(23)-ip_buffer2(23)-ip_buffer2(23); 

ca_diff(24) <= ca_buffer2(19)+ca_buffer2(23)-ca_buffer2(24)-ca_buffer2(24);
ip_diff(24) <= ip_buffer2(19)+ip_buffer2(23)-ip_buffer2(24)-ip_buffer2(24);
                                                                                                


else
ca_diff (0) <= ca_buffer1(1)+ca_buffer1(5)-ca_buffer1(0)-ca_buffer1(0);
ip_diff(0)<= (ip_buffer1(1)+ip_buffer1(5)-ip_buffer1(0)-ip_buffer1(0));

ca_diff(1) <= (ca_buffer1(0)+ca_buffer1(6)+ca_buffer1(2)-ca_buffer1(1)-ca_buffer1(1)-ca_buffer1(1));
ip_diff(1) <= (ip_buffer1(0)+ip_buffer1(6)+ip_buffer1(2)-ip_buffer1(1)-ip_buffer1(1)-ip_buffer1(1));

 ca_diff(2) <= ca_buffer1(1)+ca_buffer1(3)+ca_buffer1(7)-ca_buffer1(2)-ca_buffer1(2)-ca_buffer1(2);
 ip_diff(2) <= ip_buffer1(1)+ip_buffer1(3)+ip_buffer1(7)-ip_buffer1(2)-ip_buffer1(2)-ip_buffer1(2);

ca_diff(3) <= ca_buffer1(2)+ca_buffer1(8)+ca_buffer1(4)-ca_buffer1(3)-ca_buffer1(3)-ca_buffer1(3); 
ip_diff(3) <= ip_buffer1(2)+ip_buffer1(8)+ip_buffer1(4)-ip_buffer1(3)-ip_buffer1(3)-ip_buffer1(3); 
                                                                                                 
ca_diff(4) <= ca_buffer1(3)+ca_buffer1(9)-ca_buffer1(4)-ca_buffer1(4); 
ip_diff(4) <= ip_buffer1(3)+ip_buffer1(9)-ip_buffer1(4)-ip_buffer1(4); 
                                                                                                 
ca_diff(5) <= ca_buffer1(0)+ca_buffer1(6)+ca_buffer1(10)-ca_buffer1(5)-ca_buffer1(5)-ca_buffer1(5);
ip_diff(5) <= ip_buffer1(0)+ip_buffer1(6)+ip_buffer1(10)-ip_buffer1(5)-ip_buffer1(5)-ip_buffer1(5); 

ca_diff(6) <= ca_buffer1(5)+ca_buffer1(1)+ca_buffer1(7)+ca_buffer1(11)-ca_buffer1(6)-ca_buffer1(6)-ca_buffer1(6)-ca_buffer1(6);
ip_diff(6) <= ip_buffer1(5)+ip_buffer1(1)+ip_buffer1(7)+ip_buffer1(11)-ip_buffer1(6)-ip_buffer1(6)-ip_buffer1(6)-ip_buffer1(6);
                                                                                                
ca_diff(7) <= ca_buffer1(6)+ca_buffer1(2)+ca_buffer1(8)+ca_buffer1(12)-ca_buffer1(7)-ca_buffer1(7)-ca_buffer1(7)-ca_buffer1(7);
ip_diff(7) <= ip_buffer1(6)+ip_buffer1(2)+ip_buffer1(8)+ip_buffer1(12)-ip_buffer1(7)-ip_buffer1(7)-ip_buffer1(7)-ip_buffer1(7);
                                                                                                
ca_diff(8) <= ca_buffer1(7)+ca_buffer1(3)+ca_buffer1(9)+ca_buffer1(13)-ca_buffer1(8)-ca_buffer1(8)-ca_buffer1(8)-ca_buffer1(8);
ip_diff(8) <= ip_buffer1(7)+ip_buffer1(3)+ip_buffer1(9)+ip_buffer1(13)-ip_buffer1(8)-ip_buffer1(8)-ip_buffer1(8)-ip_buffer1(8);
--------------------------------
ca_diff (9) <= ca_buffer1(4)+ca_buffer1(8)+ca_buffer1(14)-ca_buffer1(9)-ca_buffer1(9)-ca_buffer1(9);
ip_diff(9)<= (ip_buffer1(4)+ip_buffer1(8)+ip_buffer1(14)-ip_buffer1(9)-ip_buffer1(9)-ip_buffer1(9));

ca_diff(10) <= (ca_buffer1(5)+ca_buffer1(11)+ca_buffer1(15)-ca_buffer1(10)-ca_buffer1(10)-ca_buffer1(10));
ip_diff(10) <= (ip_buffer1(5)+ip_buffer1(11)+ip_buffer1(15)-ip_buffer1(10)-ip_buffer1(10)-ip_buffer1(10));

 ca_diff(11) <= ca_buffer1(10)+ca_buffer1(6)+ca_buffer1(12)+ca_buffer1(16)-ca_buffer1(11)-ca_buffer1(11)-ca_buffer1(11)-ca_buffer1(11);
 ip_diff(11) <= ip_buffer1(10)+ip_buffer1(6)+ip_buffer1(12)+ip_buffer1(16)-ip_buffer1(11)-ip_buffer1(11)-ip_buffer1(11)-ip_buffer1(11);

ca_diff(12) <= ca_buffer1(11)+ca_buffer1(7)+ca_buffer1(13)+ca_buffer1(17)-ca_buffer1(12)-ca_buffer1(12)-ca_buffer1(12)-ca_buffer1(12); 
ip_diff(12) <= ip_buffer1(11)+ip_buffer1(7)+ip_buffer1(13)+ip_buffer1(17)-ip_buffer1(12)-ip_buffer1(12)-ip_buffer1(12)-ip_buffer1(12); 
                                                                                                 
ca_diff(13) <= ca_buffer1(12)+ca_buffer1(8)+ca_buffer1(14)+ca_buffer1(18)-ca_buffer1(13)-ca_buffer1(13)-ca_buffer1(13)-ca_buffer1(13); 
ip_diff(13) <= ip_buffer1(12)+ip_buffer1(8)+ip_buffer1(14)+ip_buffer1(18)-ip_buffer1(13)-ip_buffer1(13)-ip_buffer1(13)-ip_buffer1(13); 
                                                                                                 
ca_diff(14) <= ca_buffer1(9)+ca_buffer1(13)+ca_buffer1(19)-ca_buffer1(14)-ca_buffer1(14)-ca_buffer1(14);
ip_diff(14) <= ip_buffer1(9)+ip_buffer1(13)+ip_buffer1(19)-ip_buffer1(14)-ip_buffer1(14)-ip_buffer1(14); 

ca_diff(15) <= ca_buffer1(10)+ca_buffer1(16)+ca_buffer1(20)-ca_buffer1(15)-ca_buffer1(15)-ca_buffer1(15);
ip_diff(15) <= ip_buffer1(10)+ip_buffer1(16)+ip_buffer1(20)-ip_buffer1(15)-ip_buffer1(15)-ip_buffer1(15);
                                                                                                
ca_diff(16) <= ca_buffer1(15)+ca_buffer1(11)+ca_buffer1(17)+ca_buffer1(21)-ca_buffer1(16)-ca_buffer1(16)-ca_buffer1(16)-ca_buffer1(16);
ip_diff(16) <= ip_buffer1(15)+ip_buffer1(11)+ip_buffer1(17)+ip_buffer1(21)-ip_buffer1(16)-ip_buffer1(16)-ip_buffer1(16)-ip_buffer1(16);
                                                                                                
ca_diff(17) <= ca_buffer1(16)+ca_buffer1(12)+ca_buffer1(18)+ca_buffer1(22)-ca_buffer1(17)-ca_buffer1(17)-ca_buffer1(17)-ca_buffer1(17);
ip_diff(17) <=ip_buffer1(16)+ip_buffer1(12)+ip_buffer1(18)+ip_buffer1(22)-ip_buffer1(17)-ip_buffer1(17)-ip_buffer1(17)-ip_buffer1(17);

ca_diff (18) <= ca_buffer1(17)+ca_buffer1(13)+ca_buffer1(19)+ca_buffer1(23)-ca_buffer1(18)-ca_buffer1(18)-ca_buffer1(18)-ca_buffer1(18);
ip_diff(18) <= ip_buffer1(17)+ip_buffer1(13)+ip_buffer1(19)+ip_buffer1(23)-ip_buffer1(18)-ip_buffer1(18)-ip_buffer1(18)-ip_buffer1(18);

ca_diff(19) <= (ca_buffer1(14)+ca_buffer1(18)+ca_buffer1(24)-ca_buffer1(19)-ca_buffer1(19)-ca_buffer1(19));
ip_diff(19) <= (ip_buffer1(14)+ip_buffer1(18)+ip_buffer1(24)-ip_buffer1(19)-ip_buffer1(19)-ip_buffer1(19));

 ca_diff(20) <= ca_buffer1(15)+ca_buffer1(21)-ca_buffer1(20)-ca_buffer1(20);
 ip_diff(20) <= ip_buffer1(15)+ip_buffer1(21)-ip_buffer1(20)-ip_buffer1(20);

ca_diff(21) <= ca_buffer1(20)+ca_buffer1(16)+ca_buffer1(22)-ca_buffer1(21)-ca_buffer1(21)-ca_buffer1(21);
ip_diff(21) <=ip_buffer1(20)+ip_buffer1(16)+ip_buffer1(22)-ip_buffer1(21)-ip_buffer1(21)-ip_buffer1(21);
                                                                                                 
ca_diff(22) <= ca_buffer1(21)+ca_buffer1(17)+ca_buffer1(23)-ca_buffer1(22)-ca_buffer1(22)-ca_buffer1(22); 
ip_diff(22) <= ip_buffer1(21)+ip_buffer1(17)+ip_buffer1(23)-ip_buffer1(22)-ip_buffer1(22)-ip_buffer1(22); 
                                                                                                 
ca_diff(23) <= ca_buffer1(18)+ca_buffer1(22)+ca_buffer1(24)-ca_buffer1(23)-ca_buffer1(23)-ca_buffer1(23);
ip_diff(23) <= ip_buffer1(18)+ip_buffer1(22)+ip_buffer1(24)-ip_buffer1(23)-ip_buffer1(23)-ip_buffer1(23); 

ca_diff(24) <= ca_buffer1(19)+ca_buffer1(23)-ca_buffer1(24)-ca_buffer1(24);
ip_diff(24) <= ip_buffer1(19)+ip_buffer1(23)-ip_buffer1(24)-ip_buffer1(24);

    end if;
  end if;
 end if;
end process;

process (clk_ca2)
begin 
  if rising_edge(clk_ca2) then
    diff_tempc <= ca_diff(ca_process_buffer)*dtca;
    diff_tempip <= (ip_diff(ca_process_buffer))*dtip;
    jglu <=J_glu(ca_process_buffer);
  end if;  
end process;

 process(enable, clk) --uo,
 begin
 if (enable='0') then
    J_glu <= (others => (others => '0'));
    counterj1<= 0;
    Iastro_neuronca1 <= '0';
    counterj2<= 0;
    Iastro_neuronca2 <= '0';
    counterj3<= 0;
    Iastro_neuronca3 <= '0';
    counterj4<= 0;
    Iastro_neuronca4 <= '0';
    counterj5<= 0;
    Iastro_neuronca5 <= '0';
    counterj6<= 0;
    Iastro_neuronca6 <= '0';
    counterj7<= 0;
    Iastro_neuronca7 <= '0';
    counterj8<= 0;
    Iastro_neuronca8 <= '0';
    counterj9<= 0;
    Iastro_neuronca9 <= '0';
    counterj10<= 0;
    Iastro_neuronca10 <= '0';
    counterj11<= 0;
    Iastro_neuronca11 <= '0';
    counterj12<= 0;
    Iastro_neuronca12 <= '0';
    counterj13<= 0;
    Iastro_neuronca13 <= '0';
    counterj14<= 0;
    Iastro_neuronca14 <= '0';
    counterj15<= 0;
    Iastro_neuronca15 <= '0';
    counterj16<= 0;
    Iastro_neuronca16 <= '0';
    counterj17<= 0;
    Iastro_neuronca17 <= '0';
    counterj18<= 0;
    Iastro_neuronca18 <= '0';
    counterj19<= 0;
    Iastro_neuronca19 <= '0';
    counterj20<= 0;
    Iastro_neuronca20 <= '0';
    counterj21<= 0;
    Iastro_neuronca21 <= '0';
    counterj22<= 0;
    Iastro_neuronca22 <= '0';
    counterj23<= 0;
    Iastro_neuronca23 <= '0';
    counterj24<= 0;
    Iastro_neuronca24 <= '0';
    counterj25<= 0;
    Iastro_neuronca25 <= '0';
 else
 
if rising_edge (clk) then
if Iastro_j(0)='1' then 
Iastro_neuronca1 <= '1';
end if;

if Iastro_neuronca1='1' then 
if counterj1 < 600 then
counterj1<= counterj1+1;
J_glu(0) <= J_astron;
else
counterj1<= 0;
J_glu(0) <= (others => '0');
Iastro_neuronca1 <= '0';
end if;
end if;


if Iastro_j(1)='1' then 
Iastro_neuronca2 <= '1';
end if;

if Iastro_neuronca2='1' then 
if counterj2 < 600 then
counterj2<= counterj2+1;
J_glu(1) <= J_astron;
else
counterj2<= 0;
J_glu(1) <= (others => '0');
Iastro_neuronca2 <= '0';
end if;
end if;

if Iastro_j(2)='1' then 
Iastro_neuronca3 <= '1';
end if;

if Iastro_neuronca3='1' then 
if counterj3 < 600 then
counterj3<= counterj3+1;
J_glu(2) <= J_astron;
else
counterj3<= 0;
J_glu(2) <= (others => '0');
Iastro_neuronca3 <= '0';
end if;
end if;

if Iastro_j(3)='1' then 
Iastro_neuronca4 <= '1';
end if;

if Iastro_neuronca4='1' then 
if counterj4 < 600 then
counterj4<= counterj4+1;
J_glu(3) <= J_astron;
else
counterj4<= 0;
J_glu(3) <= (others => '0');
Iastro_neuronca4 <= '0';
end if;
end if;

if Iastro_j(4)='1' then 
Iastro_neuronca5 <= '1';
end if;

if Iastro_neuronca5='1' then 
if counterj5 < 600 then
counterj5<= counterj5+1;
J_glu(4) <= J_astron;
else
counterj5<= 0;
J_glu(4) <= (others => '0');
Iastro_neuronca5 <= '0';
end if;
end if;



if Iastro_j(5)='1' then 
Iastro_neuronca6 <= '1';
end if;

if Iastro_neuronca6='1' then 
if counterj6 < 600 then
counterj6<= counterj6+1;
J_glu(5) <= J_astron;
else
counterj6<= 0;
J_glu(5) <= (others => '0');
Iastro_neuronca6 <= '0';
end if;
end if;


if Iastro_j(6)='1' then 
Iastro_neuronca7 <= '1';
end if;

if Iastro_neuronca7='1' then 
if counterj7 < 600 then
counterj7<= counterj7+1;
J_glu(6) <= J_astron;
else
counterj7<= 0;
J_glu(6) <= (others => '0');
Iastro_neuronca7 <= '0';
end if;
end if;


if Iastro_j(7)='1' then 
Iastro_neuronca8 <= '1';
end if;

if Iastro_neuronca8='1' then 
if counterj8 < 600 then
counterj8<= counterj8+1;
J_glu(7) <= J_astron;
else
counterj8<= 0;
J_glu(7) <= (others => '0');
Iastro_neuronca8 <= '0';
end if;
end if;


if Iastro_j(8)='1' then 
Iastro_neuronca9 <= '1';
end if;

if Iastro_neuronca9='1' then 
if counterj9 < 600 then
counterj9<= counterj9+1;
J_glu(8) <= J_astron;
else
counterj9<= 0;
J_glu(8) <= (others => '0');
Iastro_neuronca9 <= '0';
end if;
end if;
-------------------------------------------
if Iastro_j(9)='1' then 
Iastro_neuronca10 <= '1';
end if;

if Iastro_neuronca10='1' then 
if counterj10 < 600 then
counterj10<= counterj10+1;
J_glu(9) <= J_astron;
else
counterj10<= 0;
J_glu(9) <= (others => '0');
Iastro_neuronca10 <= '0';
end if;
end if;


if Iastro_j(10)='1' then 
Iastro_neuronca11 <= '1';
end if;

if Iastro_neuronca11='1' then 
if counterj11 < 600 then
counterj11<= counterj11+1;
J_glu(10) <= J_astron;
else
counterj11<= 0;
J_glu(10) <= (others => '0');
Iastro_neuronca11 <= '0';
end if;
end if;

if Iastro_j(11)='1' then 
Iastro_neuronca12 <= '1';
end if;

if Iastro_neuronca12='1' then 
if counterj12 < 600 then
counterj12<= counterj12+1;
J_glu(11) <= J_astron;
else
counterj12<= 0;
J_glu(11) <= (others => '0');
Iastro_neuronca12 <= '0';
end if;
end if;

if Iastro_j(12)='1' then 
Iastro_neuronca13 <= '1';
end if;

if Iastro_neuronca13='1' then 
if counterj13 < 600 then
counterj13<= counterj13+1;
J_glu(12) <= J_astron;
else
counterj13<= 0;
J_glu(12) <= (others => '0');
Iastro_neuronca13 <= '0';
end if;
end if;

if Iastro_j(13)='1' then 
Iastro_neuronca14 <= '1';
end if;

if Iastro_neuronca14='1' then 
if counterj14 < 600 then
counterj14<= counterj14+1;
J_glu(13) <= J_astron;
else
counterj14<= 0;
J_glu(13) <= (others => '0');
Iastro_neuronca14 <= '0';
end if;
end if;



if Iastro_j(14)='1' then 
Iastro_neuronca15 <= '1';
end if;

if Iastro_neuronca15='1' then 
if counterj15 < 600 then
counterj15<= counterj15+1;
J_glu(14) <= J_astron;
else
counterj15<= 0;
J_glu(14) <= (others => '0');
Iastro_neuronca15 <= '0';
end if;
end if;


if Iastro_j(15)='1' then 
Iastro_neuronca16 <= '1';
end if;

if Iastro_neuronca16='1' then 
if counterj16 < 600 then
counterj16<= counterj16+1;
J_glu(15) <= J_astron;
else
counterj16<= 0;
J_glu(15) <= (others => '0');
Iastro_neuronca16 <= '0';
end if;
end if;


if Iastro_j(16)='1' then 
Iastro_neuronca17 <= '1';
end if;

if Iastro_neuronca17='1' then 
if counterj17 < 600 then
counterj17<= counterj17+1;
J_glu(16) <= J_astron;
else
counterj17<= 0;
J_glu(16) <= (others => '0');
Iastro_neuronca17 <= '0';
end if;
end if;


if Iastro_j(17)='1' then 
Iastro_neuronca18 <= '1';
end if;

if Iastro_neuronca18='1' then 
if counterj18 < 600 then
counterj18<= counterj18+1;
J_glu(17) <= J_astron;
else
counterj18<= 0;
J_glu(17) <= (others => '0');
Iastro_neuronca18 <= '0';
end if;
end if;


if Iastro_j(18)='1' then 
Iastro_neuronca19 <= '1';
end if;

if Iastro_neuronca19='1' then 
if counterj19 < 600 then
counterj19<= counterj19+1;
J_glu(18) <= J_astron;
else
counterj19<= 0;
J_glu(18) <= (others => '0');
Iastro_neuronca19 <= '0';
end if;
end if;



if Iastro_j(19)='1' then 
Iastro_neuronca20 <= '1';
end if;

if Iastro_neuronca20='1' then 
if counterj20 < 600 then
counterj20<= counterj20+1;
J_glu(19) <= J_astron;
else
counterj20<= 0;
J_glu(19) <= (others => '0');
Iastro_neuronca20 <= '0';
end if;
end if;


if Iastro_j(20)='1' then 
Iastro_neuronca21 <= '1';
end if;

if Iastro_neuronca21='1' then 
if counterj21 < 600 then
counterj21<= counterj21+1;
J_glu(20) <= J_astron;
else
counterj21<= 0;
J_glu(20) <= (others => '0');
Iastro_neuronca21 <= '0';
end if;
end if;


if Iastro_j(21)='1' then 
Iastro_neuronca22 <= '1';
end if;

if Iastro_neuronca22='1' then 
if counterj22 < 600 then
counterj22<= counterj22+1;
J_glu(21) <= J_astron;
else
counterj22<= 0;
J_glu(21) <= (others => '0');
Iastro_neuronca22 <= '0';
end if;
end if;


if Iastro_j(22)='1' then 
Iastro_neuronca23 <= '1';
end if;

if Iastro_neuronca23='1' then 
if counterj23 < 600 then
counterj23<= counterj23+1;
J_glu(22) <= J_astron;
else
counterj23<= 0;
J_glu(22) <= (others => '0');
Iastro_neuronca23 <= '0';
end if;
end if;

if Iastro_j(23)='1' then 
Iastro_neuronca24 <= '1';
end if;

if Iastro_neuronca24='1' then 
if counterj24 < 600 then
counterj24<= counterj24+1;
J_glu(23) <= J_astron;
else
counterj24<= 0;
J_glu(23) <= (others => '0');
Iastro_neuronca24 <= '0';
end if;
end if;


if Iastro_j(24)='1' then 
Iastro_neuronca25 <= '1';
end if;

if Iastro_neuronca25='1' then 
if counterj25 < 600 then
counterj25<= counterj25+1;
J_glu(24) <= J_astron;
else
counterj25<= 0;
J_glu(24) <= (others => '0');
Iastro_neuronca25 <= '0';
end if;
end if;
end if;

------------------------
end if;
end process;
-------------------------------------------------------------------------------------------------------------

Ca_astro   <=   ca_buffer2(to_integer(unsigned(neuron_astro_indx)));
ip3_astro  <=   ip_buffer2(to_integer(unsigned(neuron_astro_indx))); 

--------------------------------------------------------------------------------------------------------------------  
V_neuron      <= V_n ;
Glu_neuron    <= r_Glu_n ;


end Behavioral;