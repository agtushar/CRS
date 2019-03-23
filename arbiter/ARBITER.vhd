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
			OUTPORT_DATA: OUT STD_LOGIC_VECTOR(data_bus_size-1 DOWNTO 0);
			OUTPORT_DATA_AV: OUT STD_LOGIC;
			OUTPORT_DATA_RD: IN STD_LOGIC);
end ARBITER;

architecture ARCH_ARBITER of ARBITER is
begin
end ARCH_ARBITER;