--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package globals is

-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
	constant N : integer := 2; -- N in the statement.pdf
	constant dv_bit_interval :integer := 4; -- 4th, 8th and 12th bits are data_valid_bits
	constant n_dv_bits :integer := 3; -- number of data_valid bits per data chunk
	constant data_bus_size : integer := dv_bit_interval * n_dv_bits;
 -- 3*(3+1) for the time being; change to 144 later

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
	subtype data_bus is std_logic_Vector((data_bus_size-1) downto 0);
	type data_bus_vector is array(natural range<>) of data_bus;
	
	subtype output_port_bus is std_logic_vector(7 downto 0);
	type output_port_vector is array(natural range <>) of output_port_bus;

--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
        function vector_to_integer (vec : std_logic_vector(n-1 downto 0)) 
	return integer;

	


end globals;

package body globals is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;

  function vector_to_integer (vec : std_logic_vector(n-1 downto 0)) 
	return integer is
	variable i : integer := 0;
  begin
	for i in 0 to n-1 loop
		if vec(i) = '1' then
			return i;
		end if;
	end loop;
	return 0;
  end vector_to_integer;
  
 
end globals;
 
