library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.ALL;

package buffer_type is
constant data_depth : integer := 100;  --bits wide
constant  data_width    : integer := 32; --bits wide
type t_FIFO_DATA is array (0 to data_depth-1) of std_logic_vector(data_width-1 downto 0);
end package buffer_type;