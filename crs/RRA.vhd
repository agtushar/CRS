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
	signal curr_pos : integer := 0;
begin
--	grant <= "0001" when (grant(0) = '1' and ack = '0')
--								or (ack = '1' and req(0)='1'
--								and ((grant(1) = '1' and req(2) = '0' and req(3) = '0')
--									 or (grant(2) = '1' and req(3) = '0')
--									 or (grant(3) = '1')) else
--				"0010" when (grant(1) = '1' and ack = '0')
--								or (ack = '1' and req(0)='1'
--								and ((grant(1) = '1' and req(2) = '0' and req(3) = '0')
--									 or (grant(2) = '1' and req(3) = '0')
--									 or (grant(3) = '1')) else
	
	process(clk,rst) is
		variable next_pos : integer := 0;
		variable req_found : std_logic := '0';
		--variable grant_temp : std_logic_vector := "0000";
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				grant <= (others => '0');
				for i in 0 to n-1 loop
					if req(i) = '1' then
						next_pos := i;
						req_found := '1';
						exit;
					end if;
				end loop;
				grant(next_pos) <= '1';
				curr_pos <= next_pos;
			else
				if (ack = '1') then
					req_found := '0';
					for i in curr_pos+1 to n-1 loop
						if req(i) = '1' then
							next_pos := i;
							req_found := '1';
							exit;
						end if;
					end loop;
					if (req_found = '0') then
						for i in 0 to curr_pos loop
							if req(i) = '1' then
								next_pos := i;
								req_found := '1';
								exit;
							end if;
						end loop;
					end if;
					
					grant(curr_pos) <= '0';
					grant(next_pos) <= '1';
					curr_pos <= next_pos;
				end if;
			end if;
		end if;
	end process;
end ARCH_RRA;