--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:01:01 04/26/2019
-- Design Name:   
-- Module Name:   /home/shubhamkar/Dropbox/IIT Bombay/Fourth Semester/CS 226 - DLD/Labs/CRS/crs/tb_crs.vhd
-- Project Name:  crs
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CRS
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

use work.globals.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_crs IS
END tb_crs;
 
ARCHITECTURE behavior OF tb_crs IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CRS
    PORT(
			CLK : IN STD_LOGIC;
			RST : IN STD_LOGIC;
         EXP_DATA_AV : IN  std_logic_vector(N-1 downto 0);
         EXP_DATA_RD : OUT  std_logic_vector(N-1 downto 0);
         EXP_DATA : IN  data_bus_vector(N-1 downto 0);
			BUF_DATA_AV: IN STD_LOGIC_VECTOR(N-1 downto 0);
			BUF_DATA_RD: OUT STD_LOGIC_VECTOR(N-1 downto 0);
			BUF_DATA: IN data_bus_vector(n-1 downto 0);
			OUTPUT_PORT: IN output_port_VECTOR(N-1 downto 0);
			OUTPUT_PORT_VALID: IN STD_LOGIC_VECTOR(N-1 downto 0);
			OUTPORT_DATA_AV: OUT STD_LOGIC_VECTOR(N-1 downto 0);
			OUTPORT_DATA_RD: IN STD_LOGIC_VECTOR(N-1 downto 0);
			OUTPORT_DATA: OUT data_bus_vector(n-1 downto 0)
        );
    END COMPONENT;
    

   signal EXP_DATA_AV, buf_data_av, outport_data_av : std_logic_vector(N-1 downto 0) := (others => '0');
   signal EXP_DATA, buf_data, outport_data : data_bus_vector(N-1 downto 0) := (others => (others => '0'));

   signal EXP_DATA_RD, buf_data_rd, outport_data_rd : std_logic_vector(N-1 downto 0);
	
	signal output_port_valid : std_logic_vector(n-1 downto 0) := (others => '0');
	signal output_port : output_port_vector(n-1 downto 0) := (others => (others => '0'));
	
	signal clk, rst : std_logic := '0';				
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CRS PORT MAP (
			 clk => clk,
			 rst => rst,
          EXP_DATA_AV => EXP_DATA_AV,
          EXP_DATA_RD => EXP_DATA_RD,
          EXP_DATA => EXP_DATA,
			 buf_DATA_AV => buf_DATA_AV,
          buf_DATA_RD => buf_DATA_RD,
          buf_DATA => buf_DATA,
			 output_port => output_port,
			 output_port_valid => output_port_valid,
			 outport_data_av => outport_data_av,
			 outport_data_rd => outport_data_rd,
			 outport_data => outport_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		rst <= '1'; -- note rst for fifo is '0': see ARBITER.vhd;
		wait for 2.5*clk_period; -- wait for fifo initialization
		rst <= '0';

		-- normal test
		-- testing that programmable full and the basic system works, and 
		buf_data(0) <= "111110001100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(0) <= '1';		
		buf_data(1) <= "100011111100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(1) <= '1';		
		buf_data(2) <= "101010001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(2) <= '1';
		outport_data_rd <= (others => '1');
		output_port(0) <= "00000001";
		output_port_valid(0) <= '1';
		output_port(1) <= "00000001";
		output_port_valid(1) <= '1';
		output_port(2) <= "00000001";
		output_port_valid(2) <= '1';
		output_port(3) <= "00000001";
		output_port_valid(3) <= '1';
		-- We have a fifo of size 16, with threshold of 5;
		-- this, therefore, assumes a maximum packet length of 11 data chunks.
		wait for 4 * clk_period;
		outport_data_rd(1) <= '0';
		wait for 2 * clk_period;
		outport_data_rd(1) <= '1';
		buf_data(0) <= "011110000100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(1) <= "000011110100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(2) <= "001010000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		wait for clk_period;
		-- This forms a packet length of 8 data chunks each.
		buf_data(0) <= "101010001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(1) <= "101010001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(2) <= "111110001100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		wait for 3*clk_period;
		buf_data(0) <= "001000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(1) <= "001000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(2) <= "011100001100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		wait for clk_period;
		-- Expectation: buf_data_rd(1,2) should be low for the last 4 clk_periods.
		buf_data_av <= (others => '0');

		-- However, output should now be for the exp_data
		exp_data(3) <= "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		exp_data_av(3) <= '1';
		exp_data(2) <= "111110001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		exp_data_av(2) <= '1';
		wait for 4*clk_period;
		exp_data(3) <= "011111110111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		exp_data_av(3) <= '1';
		exp_data(2) <= "011110000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		exp_data_av(2) <= '1';
		wait for clk_period;
		exp_data_av <= (others => '0');

		buf_data(3) <= "111111101111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(3) <= '1';
		output_port(3) <= "00000011";
		output_port_valid(3) <= '1';
		wait for 2*clk_period;
		buf_data(3) <= "011111100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(3) <= '1';
		wait for clk_period;
		buf_data_av <= (others => '0');


		wait for 30 * clk_period; -- let the buffers empty
		buf_data(0) <= "100010001100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(0) <= '1';
		buf_data(1) <= "100011111100111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data_av(1) <= '1';
		wait for clk_period;
		buf_data(0) <= "000000001000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		buf_data(1) <= "000001111000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
		wait for clk_period;
		buf_data_av <= (others => '0');
		-- things should work normally
		
		
		
--		buf_data(0) <= "100110111000";
--		buf_data_av(0) <= '1';
--		output_port(0) <= "00000000";
--		output_port_valid(0) <= '1';
--		wait for clk_period;
--		buf_data(0) <= "100110110000";
--		wait for clk_period;
--		buf_data_av <= (others => '0');
--		output_port_valid <= (others => '0');
      wait;
   end process;

END;
