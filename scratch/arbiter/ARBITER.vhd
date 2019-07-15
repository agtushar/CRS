library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.globals.all;

entity ARBITER is
	PORT( EXP_DATA: IN DATA_BUS_VECTOR(0 to N-1);
			EXP_DATA_AV: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			EXP_DATA_RD: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			BUF_DATA: IN DATA_BUS_VECTOR(0 to N-1);
			BUF_DATA_AV: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			BUF_DATA_RD: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			OUTPORT_DATA: OUT DATA_BUS;
			OUTPORT_DATA_AV: OUT STD_LOGIC;
			OUTPORT_DATA_RD: IN STD_LOGIC;
			CLK: IN STD_LOGIC;
			RST: IN STD_LOGIC);
end ARBITER;

architecture ARCH_ARBITER of ARBITER is
	constant buf_size : integer := 4; -- change to 1000 later
	signal exp_buf, buf_buf 
			: data_bus_vector(0 to (buf_size / 2 - 1));
	signal exp_buf_lim, buf_buf_lim : integer := 0; 
	-- increment on adding packet data to buf, and decrement on removing
	
	constant packet_buf_size : integer := 20;
	type packet_buffer is array (0 to n-1) of data_bus_vector(0 to packet_buf_size-1);
	type packet_buffer_index is array(0 to n-1) of integer;
	 -- how big can a packet be?
	signal exp_packet_buf, buf_packet_buf 
		: packet_buffer;
	-- we do not want to send "incomplete packets" on outport_data
	--
	-- alternative implementation includes maintaining a packet_id
	-- corresponding to each packet, and then "searching" for it while sending
	signal exp_pk_buf_lim, buf_pk_buf_lim: packet_buffer_index := (others => 0);
	signal exp_pk_com, buf_pk_com : std_logic_vector(n-1 downto 0) := (others => '0'); 
	signal current_pk_index : integer := 0;
	-- high indicates whole packet is available for sending
	
	function is_end_of_packet (db: data_bus) return std_logic is
		variable i : integer := dv_bit_interval-1;
	begin
		while (i < data_bus_size) loop
			if (db(i-1) = '0') then 
				return '1';
			end if;
			i := i + dv_bit_interval;
		end loop;
		return '0'; -- not the end of packet
	end is_end_of_packet;
begin
	
	process(clk) is
	begin
		if (clk='1' and clk'event) then
			if rst='1' then
				exp_buf <= (others => (others => '0'));
				buf_buf <= (others => (others => '0'));
				EXP_DATA_RD <= (others => '0');
				BUF_DATA_RD <= (others => '0');
				OUTPORT_DATA <= (others => '0');
				OUTPORT_DATA_AV <= '0';
			else
				for i in 0 to n-1 loop
					if exp_data_av(i) = '1' then
						exp_data_rd(i) <= '1';
						if exp_pk_buf_lim(i) = packet_buf_size then -- drop packets
							report "Express packet buffer overflow! Data chunk is being dropped!"; 
						elsif exp_pk_buf_lim(i) < packet_buf_size then
							exp_packet_buf(i)(exp_pk_buf_lim(i)) <= exp_data(i);
							if is_end_of_packet(exp_data(i)) = '1' then
								exp_pk_com(i) <= '1';
							end if;
						end if;
					end if;
					-- such separate queues do not take advantage in the case when
					-- there are exp packets to be sent and space is available in the 
					-- buf queue.but not on the exp queue
					if buf_data_av(i) = '1' then
						buf_data_rd(i) <= '1';
						if buf_pk_buf_lim(i) = packet_buf_size then -- drop packets
							report "Express packet buffer overflow! Data chunk is being dropped!"; 
						elsif buf_pk_buf_lim(i) < packet_buf_size then
							buf_packet_buf(i)(buf_pk_buf_lim(i)) <= buf_data(i);
							if is_end_of_packet(buf_data(i)) = '1' then
								buf_pk_com(i) <= '1';
							end if;
						end if;
					end if;
				end loop;
			end if;
		end if;
	end process;

	
	-- second attempt at algo ----------------------------
	--
	-- while some exp-data-av port is high
	-- 	transfer data to outport-exp-buffer
	-- similarly for buf-data
	-- note: two separate buffers are maintained
	--	
	-- while outport-exp-buffer is non-empty
	-- 	whenever outport-data-rd is high
	-- 		transfer one packet from buffer to outport
	-- while outport-exp-buffer is empty
	--	and outport-buf-buffer is non-empty
	-- 	whenever outport-data-rd is high
	-- 		transfer one packet from buffer to outport

end ARCH_ARBITER;