library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;
entity ARBITER is
  PORT( 	
    clk : in std_logic;
    rst : in std_logic;
    buf_data : in data_bus_vector(n-1 downto 0);
    buf_data_av : in std_logic_vector(n-1 downto 0);
    buf_data_rd : out std_logic_vector(n-1 downto 0);
    exp_data : in data_bus_vector(n-1 downto 0);
    exp_data_av : in std_logic_vector(n-1 downto 0);
    exp_data_rd : out std_logic_vector(n-1 downto 0);
--    GRANT_EXT: out STD_LOGIC_VECTOR(n-1 downto 0);
--    buf_req_ext, exp_req_ext: inout std_logic_vector(n-1 downto 0);
--    buf_rd_ext, exp_rd_ext : inout std_logic_vector(n-1 downto 0);
--    exp_granted : inout std_logic;
--    ack_ext : out std_logic;
    OUT_DATA_AV: OUT STD_LOGIC;
    OUT_DATA_RD: IN STD_LOGIC;
    OUT_DATA: OUT data_bus
    );
end ARBITER;

architecture ARCH_ARBITER of ARBITER is

	-- comment while debugging 
	signal grant_ext, buf_req_ext, exp_req_ext, buf_rd_ext, exp_rd_ext 
		: std_logic_vector(n-1 downto 0);
	signal exp_granted, ack_ext : std_logic;
  
  COMPONENT fifo
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(data_bus_size-1 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(data_bus_size-1 DOWNTO 0);
      full : OUT STD_LOGIC;
      almost_full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC);
  END COMPONENT;

  component RRA is
    PORT( 	
      REQ: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      ACK: IN STD_LOGIC;
      CLK: IN STD_LOGIC;
      RST: IN STD_LOGIC;
      GRANT: INOUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
  end component;
  
  signal p_buf_data, p_exp_data, exp_dout, buf_dout : data_bus_vector(n-1 downto 0);
  signal exp_empty, exp_req, exp_full, exp_pf, exp_grant, exp_rd,
    p_exp_grant, p_exp_req, pp_exp_req
    : std_logic_vector(n-1 downto 0);
  signal buf_empty, buf_req, buf_full, buf_pf, buf_grant, buf_rd,
    p_buf_grant, p_buf_req, pp_buf_req
    : std_logic_vector(n-1 downto 0);
  signal exp_rst, buf_rst, ack, p_ack, out_data_temp_av, exp_ack, buf_ack,
	data_outstanding, p_data_outstanding: std_logic := '0';
  signal out_data_temp : data_bus := (others => '0');
  signal exp_gint, buf_gint, p_exp_gint, p_buf_gint : integer := 0;
  signal grant : std_logic_vector(n-1 downto 0);
  
  constant zeros : std_logic_vector(n-1 downto 0) := (others => '0');
  
  signal pk_com_exp, pk_com_buf, wr_en_exp, wr_en_buf : std_logic_vector(n-1 downto 0) := (others => '0');
  
  function is_end_of_packet (db: data_bus) return std_logic is
    variable i : integer := dv_bit_interval-1;
  begin
    while (i < data_bus_size) loop
      if (db(i) = '0') then 
        return '1';
      end if;
      i := i + dv_bit_interval;
    end loop;
    return '0'; -- not the end of packet
  end is_end_of_packet;
  
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
  
begin
  buf_req_ext <= buf_req;
  exp_req_ext <= exp_req;
  buf_rd_ext <= buf_rd;
  exp_rd_ext <= exp_rd;
  ack_ext <= ack;
  
  out_data <= out_data_temp;
  out_data_av <= out_data_temp_av;
  fifos:
  for i in 0 to n-1 generate
    set_pk_com_exp: process(clk, rst) is
    begin
      if rst = '1' then
        pk_com_exp(i) <= '0';
        p_exp_data(i) <= (others => '0');
      elsif rising_edge(clk) then
        if exp_data_av(i) = '1' then
          if exp_pf(i) = '0' then
            wr_en_exp(i) <= '1';
            pk_com_exp(i) <= '0';
          else
            if pk_com_exp(i) = '0' then
              wr_en_exp(i) <= '1';
              if is_end_of_packet(exp_data(i)) = '1' then
                pk_com_exp(i) <= '1';
              end if;
            else 
              wr_en_exp(i) <= '0';
            end if;
            
          end if;
        else
          wr_en_exp(i) <= '0';
        end if;
        p_exp_data(i) <= exp_data(i);
      end if;
    end process;  
--		wr_en_exp(i) <= exp_data_av(i) when exp_pf(i) = '0' and exp_granted = '1' 
--														and pk_com_exp(i) = '0'
--							 else '0';
    fifo_exp: fifo port map(
      rst => '0',
      clk => clk,
      din => p_exp_data(i),
      wr_en => wr_en_exp(i), -- writing is straight-forward
      rd_en => exp_rd(i), -- reading is not so;
      -- may be, it can be when rra has no delay
      dout => exp_dout(i), -- will be used for looping below
      full => exp_full(i), -- ignoring almost_full
      empty => exp_empty(i),
      prog_full => exp_pf(i)
      );
    exp_data_rd(i) <= wr_en_exp(i);
    
    set_pk_com_buf: process(clk, rst) is
    begin
      if rst = '1' then
        pk_com_buf(i) <= '0';
        p_buf_data(i) <= (others => '0');
      elsif rising_edge(clk) then
        if buf_data_av(i) = '1' then
          if buf_pf(i) = '0' then
            wr_en_buf(i) <= '1';
            pk_com_buf(i) <= '0';
          else
            if pk_com_buf(i) = '0' then
              wr_en_buf(i) <= '1';
              if is_end_of_packet(buf_data(i)) = '1' then
                pk_com_buf(i) <= '1';
              end if;
            else 
              wr_en_buf(i) <= '0';
            end if;
            
          end if;
        else
          wr_en_buf(i) <= '0';
        end if;
        p_buf_data(i) <= buf_data(i);
      end if;
    end process;	
    
    
--		wr_en_buf(i) <= buf_data_av(i) when (buf_pf(i) = '0' and pk_com_buf(i) = '0') 
--														 and exp_granted = '0'
--							 else '0';
    fifo_buf: fifo port map(
      rst => '0',
      clk => clk,
      din => p_buf_data(i),
      wr_en => wr_en_buf(i), -- writing is straight-forward
      rd_en => buf_rd(i), -- reading is not so;
      -- may be, it can be when rra has no delay
      dout => buf_dout(i), -- will be used for looping below
      full => buf_full(i), -- ignoring almost_full
      empty => buf_empty(i),
      prog_full => buf_pf(i)
      );
    buf_data_rd(i) <= wr_en_buf(i);
  end generate;

  -- ================================= READING =================================
  -- ALL THE FOLLOWING CODE IS EXCLUSIVELY FOR READING !!
  exp_gint <= vector_to_integer(exp_grant);
  buf_gint <= vector_to_integer(buf_grant);
  
  exp_req <= not exp_empty;
  buf_req <= not buf_empty;
             
  grant_ext <= exp_grant;

  rra_exp: rra
    port map(
      req => exp_req,
      ack => exp_ack,
      clk => clk,
      rst => exp_rst,
      grant => exp_grant
      );     
  rra_buf: rra
    port map(
      req => buf_req,
      ack => buf_ack,
      clk => clk,
      rst => buf_rst,
      grant => buf_grant
      );
 
  
  process(clk,rst) is
  begin
    if rst='1' then
      exp_granted <= '0';
    elsif rising_edge(clk) then
      if ack = '1' then
        if not(exp_req = zeros) then 
          exp_granted <= '1';
        else
          exp_granted <= '0';
        end if;
      end if;
    end if;
  end process;
  
--  exp_granted <= '1' when not (exp_req = zeros) else '0';
  grant <= exp_grant when exp_granted = '1' else buf_grant;

  -- Keep rra's in reset state, whenever there are no requests.
  -- This avoids requiring ack to change the current grant.
  -- But, should the resets be separate? For simplicity let them be separate.
  exp_rst <= '1' when exp_req = zeros or exp_granted = '0' else '0';
  buf_rst <= '1' when buf_req = zeros else '0';
 -- process(clk,rst) is
 -- begin
 --   if rst='1' then
 --     exp_rst <= '1';
 --     buf_rst <= '1';     
 --   elsif rising_edge(clk) then
 --     if exp_req = zeros then
 --       exp_rst <= '1';
 --     else
 --       exp_rst <= '0';
 --     end if;
 --     if buf_req = zeros then
 --       buf_rst <= '1';
 --     else
 --       buf_rst <= '0';
 --     end if;
 --   end if;
 -- end process;


  -- ACK should be high, only when the current packet contains a '0' dv-bit.
  -- Then, why the below complications?
  ack <= is_end_of_packet(out_data_temp) and out_data_temp_av;

  buf_ack <= ack when exp_granted = '0' else '0';
  exp_ack <= ack when exp_granted = '1' else '0';
  
  -- 1. Stop reading when the ack is high, since rra's take one cycle to change
  -- the grant.
  -- 2. Though, why act on the basis of the p_req instead of the req
  -- >> because grants correspond to the request of the previous cycles
  
  exp_rd <= exp_grant when ack = '0' and not (p_exp_req = zeros)
            and exp_granted = '1' and data_outstanding = '0' else
            zeros;
  buf_rd <= buf_grant when ack = '0' and not (p_buf_req = zeros)
            and not(exp_granted) = '1' and data_outstanding = '0' else
            zeros;
  
  out_data_temp <= exp_dout(p_exp_gint) when exp_granted = '1' else
                   buf_dout(p_buf_gint);
						
--	data_outstanding <= '1' when ((not (exp_rd=zeros)) or (not (buf_rd=zeros))) 
--									and out_data_rd = '0'
	process(clk,rst) is
  begin
    if rst = '1' then
      data_outstanding <= '0';
    elsif rising_edge(clk) then
      if ((not (exp_rd=zeros)) or (not (buf_rd=zeros))) and out_data_rd = '0' then
        data_outstanding <= '1';
		  report "data outstanding";
      elsif exp_rd = zeros and buf_rd=zeros and out_data_rd='1' then
        data_outstanding <= '0';
		else
			data_outstanding <= data_outstanding;
      end if;
    end if;
  end process;

  -- out_data_av is high iff rd_sig in last clock cycle was non-zeros
  process(clk,rst) is
  begin
    if rst = '1' then
      out_data_temp_av <= '0';
    elsif rising_edge(clk) then
      if (buf_rd = zeros and exp_rd = zeros) and data_outstanding = '0' then
        out_data_temp_av <= '0';
      else
        out_data_temp_av <= '1';
      end if;
    end if;
  end process;

  -- assigning p-variables
  process(clk,rst)
  begin
    if rst = '1' then
      p_exp_req <= zeros;
      p_buf_req <= zeros;
      p_ack <= '0';
    elsif rising_edge(clk) then
      p_ack <= ack;
      p_exp_req <= exp_req;
		pp_exp_req <= p_exp_req;
      p_buf_req <= buf_req;
		pp_buf_req <= p_buf_req;
      p_exp_grant <= exp_grant;
      p_buf_grant <= buf_grant;
      p_exp_gint <= exp_gint;
      p_buf_gint <= buf_gint;
		p_data_outstanding <= data_outstanding;
    end if;
  end process;
end ARCH_ARBITER;
