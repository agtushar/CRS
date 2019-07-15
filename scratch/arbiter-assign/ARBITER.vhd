library ieee;
use ieee.std_logic_1164.all;

entity ARBITER is
  PORT( 	
    DATA0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DATA1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DATA2: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DATA3: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DV : IN std_logic_vector(3 downto 0);
    AV : IN std_logic_vector(3 downto 0);
    OP: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    OP_VALID: inout STD_LOGIC;
    GRANT_EXT: out STD_LOGIC_VECTOR(3 downto 0);
    REQUEST: inout std_logic_vector(3 downto 0);
	 rd_sig : out std_logic_vector(3 downto 0);
    ack_ext : out std_logic;
    CLK: IN STD_LOGIC;
    RST: IN STD_LOGIC);
end ARBITER;

architecture ARCH_ARBITER of ARBITER is
  
  COMPONENT fifo
    PORT (
      rst : IN STD_LOGIC;
      wr_clk : IN STD_LOGIC;
      rd_clk : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC
      );
  END COMPONENT;

  component RRA is
    PORT( 	
      REQ: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ACK: IN STD_LOGIC;
      CLK: IN STD_LOGIC;
      RST: IN STD_LOGIC;
      GRANT: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0));
  end component;
  
  type fifo_bus_vector is array (0 to 3) of std_logic_vector(4 downto 0);
  signal din, dout : fifo_bus_vector;

  type data_bus_vector is array (0 to 3) of std_logic_vector(3 downto 0);
  signal data : data_bus_vector;
  signal wr_en, rd_en, grant, zero, full, empty, prog_full, p_req, pp_req, p_grant
    : std_logic_vector(3 downto 0) := "0000";
  signal ack, p_ack, rst_rra: std_logic;
  signal grant_integer, prev_grant : integer := 0;


-- generate wr_clk
-- generate rd_clk;
begin
	
  --dv <= dv3 & dv2 & dv1 & dv0;
  data(0) <= data0;
  data(1) <= data1;
  data(2) <= data2;
  data(3) <= data3;
  ack_ext <= ack;
  wr_en <= av;
  n_fifos:
  for i in 0 to 3 generate
	 din(i) <= data(i) & dv(i);
    fifox: fifo port map(
      rst => '0',
      wr_clk => clk,
      rd_clk => clk,
      din => din(i),
      wr_en => wr_en(i),
      rd_en => rd_en(i),
      dout => dout(i),
      full => full(i),
      empty => empty(i),
      prog_full => prog_full(i)
      );
  end generate;
  

  rra_inst: rra
    port map(
      req => request,
      ack => ack,
      clk => clk,
      rst => rst_rra,
      grant => grant
      );
  
  request <= not(empty);
  grant_ext <= grant;
  grant_integer <= 0 when grant(0)='1' else
						 1 when grant(1)='1' else
						 2 when grant(2)='1' else
						 3 when grant(3)='1';
						 
	process(clk,rst) is
	begin
		if rst='1' then
			rst_rra <= '1';
		elsif rising_edge(clk) then
			if request = "0000" then
				rst_rra <= '1';
			else
				rst_rra <= '0';
			end if;
		end if;
	end process;
	
	ack <= '0' when (p_req = "0000" or not (grant_integer = prev_grant) or p_ack = '1')
						  else
			 op_valid and not (dout(grant_integer)(0));
						 
  rd_sig <= rd_en;
  
	process(clk,rst) is
	begin
		if rst = '1' then
			op_valid <= '0';
		elsif rising_edge(clk) then
			if not (rd_en = "0000") then
				op_valid <= '1';
			else
				op_valid <= '0';
			end if;
		end if;
	end process;
					
	process(clk,rst) is
	begin
		if rising_edge(clk) then
			p_ack <= ack;
		end if;
	end process;
  
	process(clk,rst)
		variable ppp_req: std_logic_Vector(3 downto 0) := request;
		-- to handle rd_en lag
	begin
		if rst = '1' then
			p_req <= "0000";
			pp_req <= "0000";
		elsif rising_edge(clk) then
			ppp_req := pp_req;
			pp_req <= p_req;
			p_req <= request;
			p_grant <= grant;
			prev_grant <= grant_integer;
		end if;
	end process;
	
	rd_en <= grant when ack = '0' and not (p_req = "0000") else
				(others => '0');
	op <= dout(grant_integer)(4 downto 1);
end ARCH_ARBITER;
