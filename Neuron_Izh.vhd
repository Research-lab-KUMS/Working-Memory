
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;

entity Neuron_Izh is
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
end Neuron_Izh;

architecture Arch of Neuron_Izh is

---------------------------------------neuron parameters ,32 bits:16 bit integer,16 bit fractional-- Since k=140 :*2^16 -----------------------------------
constant dclk     : integer:=(Clk_period/50); -- dt=0.0001
constant k: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"008C0000";
constant a: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"0000199A";
constant b: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"00003333";
constant c: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBF0000";
constant d: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"00020000";
constant Vth: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"001E0000";
constant Vth1: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"00190000";
constant dt:  STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"0000199A"; 
constant coef:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"00000A3D";
constant alf: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"000A0000";
constant kG:  STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"02580000";
constant G_dt:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"00000007";
signal del:std_logic;
signal sub_bvu,uo,ik,v4,iv5,vsum,v5,isum,v2sh,gak: STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal vo : STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";

signal du,s,mult_bv,vv,mult_bvua,v2coef,dv,dg,ga: STD_LOGIC_VECTOR(2*Data_Width-1 downto 0):=(others => '0');
signal temp_v:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";
-------------------------
signal V_reg1:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";
signal V_reg2:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";
signal V_reg3:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";
signal V_reg4:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";
signal V_reg5:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=X"FFBA0000";
-----------------------
signal U_reg1:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal U_reg2:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal U_reg3:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal U_reg4:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal U_reg5:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');

-----------------------------
signal G_reg1:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal G_reg2:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal G_reg3:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
-------------------------------------------------------------
signal temp_u:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal temp_x:STD_LOGIC_VECTOR(Data_Width-1 downto 0):=(others => '0');
signal valid_bv   :std_logic:='0';
signal valid_isum :std_logic:='0';
signal valid_iv5  :std_logic:='0';
signal valid_sub  :std_logic:='0';
signal valid_muls :std_logic:='0';
signal valid_vsum :std_logic:='0';
signal valid_du   :std_logic:='0';
signal valid_uo   :std_logic:='0';
signal valid_dv   :std_logic:='0';
signal valid_vo   :std_logic:='0';
signal valid_u    :std_logic:='0';
signal valid_v    :std_logic:='0';
signal valid_tmpu :std_logic:='0';
signal valid_tmpv :std_logic:='0';
signal valid_g    :std_logic:='0';
signal valid_ga   :std_logic:='0';
signal valid_gak  :std_logic:='0';
signal valid_dg   :std_logic:='0';
signal valid_v2   :std_logic:='0';
signal valid_vind :std_logic:='0'; 
signal valid_uind :std_logic:='0'; 
signal valid_gind :std_logic:='0';

------------------------------
signal valid_V1:std_logic:='0';
signal valid_v3:std_logic:='0';
signal valid_v4:std_logic:='0';
signal valid_v5:std_logic:='0';
signal valid_v6:std_logic:='0';

---
signal valid_u1:std_logic:='0';
signal valid_u3:std_logic:='0';
signal valid_u4:std_logic:='0';
signal valid_u5:std_logic:='0';
signal valid_u6:std_logic:='0';

--
signal valid_g1:std_logic:='0';
signal valid_g3:std_logic:='0';
signal valid_g4:std_logic:='0';
---------------------
begin
------------------------------------------------------------------------------------------------
-----------------------------------------  
process(clk)
begin
  if rising_edge(CLK) then
    if(enable='1') then 
        if (valid_vin='1') then
            valid_vind <= '1';
            valid_uind <='1';
            valid_gind <='1';
        else 
            valid_vind <= '0';
            valid_uind <='0';
            valid_gind <='0';
        end if;
    else
      valid_vind <= '0';
      valid_uind <='0';
      valid_gind <='0';
    end if;               
  end if;
end process;

process(clk)
begin
  if rising_edge(CLK) then
    if(enable='1') then  
      if (valid_vind='1') then
        mult_bv <= b * V_in;-----b*v
        vv <= V_in * V_in;-----v^2
        v5 <= V_in +std_logic_vector(shift_left(signed(V_in), 2));-------5*v
        valid_bv <= '1';
      else 
        valid_bv <= '0';
      end if;
    else
      mult_bv <= (others =>'0');
      vv <= (others =>'0');  
      v4  <= (others =>'0');
      v5  <= (others =>'0');  
      valid_bv <= '0';
    end if;               
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then 
    if(enable='1') then  
      if  (valid_uind='1') then
        isum <= (I + k) - U_in ;        
        valid_isum <= '1';
      else     
        valid_isum <= '0'; 
      end if;   
    else              
      isum <= (others =>'0'); 
      valid_isum <= '0';
    end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(CLK) then 
    if(enable='1') then
      if (valid_bv='1')  then      
        v2coef <= vv(Data_Width+shift_param-1 downto shift_param)* coef;
        valid_v2 <= '1';
      else
        valid_v2 <= '0'; 
      end if;    
    else                 
      valid_v2 <= '0';
      v2coef  <= (others =>'0');
    end if;
  end if;
end process;
-----------------------------------------------------
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_isum='1')  then
       iv5 <= isum + v5; 
       valid_iv5 <='1';
     else 
       valid_iv5 <='0';
     end if;
   else
     iv5  <= (others =>'0');
     valid_iv5 <='0';  
   end if;
 end if;
end process;


process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_iv5='1') then
       vsum <= iv5+v2coef(Data_Width+shift_param-1 downto shift_param);
       valid_vsum <='1';
     else 
       valid_vsum <='0';
     end if; 
   else
     vsum <= (others =>'0');
     valid_vsum <='0';
   end if;
 end if;
end process;


process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_vsum='1') then
       dv <= vsum*dt;
       valid_dv <= '1';
     else
       valid_dv <='0';
     end if; 
   else
     dv <= (others =>'0');
     valid_dv <='0';
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_vin='1') then
       V_reg1 <= V_in; 
       valid_v1 <='1';
     else
       valid_v1 <= '0';
     end if;  
   else
     valid_v1 <= '0';
     V_reg1 <= (others => '0');
   end if;
 end if;
end process;


process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_v1='1') then
       V_reg2 <= V_reg1; 
       valid_v3 <='1';
     else
       valid_v3 <= '0';
     end if;
   else
     valid_v3 <= '0';
     V_reg2 <=(others => '0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_v3='1') then
       V_reg3<= V_reg2; 
       valid_v4 <='1';
     else
       valid_v4 <= '0';
     end if;
   else
     valid_v4 <= '0';
     V_reg3 <= (others => '0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_v4='1') then
       V_reg4<= V_reg3;
       valid_v5 <='1';
     else
       valid_v5 <= '0';
     end if;
   else
     valid_v5 <= '0';
     V_reg4 <= (others => '0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_v5='1') then
       V_reg5<= V_reg4; 
     end if;  
   else
     V_reg5 <= (others => '0');
   end if;
 end if;
end process;
----------------------------------------------------------------------
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_dv='1') then 
       vo <= V_reg4 + dv(Data_Width+shift_param-1 downto shift_param) ;   
       valid_vo <='1';
     else
       valid_vo <= '0';
     end if;
   else
     valid_vo <= '0';
     vo <= X"FFBA0000";
   end if;
 end if;
end process;

process(clk)
 begin
  if rising_edge(CLK) then 
    if(enable='1') then
      if (valid_vo ='1') then
        if V_reg5 >= Vth then
          temp_v <= c;
          Vspike <= '1';
        else
          temp_v <= vo;
          Vspike <= '0';
        end if; 
        valid_tmpv <='1';
      else
        valid_tmpv <='0';
      end if;   
    else  
      Vspike <= '0';
      temp_v <= X"FFBA0000";
      valid_tmpv <='0';
    end if;
  end if;
end process; 
-------------------------------------------------------------
process(clk)
 begin
  if rising_edge(CLK) then
    if(enable='1') then 
      if (valid_tmpv ='1')  then  
        if temp_v >= Vth then
          V_out <= Vth;    --
          temp_x <= Vth;
        else
          V_out <= temp_v;   --
          temp_x <= temp_v; 
        end if;
          valid_v <='1';
      else
        valid_v <='0';
      end if;
    else
       valid_v <='0';
       V_out  <= X"FFBA0000";  --        
    end  if;
  end if;                       
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_uin='1') then
       U_reg1 <= U_in; 
       valid_u1 <='1';
     else
       valid_u1 <= '0';
     end if; 
   else
     valid_u1 <= '0';
     U_reg1 <= (others =>'0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_u1='1') then
       U_reg2 <= U_reg1;
       valid_u3 <='1';
     else
       valid_u3 <= '0';
     end if;
   else
     valid_u3 <= '0';
     U_reg2 <= (others =>'0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_u3='1') then
       U_reg3 <= U_reg2; 
       valid_u4 <='1';
     else
       valid_u4 <= '0';
     end if;
   else
     valid_u4 <= '0';
     U_reg3 <= (others =>'0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_u4='1') then
       U_reg4 <= U_reg3;
       valid_u5 <='1';
     else
       valid_u5 <= '0';
     end if;
   else
     valid_u5 <= '0';
     U_reg4 <= (others =>'0');
   end if;
 end if;
end process;

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_bv='1') then
       sub_bvu <= mult_bv(Data_Width+shift_param-1 downto shift_param) - U_reg1 ; 
       valid_sub <= '1';
     else 
       valid_sub <= '0';
     end if;
   else
     valid_sub <= '0';
     sub_bvu  <= (others =>'0');
   end if;
 end if;
end process;

-----------------------------------------------------------------

process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_sub='1') then
       mult_bvua <= a * sub_bvu;
       valid_muls <='1';
     else
       valid_muls <='0';
     end if; 
   else
     valid_muls <='0';
     mult_bvua  <= (others =>'0'); 
   end if;
 end if;
end process;
-----------------------------------------------
process(clk)
begin
 if rising_edge(CLK) then
   if(enable='1') then 
     if (valid_muls='1') then
       du <= mult_bvua(Data_Width+shift_param-1 downto shift_param)*dt;
       valid_du <='1';
     else
       valid_du <= '0';
     end if;
   else
     du <= (others =>'0');
     valid_du <='0';
   end if;
 end if;
end process;
-----------------------------------------------------------------------
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_du='1') then
       uo <= U_reg4 + du(Data_Width+shift_param-1 downto shift_param);
       valid_uo <= '1';
     else 
       valid_uo <= '0';
     end if;
   else
     valid_uo <= '0';
     uo   <= (others =>'0');
   end if;
 end if;
end process;

process(clk)
begin 
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_vo ='1') then
       if V_reg5 >= Vth then
         temp_u <= uo + d;
       else
         temp_u <= uo;
       end if; 
       valid_tmpu <='1';    
     else
       valid_tmpu <='0';
     end if;    
   else  
     temp_u <= (others =>'0');     
     valid_tmpu <='0';
   end if;
 end if;
end process; 

  
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_tmpu='1') then  
       if temp_v >= Vth then
         U_out <= temp_u; 
       else
         U_out <= temp_u;      
       end if;
       valid_u <='1';
     else
       valid_u <='0';
     end if;
   else
     valid_u <='0';
     U_out  <= (others =>'0');
   end  if;
 end if;   
end process; 
 --------------------------------G = G - params.step .* (params.alf .* G - params.k  .* del);
 ---------------------------- del(V == params.neuron_fired_thr) = 1;
-- Vspike <= del;
process(clk) --
begin
  if rising_edge(CLK) then 
    if(enable='1') then
      if (valid_v ='1') then
        if (temp_x =Vth)then
          del <= '1';
        else
          del <='0';
        end if;
      end if;
    else
      del <= '0';
    end if;
  end if;
end process;    
 
process(clk)  --
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_gind='1') then
       ga <= G_in*alf;--G_in(Data_Width-1 downto 3)+G_in(Data_Width-1 downto 1);    ---------------------params.alf .* G :10*g*2^16
       valid_ga <= '1';
     else
       valid_ga <= '0';
     end if;
   else
     ga <= (others =>'0');
     valid_ga <='0';
   end if;   
 end if;                 
end process; 
    
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_ga ='1') then
       if (del='1')  then
         gak <= kG-ga(Data_Width+shift_param-1 downto shift_param); -------------------------params.alf .* G - params.k  .* del
       else
         gak <= -ga(Data_Width+shift_param-1 downto shift_param);
       end if;
       valid_gak <= '1';
     else
       valid_gak <='0';
     end if;
   else
     gak <= (others =>'0');
     valid_gak <='0';
   end if;   
 end if;   
end process; 
   
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_gak='1') then  
       dg <= gak*G_dt; -----------------------params.step .* (params.alf .* G - params.k  .* del);
       valid_dg <='1';
     else
       valid_dg <='0';
     end if;
   else
     dg <= (others =>'0');
     valid_dg <='0';
   end if; 
 end if;  
end process;  
   
   
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_gind='1') then
       G_reg1 <= G_in; -- v5
       valid_g1 <='1';
     else
       valid_g1 <= '0';
     end if;
   else
     valid_g1 <= '0';
     G_reg1 <= (others =>'0');
   end if;
 end if;
end process;
   
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_g1='1') then
       G_reg2 <= G_reg1; -- v5
       valid_g3 <='1';
     else
       valid_g3 <= '0';
     end if;
   else
     valid_g3 <= '0';
     G_reg2 <= (others =>'0');
   end if;
 end if;
end process;
     
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_g3='1') then
       G_reg3 <= G_reg2; -- v5
       valid_g4 <='1';
     else
       valid_g4 <= '0';
     end if;
   else
     valid_g4 <= '0';
     G_reg3 <= (others =>'0');
   end if;
 end if;
end process;
    
process(clk)
begin
 if rising_edge(CLK) then 
   if(enable='1') then
     if (valid_dg='1') then
       G_out <=G_reg3+dg(Data_Width+shift_param-1 downto shift_param);---------G = G - params.step .* (params.alf .* G - params.k  .* del);
       valid_g <= '1';
     else
       valid_g <='0';
     end if;
   else
     G_out <= (others =>'0');
     valid_g <='0';
   end if;   
 end if;   
end process;  
   
   valid_vout<= valid_v;
   valid_uout<= valid_u;   
   valid_gout<= valid_g;
   
end Arch;
