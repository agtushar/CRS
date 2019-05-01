--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:50:42 05/01/2019
-- Design Name:   
-- Module Name:   /home/shubhamkar/Dropbox/IIT Bombay/Fourth Semester/CS 226 - DLD/Labs/CRS/crs/tb_voq.vhd
-- Project Name:  crs
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VOQ
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
 
ENTITY tb_voq IS
END tb_voq;
 
ARCHITECTURE behavior OF tb_voq IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VOQ
    PORT(
			data_av_in : in std_logic;
			data_rd_in : out std_logic;
			data_in : in data_bus;
			output_port_valid : in std_logic; 
			output_port : in output_port_bus;
			data_out : out data_bus_vector(n-1 downto 0);
			data_av_out : out std_logic_vector(n-1 downto 0);
			data_rd_out : in std_logic_vector(n-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_av_in : std_logic := '0';
   signal data_in : data_bus := (others => '0');
   signal output_port_valid : std_logic := '0';
   signal output_port : output_port_bus := (others => '0');
   signal data_rd_out : std_logic_vector(n-1 downto 0) := (others => '0');

 	--Outputs
   signal data_rd_in : std_logic;
   signal data_out : data_bus_vector(n-1 downto 0);
   signal data_av_out : std_logic_vector(n-1 downto 0) := (others => '0');
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
	signal clk : std_logic := '0';
	constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VOQ PORT MAP (
          data_av_in => data_av_in,
          data_rd_in => data_rd_in,
          data_in => data_in,
          output_port_valid => output_port_valid,
          output_port => output_port,
          data_out => data_out,
          data_av_out => data_av_out,
          data_rd_out => data_rd_out
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		data_av_in <= '1';
		data_in <= "000111000111";
		output_port <= "00000000";
		output_port_valid <= '1';
		wait for clk_period;
		output_port <= "00000001";
		output_port_valid <= '1';
      wait;
   end process;

END;
