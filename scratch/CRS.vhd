library ieee;
use ieee.std_logic_1164.all;

entity CRS is
	PORT( 	EXP_DATA_AV: IN STD_LOGIC;
		EXP_DATA_RD: OUT STD_LOGIC;
		EXP_DATA: IN STD_LOGIC;
		BUF_DATA_AV: IN STD_LOGIC;
		BUF_DATA_RD: OUT STD_LOGIC;
		BUF_DATA: IN STD_LOGIC;
		OUTPUT_PORT: IN STD_LOGIC;
		OUTPUT_PORT_VALID: IN STD_LOGIC;
		OUTPORT_DATA_AV: OUT STD_LOGIC;
		OUTPORT_DATA_RD: IN STD_LOGIC;
		OUTPORT_DATA: OUT STD_LOGIC);
end CRS;

architecture ARCH_CRS of CRS is
begin
end ARCH_CRS;