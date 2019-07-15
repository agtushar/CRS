--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:22:57 04/03/2019
-- Design Name:   
-- Module Name:   /home/shubhamkar/Dropbox/IIT Bombay/Fourth Semester/CS 226 - DLD/Labs/cs254/lab09/arbiter-assign/tb_rra.vhd
-- Project Name:  arbiter-assign
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RRA
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
 
ENTITY tb_rra IS
END tb_rra;
 
ARCHITECTURE behavior OF tb_rra IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RRA
    PORT(
         REQ : IN  std_logic_vector(n-1 downto 0);
         ACK : IN  std_logic;
         CLK : IN  std_logic;
         RST : IN  std_logic;
         GRANT : INOUT  std_logic_vector(n-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal REQ : std_logic_vector(n-1 downto 0) := (others => '0');
   signal ACK : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

	--BiDirs
   signal GRANT : std_logic_vector(n-1 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RRA PORT MAP (
          REQ => REQ,
          ACK => ACK,
          CLK => CLK,
          RST => RST,
          GRANT => GRANT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for clk_period / 2;
      rst <= '1';
      req <= (others => '0');
		req(1) <= '1';
		wait for clk_period;
		rst <= '0';
		wait for clk_period;
		ack <= '1';
		wait for clk_period;
		ack <= '0';
      req <= (others => '0');
		req(0) <= '1'; req(1) <= '1';
		wait for clk_period;
		ack <= '1';
		wait for clk_period;
		ack <= '0';
		wait for 3*clk_period;
		ack <= '1';
		wait for clk_period;
		ack <= '0';
		req <= (others => '0');
      wait;
   end process;

END;
