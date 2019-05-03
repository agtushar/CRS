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
use work.globals.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_arbiter IS
END tb_arbiter;
 
ARCHITECTURE behavior OF tb_arbiter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ARBITER
    PORT( 	
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
		 buf_req_ext, exp_req_ext, buf_rd_ext, exp_rd_ext: inout std_logic_vector(n-1 downto 0);
--			rd_sig : inout std_logic_vector(n-1 downto 0);
		 exp_granted : inout std_logic;
		 ack_ext : out std_logic);
    END COMPONENT;
    

   --Inputs
   signal buf_data, exp_data : data_bus_vector(n-1 downto 0) 
		:= (others => (others => '0'));
	signal buf_data_av, exp_data_av, buf_data_rd, exp_data_rd, grant, rd_sig,
		request, buf_req, exp_req, buf_rd, exp_rd : std_logic_Vector(n-1 downto 0) := (others => '0');
	signal out_data_av, out_data_rd, exp_granted, ack : std_logic;
   signal out_data : data_bus;
	
   
   signal CLK: std_logic := '0';
   signal RST: std_logic := '0';

 	--Outputs

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ARBITER PORT MAP (
          clk => clk,
			 rst => rst,
			 buf_data => buf_data,
			 buf_data_av => buf_data_av,
			 buf_data_rd => buf_data_rd,
			 exp_data => exp_data,
			 exp_data_av => exp_data_av,
			 exp_data_rd => exp_data_rd,
			 OUT_DATA_AV => out_data_av,
			 OUT_DATA_RD => out_data_rd,
			 OUT_DATA => out_data,
			 GRANT_EXT => grant,
			 exP_req_ext => exp_req,
			 buf_req_ext => buf_req,
			 exp_rd_ext => exp_rd,
			 buf_Rd_ext => buf_rd,
--			 rd_sig => rd_sig,
			 exp_granted =>  exp_granted,
			 ack_ext => ack
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
		
-- test for fifo almost full
--			data0 <= "1111";
--			data1 <= "1010";
--			dv <= "0011";
--			av <= "0011";
--			wait for 1050 * clk_period;
--			dv <= "0000";
--			wait for clk_period;
--			av <= "0000";

-- crs test
		rst <= '0';			
		buf_data(0) <= "100110111000";
		buf_data_av(0) <= '1';
--		output_port(0) <= "00000001";
--		output_port_valid <= "01";
		wait for clk_period;
		buf_data(0) <= "100110110000";
		wait for clk_period;
		buf_data_av <= (others => '0');
--		output_port_valid <= (others => '0');

---- normal test
--		buf_data(0) <= "100110111000";
--		buf_data(1) <= "100010001011";
--		buf_data_av(0) <= '1';
--		buf_data_av(1) <= '1';
--		wait for clk_period;
--		exp_data(0) <= "100110001000";
--		exp_data_av(0) <= '1';
--		buf_data(0) <= "100110110000";
--		buf_data(1) <= "100010000011";
--		wait for clk_period;
--		buf_data_av <= (others => '0');
--		exp_data(0) <= "100010001000";
--		exp_data_av(0) <= '1';
--		wait for clk_period;
--		exp_data(0) <= "100010000000";
--		exp_data_av(0) <= '1';
--		wait for clk_period;
--		exp_data_av(0) <= '0';
      wait;
   end process;

END;
