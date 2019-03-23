library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VOQ is
port(
	ain : in std_logic;
	output : in std_logic_vector(7 downto 0);
	output_port_valid : in std_logic;
	output_data : out std_logic_vector(n-1 downto 0));
end VOQ;

architecture Behavioral of VOQ is
begin
process(ain,output,output_port_valid) is
	begin
	if (output_port_valid='1') then
		output_data <= (others => '0');
		output_data(to_integer(unsigned(output))) <= ain;
	else
		output_data <= (others => '0');
	end if;
	end process;
end Behavioral;
