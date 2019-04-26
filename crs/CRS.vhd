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
		OUTPORT_DATA_AV: OUT STD_LOGIC_VECTOR(N-1 downto 0);
		OUTPORT_DATA_RD: IN STD_LOGIC_VECTOR(N-1 downto 0);
		OUTPORT_DATA: OUT data_bus_vector(n-1 downto 0));
end CRS;

architecture ARCH_CRS of CRS is
begin
end ARCH_CRS;