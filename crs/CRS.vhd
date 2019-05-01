library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;

entity CRS is
  PORT(
    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;
    EXP_DATA_AV: IN STD_LOGIC_VECTOR(N-1 downto 0);
    EXP_DATA_RD: OUT STD_LOGIC_VECTOR(N-1 downto 0);
    EXP_DATA: IN DATA_BUS_VECTOR(N-1 downto 0);
    BUF_DATA_AV: IN STD_LOGIC_VECTOR(N-1 downto 0);
    BUF_DATA_RD: OUT STD_LOGIC_VECTOR(N-1 downto 0);
    BUF_DATA: IN data_bus_vector(n-1 downto 0);
    OUTPUT_PORT: IN output_port_VECTOR(N-1 downto 0);
    OUTPUT_PORT_VALID: IN STD_LOGIC_VECTOR(N-1 downto 0);
    OUTPORT_DATA_AV: inOUT STD_LOGIC_VECTOR(N-1 downto 0);
    OUTPORT_DATA_RD: IN STD_LOGIC_VECTOR(N-1 downto 0);
    OUTPORT_DATA: inOUT data_bus_vector(n-1 downto 0));
end CRS;

architecture ARCH_CRS of CRS is
  component VOQ is
    port(
      data_av_in : in std_logic;
      data_rd_in : out std_logic;
      data_in : in data_bus;
      output_port_valid : in std_logic; 
      output_port : in output_port_bus;
      data_out : out data_bus_vector(n-1 downto 0);
      data_av_out : out std_logic_vector(n-1 downto 0);
      data_rd_out : in std_logic_vector(n-1 downto 0));
  end component;
  
  component arbiter is
    port(
      clk : in std_logic;
      rst : in std_logic;
      buf_data : in data_bus_vector(n-1 downto 0);
      buf_data_av : in std_logic_vector(n-1 downto 0);
      buf_data_rd : out std_logic_vector(n-1 downto 0);
      exp_data : in data_bus_vector(n-1 downto 0);
      exp_data_av : in std_logic_vector(n-1 downto 0);
      exp_data_rd : out std_logic_vector(n-1 downto 0);
      OUT_DATA_AV: INOUT STD_LOGIC;
      OUT_DATA_RD: IN STD_LOGIC;
      OUT_DATA: INOUT data_bus;
      GRANT_EXT: out STD_LOGIC_VECTOR(n-1 downto 0);
      buf_req_ext, exp_req_ext: inout std_logic_vector(n-1 downto 0);
      buf_rd_ext, exp_rd_ext : inout std_logic_vector(n-1 downto 0);
      exp_granted : inout std_logic;
      ack_ext : out std_logic);
  end component;

  type slv_vector is array(n-1 downto 0) of std_logic_vector(n-1 downto 0);
  signal exp_data_av_out, exp_data_rd_out, buf_data_av_out, 
	buf_data_rd_out : slv_vector;
  
  type dbvec_vector is array(n-1 downto 0) of data_bus_vector(n-1 downto 0);
  signal exp_data_out, buf_data_out : dbvec_vector;
begin
  components: 
    for i in 0 to n-1 generate
      exp_voq: voq port map(
        data_av_in => exp_data_av(i),
        data_rd_in => exp_data_rd(i),
        data_in => exp_data(i),
        output_port_valid => output_port_valid(i),
        output_port => output_port(i),
        data_out => exp_data_out(i),
        data_av_out => exp_data_av_out(i),
        data_rd_out => exp_data_rd_out(i)
        );
      buf_voq : voq port map(
        data_av_in => buf_data_av(i),
        data_rd_in => buf_data_rd(i),
        data_in => buf_data(i),
        output_port_valid => output_port_valid(i),
        output_port => output_port(i),
        data_out => buf_data_out(i),
        data_av_out => buf_data_av_out(i),
        data_rd_out => buf_data_rd_out(i)
        );
      arbiters : arbiter port map(
        clk => clk,
        rst => rst,
        buf_data => buf_data_out(n-1 downto 0)(i),
        buf_data_av => buf_data_av_out(n-1 downto 0)(i),
        buf_data_rd => buf_data_rd_out(n-1 downto 0)(i),
        exp_data => exp_data_out(n-1 downto 0)(i),
        exp_data_av => exp_data_av_out(n-1 downto 0)(i),
        exp_data_rd => exp_data_rd_out(n-1 downto 0)(i),
        OUT_DATA_AV => outport_data_av(i),
        OUT_DATA_RD => outport_data_rd(i),
        OUT_DATA => outport_data(i)
        -- GRANT_EXT: out STD_LOGIC_VECTOR(n-1 downto 0);
        -- buf_req_ext, exp_req_ext: inout std_logic_vector(n-1 downto 0);
        -- buf_rd_ext, exp_rd_ext : inout std_logic_vector(n-1 downto 0);
        -- exp_granted : inout std_logic;
        -- ack_ext : out std_logic
        );
    end generate;



end ARCH_CRS;
