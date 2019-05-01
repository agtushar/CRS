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
		data_av_in : in std_logic;
		data_rd_in : out std_logic;
		data_in : in data_bus;
		output_port_valid : in std_logic; 
		output_port : in output_port_bus;
		data_out : out data_bus_vector(n-1 downto 0);
		data_av_out : out std_logic_vector(n-1 downto 0);
		data_rd_out : in std_logic_vector(n-1 downto 0));
end VOQ;

architecture Behavioral of VOQ is
	signal output_port_int : integer := 0;
begin
	-- synchronization may be required for rd_signals
	output_port_int <= to_integer(unsigned(output_port));
	n_data:
	for i in 0 to n-1 generate
		data_out(i) <= data_in when i = output_port_int else
							(others => '0');
		data_av_out(i) <= data_av_in when i = output_port_int else
								'0';
		data_rd_in <= data_rd_out(output_port_int);
	end generate;
end Behavioral;
