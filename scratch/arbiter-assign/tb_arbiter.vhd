--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:43:22 04/03/2019
-- Design Name:   
-- Module Name:   /home/shubhamkar/Dropbox/IIT Bombay/Fourth Semester/CS 226 - DLD/Labs/cs254/lab09/arbiter-assign/tb_arbiter.vhd
-- Project Name:  arbiter-assign
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ARBITER
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_arbiter IS
END tb_arbiter;
 
ARCHITECTURE behavior OF tb_arbiter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ARBITER
    PORT(
         DATA0 : IN  std_logic_vector(3 downto 0);
         DATA1 : IN  std_logic_vector(3 downto 0);
         DATA2 : IN  std_logic_vector(3 downto 0);
         DATA3 : IN  std_logic_vector(3 downto 0);
         DV : IN std_logic_vector(3 downto 0);
         AV : IN std_logic_vector(3 downto 0);
			OP : OUT  std_logic_vector(3 downto 0);
			op_valid : inout std_logic;
			grant_ext : OUT  std_logic_vector(3 downto 0);			
			request : inOUT  std_logic_vector(3 downto 0);
			rd_sig : OUT  std_logic_vector(3 downto 0);
			ack_ext : out std_logic;
			CLK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal DATA0 : std_logic_vector(3 downto 0) := (others => '0');
   signal DATA1 : std_logic_vector(3 downto 0) := (others => '0');
   signal DATA2 : std_logic_vector(3 downto 0) := (others => '0');
   signal DATA3 : std_logic_vector(3 downto 0) := (others => '0');
   signal DV : std_logic_vector(3 downto 0) := (others => '0');
   signal AV: std_logic_vector(3 downto 0) := (others => '0');
   
   signal CLK, ack : std_logic := '0';
   signal RST, op_valid : std_logic := '0';

 	--Outputs
   signal OP, grant, request, rd_sig : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ARBITER PORT MAP (
          DATA0 => DATA0,
          DATA1 => DATA1,
          DATA2 => DATA2,
          DATA3 => DATA3,
          DV => DV,
			 AV => AV,
			 grant_ext => grant,
			 request => request,
			 rd_sig => rd_sig,
			 ack_ext => ack,
          OP => OP,
			 op_valid => op_valid,
          CLK => CLK,
          RST => RST
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
		rst <= '1'; -- note rst for fifo is '0': see ARBITER.vhd;
		wait for 2.5*clk_period; -- wait for fifo initialization
		rst <= '0';			
			data0 <= "1111";
			data1 <= "1010";
			dv <= "0011";
			av <= "0011";
			wait for 1050 * clk_period;
			dv <= "0000";
			wait for clk_period;
			av <= "0000";
--		av <= "1010";
--		data1 <= "0010";
--		data3 <= "1110";
--		dv <= "1010";
--		wait for clk_period;
--		data1 <= "0101";
--		data0 <= "1110";
--		dv <= "0011";
--		av <= "1011";
--		wait for clk_period;
--		data3 <= "1001";
--		dv <= "0001";
--		data1 <= "0000";
--      av <= "1011";
--		wait for clk_period;
--		dv <= "0000";
--		av <= "0001";
--		wait for clk_period;
--		av <= "0000";
--		wait for 10*clk_period;
--		data3 <= "1111";
--		dv <= "0000";
--		av <= "1000";
--		wait for clk_period;
--		av <= "0000";
      wait;
   end process;

END;
