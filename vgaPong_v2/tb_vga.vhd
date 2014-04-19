--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:16:32 08/27/2013
-- Design Name:   
-- Module Name:   C:/Users/Sam/Documents/FPGA/vgaPong/tb_vga.vhd
-- Project Name:  vgaPong
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vgaPong
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
 
ENTITY tb_vga IS
END tb_vga;
 
ARCHITECTURE behavior OF tb_vga IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vgaPong
    PORT(
         vsync : OUT  std_logic;
         hsync : OUT  std_logic;
         blue : OUT  std_logic_vector(1 downto 0);
         green : OUT  std_logic_vector(2 downto 0);
         red : OUT  std_logic_vector(2 downto 0);
         clk : IN  std_logic;
         joy_right : IN  std_logic;
         joy_left : IN  std_logic;
         joy_up : IN  std_logic;
         joy_down : IN  std_logic;
         joy_select : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal joy_right : std_logic := '0';
   signal joy_left : std_logic := '0';
   signal joy_up : std_logic := '0';
   signal joy_down : std_logic := '0';
   signal joy_select : std_logic := '0';

 	--Outputs
   signal vsync : std_logic;
   signal hsync : std_logic;
   signal blue : std_logic_vector(1 downto 0);
   signal green : std_logic_vector(2 downto 0);
   signal red : std_logic_vector(2 downto 0);
	
	
   -- Clock period definitions
   constant clk_period : time := 31.25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vgaPong PORT MAP (
          vsync => vsync,
          hsync => hsync,
          blue => blue,
          green => green,
          red => red,
          clk => clk,
          joy_right => joy_right,
          joy_left => joy_left,
          joy_up => joy_up,
          joy_down => joy_down,
          joy_select => joy_select
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

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
