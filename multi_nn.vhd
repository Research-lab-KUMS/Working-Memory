library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;
use work.buffer_type.all;
use work.wm_package.all;
--------------------------------------------------------------------------------------------------------------------
entity multi_nn is
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
end multi_nn;
--------------------------------------------------------------------------------------------------------------------

architecture Behavioral of multi_nn is

constant r_indx : integer :=5;   -- 5 , 47 , 43 , 65

constant astro_size : integer :=25;
constant I_train    : std_logic_vector(Data_width-1 downto 0):=X"000A0000";
constant I_test     : std_logic_vector(Data_width-1 downto 0):=X"00080000";

signal I    : std_logic_vector(Data_width-1 downto 0):=(others =>'0');
signal i_in : STD_LOGIC_VECTOR (Data_width-1 downto 0):=(others =>'0');
signal Iapp : STD_LOGIC_VECTOR (Data_width-1 downto 0):=(others =>'0');
  
signal temp_v : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others =>'0');
signal temp_u : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others =>'0');
signal temp_g : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others =>'0');
signal vo     : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others =>'0');
signal uo     : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others =>'0');
signal go     : STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others =>'0');
------------------------------ping pong signals v ----------------
signal v_buffer1 : t_FIFO_DATA := (others => (others => '0'));
signal v_buffer2 : t_FIFO_DATA := (others => (others => '0'));
signal v_process_buffer : integer range 0 to Number_of_Neuron:=0 ;
signal v_record_buffer  : integer range 0 to Number_of_Neuron:=0 ;
signal v_pp_prt         : integer range 0 to Number_of_Neuron:=0 ;
signal r_neuron_indx    : integer range 0 to Number_of_Neuron:=0 ;
 ---------------------- u &g  buffer----------------
signal u_buffer1: t_FIFO_DATA := (others => (others => '0'));
signal u_buffer2: t_FIFO_DATA := (others => (others => '0'));
 
signal g_buffer1: t_FIFO_DATA := (others => (others => '0'));
signal g_buffer2: t_FIFO_DATA := (others => (others => '0'));
 ------------------------Isyn ppfifo
signal Isyn_post1:t_FIFO_DATA :=(others => (others => '0'));
signal Isyn_post2:t_FIFO_DATA :=(others => (others => '0'));

signal   Isyn_process_buffer : integer range 0 to data_depth-1:=0 ;
signal   Isyn_record_buffer  : integer range 0 to data_depth-1:=0 ;
signal   Isyn_pp_prt         : integer range 0 to data_depth-1:=0 ;

----------------------------------

signal   INDX         : integer range 0 to Num_connection *Number_of_Neuron:=1 ;
signal   INDX_t       : integer range 0 to Number_of_Neuron:=1;
signal   count_clk    : integer range 0 to 5:=0;
--------------------------------------------------------- 
signal   syn_counter : integer range 0 to Num_connection:=0;
---------------------------------------- 
signal V_Pre: STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others => '0');
signal V_Post :  STD_LOGIC_VECTOR (Data_Width-1 downto 0):=(others => '0');

----------------------------------------
signal Io_syn : STD_LOGIC_VECTOR (Data_width-1 downto 0):=(others =>'0');

----------------------------------------------------------------
signal Iastro_post : STD_LOGIC := '0' ;

 -------------------------------------------
signal valid_v:std_logic:='0';
signal valid_I:std_logic:='0';
signal valid_u:std_logic:='0';
signal valid_g:std_logic:='0';
--------------------------------------------
signal vo_indx: integer range 0 to Number_of_Neuron:=1;
--------------------------------------------------------------------------------------------------------------------
component Neuron_Izh is
    Generic(Data_Width: integer:=32;
    shift_param:integer:=16;
     Clk_period : integer := 50);
     Port ( clk : in STD_LOGIC;
               enable : in STD_LOGIC;
               I : in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
               V_in : in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
               valid_vin :in std_logic;
               V_out : out STD_LOGIC_VECTOR (Data_Width-1 downto 0);
               valid_vout :out std_logic;
               U_in : in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
               valid_uin :in std_logic;
               U_out : out STD_LOGIC_VECTOR (Data_Width-1 downto 0);  
               valid_uout :out std_logic;
               G_in : in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
               valid_gin :in std_logic;
               G_out : out STD_LOGIC_VECTOR (Data_Width-1 downto 0);
               valid_gout :out std_logic;         
               Vspike : out STD_LOGIC
               );
end component;
--------------------------------------------------------------------------------------------------------------------
component syn is
    Generic( Data_Width: integer :=32);   
    Port ( clk           : in STD_LOGIC;
           enable        : in STD_LOGIC;
           V_Pre         : in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
           V_Post        : in STD_LOGIC_VECTOR (Data_Width-1 downto 0);
           Iastro_neuron : in STD_LOGIC;
           Isyn          : out STD_LOGIC_VECTOR (Data_Width-1 downto 0)          
           );
           
end component;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

begin
U1: Neuron_Izh
Generic map(Data_Width =>32,
            shift_param=>16,
            Clk_period => Clk_period)
    port map ( clk    => clk,
               enable => enable ,
               I      => Iapp,
               V_in   => temp_v,
               valid_vin => valid_v,
               V_out  => vo ,
               U_in   => temp_u,
               valid_uin => valid_u,
               U_out  => uo ,
               G_in   => temp_g,
               valid_gin => valid_g,
               G_out  => go,
               Vspike => mask
              );
 ------------------------double buffering--------------
   
process(clk_b) 
 begin
   if rising_edge(clk_b) then
   valid_v <= '1';
     valid_u <= '1';
     valid_g <= '1';

    if v_pp_prt = 0 then
     
        temp_v <= v_buffer2 (v_process_buffer);
   else  
     
        temp_v <= v_buffer1 (v_process_buffer);
      end if;  
 
  end if;

end process; 

 
 process(clk_n) 
 begin

  
  if rising_edge(clk_n) then
 
    if v_pp_prt = 0 then
     
        v_buffer1(v_record_buffer)<= vo;

   else  
 
        v_buffer2(v_record_buffer)<= vo;

      end if;  
    end if;  

 
end process; 

process(clk_b) 
 begin

  
  if rising_edge(clk_b) then
    if count_clk < 1 then
     
        count_clk <= count_clk+1;

   else  
 
        count_clk <= 0;

      end if;  
    end if;  

end process;


process (clk_n)
 begin
  if rising_edge(clk_n) then
  
      if v_record_buffer < 99 then
        v_record_buffer <= v_record_buffer+1;
      else
        v_record_buffer <= 0;
        if v_pp_prt=0 then
          v_pp_prt <=1;
        else
          v_pp_prt <=0;
        end if;
      end if;
       
      if v_process_buffer < 99 then
        v_process_buffer <= v_process_buffer+1;
      else
        v_process_buffer <= 0;
      
      end if;
    end if;  

end process;  
    
----------------------------u ppfifo     
process( clk_n) 
 begin

   if rising_edge(CLK_n) then
    
    if v_pp_prt=0 then
    
        u_buffer1(v_record_buffer)<= uo;
     
    else
   
        u_buffer2(v_record_buffer)<= uo;
      
    end if;
  end if;


end process;


process( clk_b) 
 begin

    if rising_edge(CLK_b) then 

    if v_pp_prt=0 then
    
      temp_u <= u_buffer2 (v_process_buffer);
    else
      
      temp_u <= u_buffer1 (v_process_buffer);
    end if;

    end if;
end process;

--------------------g ppfifo
process( clk_n) --go,
 begin
  

   if rising_edge(CLK_n) then  

    if v_pp_prt=0 then
    
        g_buffer1(v_record_buffer)<= go;
    else
         g_buffer2(v_record_buffer)<= go;

    end if;
  end if;


end process;


process( clk_b) 
 begin

    if rising_edge(CLK_b) then
    if v_pp_prt=0 then
     
      
      temp_g <= g_buffer2 (v_process_buffer);
    else
      
      temp_g <= g_buffer1 (v_process_buffer);
    end if;
  end if;

end process;
------------------------------------------synaptic units------------------------
U_syn1: syn
  port map ( clk           => clk ,
             enable        => enable ,
             V_Pre         => V_Pre,
             V_Post        => V_post,
             Iastro_neuron => Iastro_post ,
             Isyn          => Io_syn
            );
 ------------------------------------------------
process (clk_s)
 begin
 
    if rising_edge(clk_s) then
      if syn_counter < 19 then
        syn_counter <= syn_counter+1;
      else
        syn_counter <= 0;
      end if;  
    end if;

end process; 
--------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------vpost ----------------
indx <= (v_process_buffer)*Num_connection; 


  indx_t <=post_indx(indx+syn_counter);


V_pre <= vo;  
V_post <= v_buffer1(indx_t-1) when (v_pp_prt=1) else v_buffer2(indx_t-1);
  
Iastro_post <= Iastro_neuron(indx_t-1);

 -----------------------------------
process (enable, clk_s)
 begin
  if (enable='0') then
    Isyn_post1 <= (others => (others => '0')); 
    Isyn_post2 <= (others => (others => '0')); 
  else 
  
   if rising_edge(clk_s) then
    if Isyn_pp_prt=0 then
      if ( Isyn_process_buffer < 99) then
        Isyn_post2(indx_t-1)<=Isyn_post2(indx_t-1)+Io_syn ;
      else
        Isyn_post1 <= (others => (others => '0'));
      end if;
    else
      if (Isyn_process_buffer < 99) then
        Isyn_post1(indx_t-1) <=Isyn_post1(indx_t-1)+Io_syn ;
      else
        Isyn_post2 <= (others => (others => '0'));
      end if;
    end if;
   end if; 
  end if;
end process; 
--------------------------------------------------------------------------------------------------------------------
process(clk_n)
 begin
 
    if rising_edge(clk_n) then 
      if Isyn_record_buffer < 99 then
        Isyn_record_buffer <= Isyn_record_buffer+1;
      else
        Isyn_record_buffer <= 0;
        if Isyn_pp_prt=0 then
          Isyn_pp_prt <=1;
        else
          Isyn_pp_prt <=0;
        end if;
      end if;
     
      if Isyn_process_buffer < 99 then
        Isyn_process_buffer <= Isyn_process_buffer+1;
      else
        Isyn_process_buffer <= 0;

      end if;
 
  end if;
end process;  
--------------------------------------------------------------------------------------------------------------------
process (Isyn_process_buffer) 
 begin

    if (T_test ='1') then 
      if I_neuron(Isyn_process_buffer)='1' then
        I <=  I_Test;
      else 
        I <=  X"00000000";
      end if;
    else
      if I_neuron(Isyn_process_buffer)='1' then
        I <=  I_Train;
      else 
        I <=  X"00000000";
      end if;
    end if;

end process;
--------------------------------------------------------------------------------------------------------------------
process (I,Isyn_process_buffer) 
 begin

    if Isyn_pp_prt=1 then 

      i_in <=  I+Isyn_post2(Isyn_process_buffer);

    else 
      i_in <= I+Isyn_post1(Isyn_process_buffer);
    end if;
end process;
--------------------------------------------------------------------------------------------------------------------  
process (i_in)  
 begin

    if i_in > 1638400 then
      Iapp <= X"00190000";
      
    else

      Iapp <= i_in;
     
    end if;

end process;   
 
--------------------------------------------------------------------------------------------------------------------

V_neuron    <=   v_buffer2(to_integer(unsigned(neuron_astro_indx)));
Glu_neuron  <=   g_buffer2(to_integer(unsigned(neuron_astro_indx))); 
---------------------------------------------------------------------------------

Glu <= g_buffer2(v_process_buffer) ;
G_indx <= std_logic_vector(to_unsigned(v_process_buffer,7));

--------------------------------------------------------------------------------------------------------------------

end Behavioral;
