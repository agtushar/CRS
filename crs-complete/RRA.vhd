library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;


entity RRA is
	PORT( 	
		REQ: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		ACK: IN STD_LOGIC;
		CLK: IN STD_LOGIC;
		RST: IN STD_LOGIC;
		GRANT: INOUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
end RRA;

architecture ARCH_RRA of RRA is
-- pure combinatorial not possible, because
-- a state should stay for a finite amount of time

--	function get_next_grant (gr: std_logic_vector(n-1 downto 0);
--			request : std_logic_vector(n-1 downto 0)) 
--		return std_logic_vector is--std_logic_vector(n-1 downto 0) is
--		variable next_grant : std_logic_vector(n-1 downto 0) 
--			:= (others => '0');
--		variable next_grant_int, curr_grant_int : integer := 0;
--		variable req_found : std_logic := '0';
--	begin
--		curr_grant_int := vector_to_integer(gr);
--		req_found := '0';
--		for i in curr_grant_int+1 to n-1 loop
--			if request(i) = '1' then
--				next_grant_int := i;
--				req_found := '1';
--				exit;
--			end if;
--		end loop;
--		if (req_found = '0') then
--			for i in 0 to curr_grant_int loop
--				if request(i) = '1' then
--					next_grant_int := i;
--					req_found := '1';
--					exit;
--				end if;
--			end loop;
--		end if;
--		next_grant(next_grant_int) := '1';
--		report integer'image(next_grant_int);
--		return next_grant;
--	end get_next_grant;
	
begin

	process(clk,rst) is
		variable next_grant_int, curr_grant_int : integer := 0;
		variable req_found : std_logic := '0';
		variable i : integer;
		--variable grant_temp : std_logic_vector := "0000";
	begin
		if (rising_edge(clk)) then
			if (rst = '1') or (ack = '1') then
				curr_grant_int := vector_to_integer(grant);
				i := curr_grant_int + 1;
				-- find the next request, in cyclic order
				for unused in 0 to n-1 loop
					if (i = curr_grant_int) then exit; end if;
					if i > n-1 then i := 0; end if;
					if req(i) = '1' then
						next_grant_int := i;
						exit;
					end if;
					i := i + 1;
				end loop;
				grant(curr_grant_int) <= '0';
				grant(next_grant_int) <= '1';
				curr_grant_int := next_grant_int;
			end if;
		end if;
	end process;
end ARCH_RRA;