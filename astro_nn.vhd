library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;
use work.buffer_type.all;
use work.wm_package.all;

entity astro_nn is

Generic( Data_Width: integer:=32;
         shift_param:integer:=16;
         Number_of_Neuron : integer := 100;
         astro_size:integer:=25 ;
         Clk_period : integer := 50);
           
  Port (   
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           Glu: in STD_LOGIC_VECTOR (Data_Width-1 downto 0); 
           G_indx: in STD_LOGIC_VECTOR (6 downto 0);
           Mask : in STD_LOGIC;
           Iastro_spike:out STD_LOGIC_vector  (0 to astro_size-1);
           Iastro_neuron:out STD_LOGIC_vector  (0 to astro_size-1)
--           test : out std_logic
            );
end astro_nn;

architecture Behavioral of astro_nn is


 -------------------------------------astrocyte signals----------------
 constant counter_max:integer:=2600; --*(Clk_period/50);
 type astro_array is array (0 to astro_size) of STD_LOGIC_VECTOR (Data_width-1 downto 0);
 type logic_array is array (0 to astro_size-1) of STD_LOGIC;
 type integer_array is array (0 to astro_size) of integer;

 signal indx_astro,indx_astro_overlap,indx_astro_overlap_plus,indx_astro_overlap_plus2:integer range 0 to 25:=0;
 signal input_indx:integer range 0 to 100:=0;
 
 signal Iastro_neuron_array,Iastro_spike_array,Iastro_s_array:logic_array:=(others => '0');
 signal n_astro_spikes,J_glue: integer_array:=(others => 0);
 signal counter0:integer:=0;
 signal counter1:integer:=0;
 signal counter2:integer:=0;
 signal counter3:integer:=0;
 signal counter4:integer:=0;
 signal counter5:integer:=0;
 signal counter6:integer:=0;
 signal counter7:integer:=0;
 signal counter8:integer:=0;
 signal counter9:integer:=0;
 signal counter10:integer:=0;
 signal counter11:integer:=0;
 signal counter12:integer:=0;
 signal counter13:integer:=0;
 signal counter14:integer:=0;
 signal counter15:integer:=0;
 signal counter16:integer:=0;
 signal counter17:integer:=0;
 signal counter18:integer:=0;
 signal counter19:integer:=0;
 signal counter20:integer:=0;
 signal counter21:integer:=0;
 signal counter22:integer:=0;
 signal counter23:integer:=0;
 signal counter24:integer:=0;



------------------------------------------
begin

process (clk)
 begin
  if rising_edge(clk) then
    input_indx <= to_integer(unsigned(G_indx));
  end if;
end process;
  

--input_indx <= to_integer(unsigned(G_indx));


indx_astro <= 0 when (input_indx=0) else
              0 when (input_indx=1) else
              0 when (input_indx=10) else
              0 when (input_indx=11) else
              
              1 when (input_indx=2) else
              1 when (input_indx =3) else
              1 when (input_indx=12) else
              1 when (input_indx=13) else
              
              2 when (input_indx=4) else
              2 when (input_indx=5) else 
              2 when (input_indx=14) else 
              2 when (input_indx=15) else
             
              3 when (input_indx=6) else
              3 when (input_indx =7) else
              3 when (input_indx =16) else
              3 when (input_indx =17) else
              
              4 when (input_indx =8) else
              4 when (input_indx =9) else
              4 when (input_indx =18) else 
              4 when (input_indx =19) else 
              
              
              5 when (input_indx=20) else
              5 when (input_indx =21) else
              5 when (input_indx=30) else
              5 when (input_indx=31) else
              
              6 when (input_indx=22) else
              6 when (input_indx=23) else 
              6 when (input_indx=32) else 
              6 when (input_indx=33) else
             
              7 when (input_indx=24) else
              7 when (input_indx =25) else
              7 when (input_indx =34) else
              7 when (input_indx =35) else
              
              8 when (input_indx =26) else
              8 when (input_indx =27) else
              8 when (input_indx =36) else 
              8 when (input_indx =37) else 
              
              
              9 when (input_indx=28) else
              9 when (input_indx =29) else
              9 when (input_indx=38) else
              9 when (input_indx=39) else
              
              10 when (input_indx=40) else
              10 when (input_indx=41) else 
              10 when (input_indx=50) else 
              10 when (input_indx=51) else
             
              11 when (input_indx=42) else
              11 when (input_indx =43) else
              11 when (input_indx =52) else
              11 when (input_indx =53) else
              
              12 when (input_indx =44) else
              12 when (input_indx =45) else
              12 when (input_indx =54) else 
              12 when (input_indx =55) else 
              
              13 when (input_indx=46) else
              13 when (input_indx =47) else
              13 when (input_indx=56) else
              13 when (input_indx=57) else
              
              14 when (input_indx=48) else
              14 when (input_indx=49) else 
              14 when (input_indx=58) else 
              14 when (input_indx=59) else
             
              15 when (input_indx=60) else
              15 when (input_indx =61) else
              15 when (input_indx =70) else
              15 when (input_indx =71) else
              
              16 when (input_indx =62) else
              16 when (input_indx =63) else
              16 when (input_indx =72) else 
              16 when (input_indx =73) else 
              
              17 when (input_indx=64) else
              17 when (input_indx =65) else
              17 when (input_indx=74) else
              17 when (input_indx=75) else
              
              18 when (input_indx=66) else
              18 when (input_indx=67) else 
              18 when (input_indx=76) else 
              18 when (input_indx=77) else
             
              19 when (input_indx=68) else
              19 when (input_indx =69) else
              19 when (input_indx =78) else
              19 when (input_indx =79) else
              
              20 when (input_indx =80) else
              20 when (input_indx =81) else
              20 when (input_indx =90) else 
              20 when (input_indx =91) else 
              
              21 when (input_indx=82) else
              21 when (input_indx =83) else
              21 when (input_indx=92) else
              21 when (input_indx=93) else
              
              22 when (input_indx=84) else
              22 when (input_indx=85) else 
              22 when (input_indx=94) else 
              22 when (input_indx=95) else
             
              23 when (input_indx=86) else
              23 when (input_indx =87) else
              23 when (input_indx =96) else
              23 when (input_indx =97) else
              
              24 when (input_indx =88) else
              24 when (input_indx =89) else
              24 when (input_indx =98) else 
              24 when (input_indx =99) else 
              25;
----------------------------------------
--indx_astro_overlap <= 1 when (input_indx=3 ) else 
--                      1 when (input_indx=13 ) else 
--                      1 when (input_indx=23 ) else  
--                      1 when (input_indx=33 ) else -----------2nd
--                      2 when (input_indx=6 ) else 
--                      2 when (input_indx=16 ) else 
--                      2 when (input_indx=26 ) else  
--                      2 when (input_indx=36 ) else  ----------- 2nd
--                      4 when (input_indx=43 ) else 
--                      4 when (input_indx=53 ) else 
--                      4 when (input_indx=63 ) else ------------2nd
--                      3 when (input_indx=30 ) else  
--                      3 when (input_indx=31 ) else 
--                      3 when (input_indx=32 ) else      
--                      4 when (input_indx=34 ) else  
--                      4 when (input_indx=35 ) else 
--                      5 when (input_indx=37 ) else
--                      5 when (input_indx=38 ) else  
--                      5 when (input_indx=39 ) else 
--                      5 when (input_indx=46 ) else   
--                      5 when (input_indx=56 ) else  
--                      5 when (input_indx=66 ) else  --------2nd
--                      6 when (input_indx=60 ) else 
--                      6 when (input_indx=61 ) else  
--                      6 when (input_indx=62 ) else 
--                      7 when (input_indx=64 ) else    
--                      7 when (input_indx=65 ) else  
--                      8 when (input_indx=67 ) else 
--                      8 when (input_indx=68 ) else
--                      8 when (input_indx=69 ) else  
--                      7 when (input_indx=73 ) else 
--                      7 when (input_indx=83 ) else
--                      7 when (input_indx=93 ) else
--                      8 when (input_indx=76 ) else 
--                      8 when (input_indx=86 ) else
--                      8 when (input_indx=96 ) else 
--                      9;
-------------------------------------------------------------

--indx_astro_overlap_plus <= 3 when (input_indx=33 ) else -------------3nd
--                           4 when (input_indx=36 ) else ------------3nd
--                           6 when (input_indx=63 ) else ----------3nd
--                           7 when (input_indx=66 ) else   --------3nd
--                           9;
------------------------------------------------------------
--indx_astro_overlap_plus2 <= 4 when (input_indx=33 ) else ---------------4nd
--                           5 when (input_indx=36 ) else -----------4nd
--                           7 when (input_indx=63 ) else  -----------4nd
--                           8 when (input_indx=66 ) else ----------4nd
--                           9;
-------------------------------------------------
--process(enable,G_indx)  --,clk
process(enable,clk)  --,clk
begin
 if (enable='0')then
   J_glue <= (others => 0);
 else
  if rising_edge (clk) then
   if input_indx < 99 then
     if Glu > X"0000B333" then
        J_glue(indx_astro) <= J_glue(indx_astro)+1;
--        J_glue(indx_astro_overlap) <= J_glue(indx_astro_overlap)+1;
--        J_glue(indx_astro_overlap_plus) <= J_glue(indx_astro_overlap_plus)+1;
--        J_glue(indx_astro_overlap_plus2) <= J_glue(indx_astro_overlap_plus2)+1;
     else
        J_glue(indx_astro) <= J_glue(indx_astro);
--        J_glue(indx_astro_overlap) <= J_glue(indx_astro_overlap);
--        J_glue(indx_astro_overlap_plus) <= J_glue(indx_astro_overlap_plus);
--        J_glue(indx_astro_overlap_plus2) <= J_glue(indx_astro_overlap_plus2);
     end if;
   else
     if J_glue (0) > 2 then  --------16*0.5
       Iastro_neuron_array(0) <= '1';
     else
       Iastro_neuron_array (0) <= '0';
     end if; 
     
     if J_glue (1) > 2 then
        Iastro_neuron_array(1) <= '1';
     else
        Iastro_neuron_array (1) <= '0';
     end if;
        
     if J_glue (2) > 2 then
        Iastro_neuron_array(2) <= '1';
     else
        Iastro_neuron_array (2) <= '0';
     end if;
        
     if J_glue (3) > 2 then
        Iastro_neuron_array(3) <= '1';
     else
        Iastro_neuron_array (3) <= '0';
     end if;
        
     if J_glue (4) > 2 then
        Iastro_neuron_array(4) <= '1';
     else
        Iastro_neuron_array (4) <= '0';
     end if;
        
     if J_glue (5) > 2 then
        Iastro_neuron_array(5) <= '1';
     else
        Iastro_neuron_array (5) <= '0';
     end if;
        
     if J_glue (6) > 2 then
        Iastro_neuron_array(6) <= '1';
     else
        Iastro_neuron_array (6) <= '0';
     end if;
        
     if J_glue (7) >   2 then
        Iastro_neuron_array(7) <= '1';
     else
        Iastro_neuron_array (7) <= '0';
     end if;
        
     if J_glue (8) > 2 then
        Iastro_neuron_array(8) <= '1';
     else
        Iastro_neuron_array (8) <= '0';
     end if;
        
      
   
   ---
   if J_glue (9) > 2 then  --------16*0.5
       Iastro_neuron_array(9) <= '1';
     else
       Iastro_neuron_array (9) <= '0';
     end if; 
     
     if J_glue (10) > 2 then
        Iastro_neuron_array(10) <= '1';
     else
        Iastro_neuron_array (10) <= '0';
     end if;
        
     if J_glue (11) > 2 then
        Iastro_neuron_array(11) <= '1';
     else
        Iastro_neuron_array (11) <= '0';
     end if;
        
     if J_glue (12) > 2 then
        Iastro_neuron_array(12) <= '1';
     else
        Iastro_neuron_array (12) <= '0';
     end if;
        
     if J_glue (13) > 2 then
        Iastro_neuron_array(13) <= '1';
     else
        Iastro_neuron_array (13) <= '0';
     end if;
        
     if J_glue (14) > 2 then
        Iastro_neuron_array(14) <= '1';
     else
        Iastro_neuron_array (14) <= '0';
     end if;
        
     if J_glue (15) > 2 then
        Iastro_neuron_array(15) <= '1';
     else
        Iastro_neuron_array (15) <= '0';
     end if;
        
     if J_glue (16) >   2 then
        Iastro_neuron_array(16) <= '1';
     else
        Iastro_neuron_array (16) <= '0';
     end if;
        
     if J_glue (17) > 2 then
        Iastro_neuron_array(17) <= '1';
     else
        Iastro_neuron_array (17) <= '0';
     end if;
        
        
   -----
   if J_glue (18) > 2 then  --------16*0.5
       Iastro_neuron_array(18) <= '1';
     else
       Iastro_neuron_array (18) <= '0';
     end if; 
     
     if J_glue (19) > 2 then
        Iastro_neuron_array(19) <= '1';
     else
        Iastro_neuron_array (19) <= '0';
     end if;
        
     if J_glue (20) > 2 then
        Iastro_neuron_array(20) <= '1';
     else
        Iastro_neuron_array (20) <= '0';
     end if;
        
     if J_glue (21) > 2 then
        Iastro_neuron_array(21) <= '1';
     else
        Iastro_neuron_array (21) <= '0';
     end if;
        
     if J_glue (22) > 2 then
        Iastro_neuron_array(22) <= '1';
     else
        Iastro_neuron_array (22) <= '0';
     end if;
        
     if J_glue (23) > 2 then
        Iastro_neuron_array(23) <= '1';
     else
        Iastro_neuron_array (23) <= '0';
     end if;
        
     if J_glue (24) > 7 then
        Iastro_neuron_array(24) <= '1';
     else
        Iastro_neuron_array (24) <= '0';
     end if;
        
     
        
        J_glue <= (others => 0);
        
   end if;
 

Iastro_neuron <= std_logic_vector(Iastro_neuron_array(0 to astro_size-1));
 end if;
end if;
end process;
------------------------------------------------
--process(enable,G_indx)  --,clk
process(enable,clk)  --,clk
begin
 if (enable='0')then
    n_astro_spikes <= (others => (0));
    Iastro_spike_array <=(others => '0'); 
 else
  if rising_edge (clk) then
    if input_indx < 99 then
      if (Mask='1') then
        
        n_astro_spikes (indx_astro) <= n_astro_spikes (indx_astro)+1;
--        n_astro_spikes (indx_astro_overlap) <= n_astro_spikes (indx_astro_overlap)+1;
--        n_astro_spikes (indx_astro_overlap_plus) <= n_astro_spikes (indx_astro_overlap_plus)+1;
--        n_astro_spikes (indx_astro_overlap_plus2) <= n_astro_spikes (indx_astro_overlap_plus2)+1;
      else
        n_astro_spikes (indx_astro) <= n_astro_spikes (indx_astro);
--        n_astro_spikes (indx_astro_overlap) <= n_astro_spikes (indx_astro_overlap);
--        n_astro_spikes (indx_astro_overlap_plus) <= n_astro_spikes (indx_astro_overlap_plus);
--        n_astro_spikes (indx_astro_overlap_plus2) <= n_astro_spikes (indx_astro_overlap_plus2);
      end if;
    else
--      test <= '1';
------------------------------------------------------------------------
      if n_astro_spikes (0) > 2 then
        Iastro_s_array(0) <= '1';
        
      end if; 

      if n_astro_spikes (1) > 2 then
        Iastro_s_array(1) <= '1';
      end if;
      if n_astro_spikes (2) > 2 then

        Iastro_s_array(2) <= '1';
      end if;

      if n_astro_spikes (3) > 2 then
        Iastro_s_array(3) <= '1';
      end if;
        
      if n_astro_spikes (4) > 2 then
        Iastro_s_array(4) <= '1';
      end if;
        
      if n_astro_spikes (5) > 2 then
        Iastro_s_array(5) <= '1';
      end if;
        
      if n_astro_spikes (6) > 2 then
        Iastro_s_array(6) <= '1';
      end if;
        
      if n_astro_spikes (7) > 2 then
        Iastro_s_array(7) <= '1';
      end if;
        
      if n_astro_spikes (8) > 2 then
        Iastro_s_array(8) <= '1';
      end if;
      
      ----
      if n_astro_spikes (9) > 2 then
        Iastro_s_array(9) <= '1';
        
      end if; 

      if n_astro_spikes (10) > 2 then
        Iastro_s_array(10) <= '1';
      end if;
      if n_astro_spikes (11) > 2 then

        Iastro_s_array(11) <= '1';
      end if;

      if n_astro_spikes (12) > 2 then
        Iastro_s_array(12) <= '1';
      end if;
        
      if n_astro_spikes (13) > 2 then
        Iastro_s_array(13) <= '1';
      end if;
        
      if n_astro_spikes (14) > 2 then
        Iastro_s_array(14) <= '1';
      end if;
        
      if n_astro_spikes (15) > 2 then
        Iastro_s_array(15) <= '1';
      end if;
        
      if n_astro_spikes (16) > 2 then
        Iastro_s_array(16) <= '1';
      end if;
        
      if n_astro_spikes (17) > 2 then
        Iastro_s_array(17) <= '1';
      end if;
      
      ----
      if n_astro_spikes (18) > 2 then
        Iastro_s_array(18) <= '1';
        
      end if; 

      if n_astro_spikes (19) > 2 then
        Iastro_s_array(19) <= '1';
      end if;
      if n_astro_spikes (20) > 2 then

        Iastro_s_array(20) <= '1';
      end if;

      if n_astro_spikes (21) > 2 then
        Iastro_s_array(21) <= '1';
      end if;
        
      if n_astro_spikes (22) > 2 then
        Iastro_s_array(22) <= '1';
      end if;
        
      if n_astro_spikes (23) > 2 then
        Iastro_s_array(23) <= '1';
      end if;
        
      if n_astro_spikes (24) > 2 then
        Iastro_s_array(24) <= '1';
      end if;
        
      
-----------------------

      if Iastro_s_array(0)='1' then
         if counter0 < counter_max then  --------6
            Iastro_spike_array(0) <= '1';
            counter0 <= counter0+1;
            
         else
            Iastro_spike_array(0) <= '0';
            Iastro_s_array(0) <= '0';
            counter0 <= 0;
         end if;
         --else
         --Iastro_spike_array (0) <= '0';
      end if; 
        
      if Iastro_s_array(1)='1' then
        --Iastro_spike_array (1) <= '1';
        if counter1 < counter_max then  --------6
          Iastro_spike_array(1) <= '1';
          counter1 <= counter1+1;
        else
          Iastro_spike_array(1) <= '0';
          Iastro_s_array(1) <= '0';
          counter1 <= 0;
        end if;
        --else
        --Iastro_spike_array(1) <= '0';
      end if;
        
      if Iastro_s_array(2)='1' then
        --Iastro_spike_array(2) <= '1';
        if counter2 < counter_max then  --------6
          Iastro_spike_array(2) <= '1';
          counter2 <= counter2+1;
        else
          Iastro_spike_array(2) <= '0';
          Iastro_s_array(2) <='0';
          counter2 <= 0;
        end if;
        --else
        --Iastro_spike_array (2) <= '0';
      end if;
        
      if Iastro_s_array(3)='1' then
        --Iastro_spike_array(3) <= '1';
        if counter3 < counter_max then  --------6
          Iastro_spike_array(3) <= '1';
          counter3 <= counter3+1;
        else
          Iastro_spike_array(3) <= '0';
          Iastro_s_array(3) <='0';
          counter3 <= 0;
        end if;
        --else
        --Iastro_spike_array (3) <= '0';
      end if;
        
      if Iastro_s_array(4)='1' then
        --Iastro_spike_array(4) <= '1';
        if counter4 < counter_max then  --------6
            Iastro_spike_array(4) <= '1';
            counter4 <= counter4+1;
        else
            Iastro_spike_array(4) <= '0';
            Iastro_s_array(4) <='0';
            counter4 <= 0;
        end if;
        --else
        --Iastro_spike_array(4) <= '0';
      end if;
        
      if Iastro_s_array(5)='1' then
        --Iastro_spike_array(5) <= '1';
        if counter5 < counter_max then  --------6
            Iastro_spike_array(5) <= '1';
            counter5 <= counter5+1;
        else
            Iastro_spike_array(5) <= '0';
            Iastro_s_array(5) <='0';
            counter5 <= 0;
        end if;
        --else
        --Iastro_spike_array (5) <= '0';
      end if;
        
      if Iastro_s_array(6)='1' then
        --Iastro_spike_array(6) <= '1';
        if counter6 < counter_max then  --------6
            Iastro_spike_array(6) <= '1';
            counter6 <= counter6+1;
        else
            Iastro_spike_array(6) <= '0';
            Iastro_s_array(6) <='0';
            counter6 <= 0;
        end if;
        --else
        --Iastro_spike_array (6) <= '0';
      end if;
        
     if Iastro_s_array(7)='1' then
        --Iastro_spike_array(7) <= '1';
        if counter7 < counter_max then  --------6
            Iastro_spike_array(7) <= '1';
            counter7 <= counter7+1;
        else
            Iastro_spike_array(7) <= '0';
            Iastro_s_array(7) <='0';
            counter7 <= 0;
        end if;
        --else
        --Iastro_spike_array (7) <= '0';
     end if;
        
     if Iastro_s_array(8)='1' then
        --Iastro_spike_array(8) <= '1';
        if counter8 < counter_max then  --------6
            Iastro_spike_array(8) <= '1';
            counter8 <= counter8+1;
        else
            Iastro_spike_array(8) <= '0';
            Iastro_s_array(8) <='0';
            counter8 <= 0;
        end if;
        --else
        --Iastro_spike_array (8) <= '0';
     end if;
     
     ----
      if Iastro_s_array(9)='1' then
         if counter9 < counter_max then  --------6
            Iastro_spike_array(9) <= '1';
            counter9 <= counter9+1;
            
         else
            Iastro_spike_array(9) <= '0';
            Iastro_s_array(9) <= '0';
            counter9 <= 0;
         end if;
         --else
         --Iastro_spike_array (0) <= '0';
      end if; 
        
      if Iastro_s_array(10)='1' then
        --Iastro_spike_array (1) <= '1';
        if counter10 < counter_max then  --------6
          Iastro_spike_array(10) <= '1';
          counter10 <= counter10+1;
        else
          Iastro_spike_array(10) <= '0';
          Iastro_s_array(10) <= '0';
          counter10 <= 0;
        end if;
        --else
        --Iastro_spike_array(1) <= '0';
      end if;
        
      if Iastro_s_array(11)='1' then
        --Iastro_spike_array(2) <= '1';
        if counter11 < counter_max then  --------6
          Iastro_spike_array(11) <= '1';
          counter11 <= counter11+1;
        else
          Iastro_spike_array(11) <= '0';
          Iastro_s_array(11) <='0';
          counter11 <= 0;
        end if;
        --else
        --Iastro_spike_array (2) <= '0';
      end if;
        
      if Iastro_s_array(12)='1' then
        --Iastro_spike_array(3) <= '1';
        if counter12 < counter_max then  --------6
          Iastro_spike_array(12) <= '1';
          counter12 <= counter12+1;
        else
          Iastro_spike_array(12) <= '0';
          Iastro_s_array(12) <='0';
          counter12 <= 0;
        end if;
        --else
        --Iastro_spike_array (3) <= '0';
      end if;
        
      if Iastro_s_array(13)='1' then
        --Iastro_spike_array(4) <= '1';
        if counter13 < counter_max then  --------6
            Iastro_spike_array(13) <= '1';
            counter13 <= counter13+1;
        else
            Iastro_spike_array(13) <= '0';
            Iastro_s_array(13) <='0';
            counter13 <= 0;
        end if;
        --else
        --Iastro_spike_array(4) <= '0';
      end if;
        
      if Iastro_s_array(14)='1' then
        --Iastro_spike_array(5) <= '1';
        if counter14 < counter_max then  --------6
            Iastro_spike_array(14) <= '1';
            counter14 <= counter14+1;
        else
            Iastro_spike_array(14) <= '0';
            Iastro_s_array(14) <='0';
            counter14 <= 0;
        end if;
        --else
        --Iastro_spike_array (5) <= '0';
      end if;
        
      if Iastro_s_array(15)='1' then
        --Iastro_spike_array(6) <= '1';
        if counter15 < counter_max then  --------6
            Iastro_spike_array(15) <= '1';
            counter15 <= counter15+1;
        else
            Iastro_spike_array(15) <= '0';
            Iastro_s_array(15) <='0';
            counter15 <= 0;
        end if;
        --else
        --Iastro_spike_array (6) <= '0';
      end if;
        
     if Iastro_s_array(16)='1' then
        --Iastro_spike_array(7) <= '1';
        if counter16 < counter_max then  --------6
            Iastro_spike_array(16) <= '1';
            counter16 <= counter16+1;
        else
            Iastro_spike_array(16) <= '0';
            Iastro_s_array(16) <='0';
            counter16 <= 0;
        end if;
        --else
        --Iastro_spike_array (7) <= '0';
     end if;
        
     if Iastro_s_array(17)='1' then
        --Iastro_spike_array(8) <= '1';
        if counter17 < counter_max then  --------6
            Iastro_spike_array(17) <= '1';
            counter17 <= counter17+1;
        else
            Iastro_spike_array(17) <= '0';
            Iastro_s_array(17) <='0';
            counter17 <= 0;
        end if;
        --else
        --Iastro_spike_array (8) <= '0';
     end if;
     
     -----
      if Iastro_s_array(18)='1' then
         if counter18 < counter_max then  --------6
            Iastro_spike_array(18) <= '1';
            counter18 <= counter18+1;
            
         else
            Iastro_spike_array(18) <= '0';
            Iastro_s_array(18) <= '0';
            counter18 <= 0;
         end if;
         --else
         --Iastro_spike_array (0) <= '0';
      end if; 
        
      if Iastro_s_array(19)='1' then
        --Iastro_spike_array (1) <= '1';
        if counter19 < counter_max then  --------6
          Iastro_spike_array(19) <= '1';
          counter19 <= counter19+1;
        else
          Iastro_spike_array(19) <= '0';
          Iastro_s_array(19) <= '0';
          counter19 <= 0;
        end if;
        --else
        --Iastro_spike_array(1) <= '0';
      end if;
        
      if Iastro_s_array(20)='1' then
        --Iastro_spike_array(2) <= '1';
        if counter20 < counter_max then  --------6
          Iastro_spike_array(20) <= '1';
          counter20 <= counter20+1;
        else
          Iastro_spike_array(20) <= '0';
          Iastro_s_array(20) <='0';
          counter20 <= 0;
        end if;
        --else
        --Iastro_spike_array (2) <= '0';
      end if;
        
      if Iastro_s_array(21)='1' then
        --Iastro_spike_array(3) <= '1';
        if counter21 < counter_max then  --------6
          Iastro_spike_array(21) <= '1';
          counter21 <= counter21+1;
        else
          Iastro_spike_array(21) <= '0';
          Iastro_s_array(21) <='0';
          counter21 <= 0;
        end if;
        --else
        --Iastro_spike_array (3) <= '0';
      end if;
        
      if Iastro_s_array(22)='1' then
        --Iastro_spike_array(4) <= '1';
        if counter22 < counter_max then  --------6
            Iastro_spike_array(22) <= '1';
            counter22 <= counter22+1;
        else
            Iastro_spike_array(22) <= '0';
            Iastro_s_array(22) <='0';
            counter22 <= 0;
        end if;
        --else
        --Iastro_spike_array(4) <= '0';
      end if;
        
      if Iastro_s_array(23)='1' then
        --Iastro_spike_array(5) <= '1';
        if counter23 < counter_max then  --------6
            Iastro_spike_array(23) <= '1';
            counter23 <= counter23+1;
        else
            Iastro_spike_array(23) <= '0';
            Iastro_s_array(23) <='0';
            counter23 <= 0;
        end if;
        --else
        --Iastro_spike_array (5) <= '0';
      end if;
        
      if Iastro_s_array(24)='1' then
        --Iastro_spike_array(6) <= '1';
        if counter24 < counter_max then  --------6
            Iastro_spike_array(24) <= '1';
            counter24 <= counter24+1;
        else
            Iastro_spike_array(24) <= '0';
            Iastro_s_array(24) <='0';
            counter24 <= 0;
        end if;
        --else
        --Iastro_spike_array (6) <= '0';
      end if;
        
    
        
        ----------------------------------------
     n_astro_spikes<= (others => (0));
        
        --Iastro_spike_array <= (others => ('0'));
  end if;
 
--Iastro_neuron <= std_logic_vector(Iastro_neuron_array(0 to astro_size-1));

Iastro_spike <= std_logic_vector(Iastro_spike_array(0 to astro_size-1));
--Iastro_spike <= (others => '1');
 end if;
end if;
end process;

end Behavioral;
