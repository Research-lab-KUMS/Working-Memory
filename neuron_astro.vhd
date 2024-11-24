----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/09/2022 11:10:53 AM
-- Design Name: 
-- Module Name: neuron_astro - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.numeric_std.all;
use work.buffer_type.all;
use work.wm_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity neuron_astro is
Generic(Data_Width: integer:=32;
shift_param: integer:=24;
Number_of_Neuron : integer := 100;
astro_size:integer:=25);
  Port ( clk_s : in STD_LOGIC;
           enable : in STD_LOGIC;
           ca_indx: in STD_LOGIC_VECTOR (3 downto 0);
           Iastro_spike:in STD_LOGIC_vector  (0 to astro_size-1);
           Iastro_ca:in STD_LOGIC_vector  (0 to astro_size-1);
          Iastro_out: out STD_LOGIC_vector  (0 to Number_of_Neuron-1)
           );
end neuron_astro;

architecture Behavioral of neuron_astro is
signal I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,I21,I22,I23,I24:std_logic:='0';
begin

process(clk_s)
begin
 if rising_edge(clk_s) then
I0 <= Iastro_ca (0) and Iastro_spike (0);
I1 <= Iastro_ca (1) and Iastro_spike (1);
I2 <= Iastro_ca (2) and Iastro_spike (2);
I3 <= Iastro_ca (3) and Iastro_spike (3);
I4 <= Iastro_ca (4) and Iastro_spike (4);
I5 <= Iastro_ca (5) and Iastro_spike (5);
I6 <= Iastro_ca (6) and Iastro_spike (6);
I7 <= Iastro_ca (7) and Iastro_spike (7);
I8 <= Iastro_ca (8) and Iastro_spike (8);
I9 <= Iastro_ca (9) and Iastro_spike (9);
I10 <= Iastro_ca (10) and Iastro_spike (10);
I11 <= Iastro_ca (11) and Iastro_spike (11);
I12 <= Iastro_ca (12) and Iastro_spike (12);
I13 <= Iastro_ca (13) and Iastro_spike (13);
I14 <= Iastro_ca (14) and Iastro_spike (14);
I15 <= Iastro_ca (15) and Iastro_spike (15);
I16 <= Iastro_ca (16) and Iastro_spike (16);
I17 <= Iastro_ca (17) and Iastro_spike (17);
I18 <= Iastro_ca (18) and Iastro_spike (18);
I19 <= Iastro_ca (19) and Iastro_spike (19);
I20 <= Iastro_ca (20) and Iastro_spike (20);
I21 <= Iastro_ca (21) and Iastro_spike (21);
I22 <= Iastro_ca (22) and Iastro_spike (22);
I23 <= Iastro_ca (23) and Iastro_spike (23);
I24 <= Iastro_ca (24) and Iastro_spike (24);

Iastro_out (0) <= I0;
Iastro_out (1) <= I0;
Iastro_out (2) <= I1;
Iastro_out (3) <= I1;
Iastro_out (4) <= I2;
Iastro_out (5) <= I2;
Iastro_out (6) <= I3;
Iastro_out (7) <= I3;
Iastro_out (8) <= I4;
Iastro_out (9) <= I4;
Iastro_out (10) <= I0;
Iastro_out (11) <= I0;
Iastro_out (12) <= I1;
Iastro_out (13) <= I1;
Iastro_out (14) <= I2;
Iastro_out (15) <= I2;
Iastro_out (16) <= I3;
Iastro_out (17) <= I3;
Iastro_out (18) <= I4;
Iastro_out (19) <= I4;
Iastro_out (20) <= I5;
Iastro_out (21) <= I5;
Iastro_out (22) <= I6;
Iastro_out (23) <= I6;
Iastro_out (24) <= I7;
Iastro_out (25) <= I7;
Iastro_out (26) <= I8;
Iastro_out (27) <= I8;
Iastro_out (28) <= I9;
Iastro_out (29) <= I9;
Iastro_out (30) <= I5;
Iastro_out (31) <= I5;
Iastro_out (32) <= I6;
Iastro_out (33) <= I6;
Iastro_out (34) <= I7;
Iastro_out (35) <= I7;
Iastro_out (36) <= I8;
Iastro_out (37) <= I8;
Iastro_out (38) <= I9;
Iastro_out (39) <= I9;
Iastro_out (40) <= I10;
Iastro_out (41) <= I10;
Iastro_out (42) <= I11;
Iastro_out (43) <= I11;
Iastro_out (44) <= I12;
Iastro_out (45) <= I12;
Iastro_out (46) <= I13;
Iastro_out (47) <= I13;
Iastro_out (48) <= I14;
Iastro_out (49) <= I14;
Iastro_out (50) <= I10;
Iastro_out (51) <= I10;
Iastro_out (52) <= I11;
Iastro_out (53) <= I11;
Iastro_out (54) <= I12;
Iastro_out (55) <= I12;
Iastro_out (56) <= I13;
Iastro_out (57) <= I13;
Iastro_out (58) <= I14;
Iastro_out (59) <= I14;
Iastro_out (60) <= I15;
Iastro_out (61) <= I15;
Iastro_out (62) <= I16;
Iastro_out (63) <= I16;
Iastro_out (64) <= I17;
Iastro_out (65) <= I17;
Iastro_out (66) <= I18;
Iastro_out (67) <= I18;
Iastro_out (68) <= I19;
Iastro_out (69) <= I19;
Iastro_out (70) <= I15;
Iastro_out (71) <= I15;
Iastro_out (72) <= I16;
Iastro_out (73) <= I16;
Iastro_out (74) <= I17;
Iastro_out (75) <= I17;
Iastro_out (76) <= I18;
Iastro_out (77) <= I18;
Iastro_out (78) <= I19;
Iastro_out (79) <= I19;
Iastro_out (80) <= I20;
Iastro_out (81) <= I20;
Iastro_out (82) <= I21;
Iastro_out (83) <= I21;
Iastro_out (84) <= I22;
Iastro_out (85) <= I22;
Iastro_out (86) <= I23;
Iastro_out (87) <= I23;
Iastro_out (88) <= I24;
Iastro_out (89) <= I24;
Iastro_out (90) <= I20;
Iastro_out (91) <= I20;
Iastro_out (92) <= I21;
Iastro_out (93) <= I21;
Iastro_out (94) <= I22;
Iastro_out (95) <= I22;
Iastro_out (96) <= I23;
Iastro_out (97) <= I23;
Iastro_out (98) <= I24;
Iastro_out (99) <= I24;

end if;
end process;
end Behavioral;
