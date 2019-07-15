  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use work.globals.all;


  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT VOQ
          port(
				ain : in std_logic;
				output : in std_logic_vector(7 downto 0);
				output_port_valid : in std_logic;
				output_data : out std_logic_vector(n-1 downto 0));
          END COMPONENT;

          SIGNAL ain :  std_logic;
          SIGNAL output :  std_logic_vector(7 downto 0);
			 SIGNAL output_port_valid : std_logic;
			 SIGNAL output_data : std_logic_vector(n-1 downto 0);
          

  BEGIN

  -- Component Instantiation
          uut: VOQ PORT MAP(
                  ain => ain,
                  output => output,
						output_port_valid => output_port_valid,
						output_data => output_data
          );
	stim_proc: process
	begin
		output_port_valid<='1';
		output<="00000001";
		ain<='1';
		wait for 5 ns;
		assert(output_data="10") report "FAIL 00000001/1/10" severity error;
		output_port_valid<='1';
		output<="00000000";
		ain<='1';
		wait for 5 ns;
		assert(output_data="01") report "FAIL 00000000/1/01" severity error;
		output_port_valid<='1';
		output<="00000001";
		ain<='0';
		wait for 5 ns;
		assert(output_data="00") report "FAIL 00000001/0/00" severity error;
		output_port_valid<='1';
		output<="00000000";
		ain<='0';
		wait for 5 ns;
		assert(output_data="00") report "FAIL 00000000/0/00" severity error;
		output_port_valid<='1';
		output<="00000000";
		ain<='1';
		wait for 5 ns;
		assert(output_data="01") report "FAIL 00000000/1/01" severity error;
		output_port_valid<='0';
		output<="00000001";
		ain<='1';
		wait for 5 ns;
		assert(output_data="00") report "FAIL 00000001/1/1" severity error;		
		wait;
	end process;
  END;
