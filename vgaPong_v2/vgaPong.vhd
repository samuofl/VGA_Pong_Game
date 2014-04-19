----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sam Ryan
-- 
-- Create Date:    22:42:31 08/18/2013 
-- Design Name: 
-- Module Name:    vgaPong - Behavioral 
-- Project Name: 
-- Target Devices: Papilio development board with LogicStart cape, video out via VGA and controled using 
--						 joy stick						 
-- Tool versions: 
-- Description: A simple game of pong output to VGA and controlled by joy stick on LogicStart
--					 wing.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vgaPong is
    Port ( vsync, hsync : out std_logic;
			  blue : out std_logic_vector(1 downto 0);
			  green : out std_logic_vector(2 downto 0);
			  red : out std_logic_vector(2 downto 0);
			  clk : in  STD_LOGIC;
			  LED : out std_logic_vector(7 downto 0);
           joy_right : in  STD_LOGIC;
           joy_left : in  STD_LOGIC;
           joy_up : in  STD_LOGIC;
           joy_down : in  STD_LOGIC;
           joy_select : in  STD_LOGIC);
end vgaPong;

architecture Behavioral of vgaPong is

	signal hcount : integer := 0;
	signal vcount : integer := 0;
	
	--25 Mhz clock for vga pixels
	signal vga_pixel_clock : std_logic := '0';
	
	signal pixel_color : std_logic_vector(2 downto 0);
	
	--signals/constants control drawing the wall
	signal wall_draw : std_logic; --Tells whether to draw the wall or not at a given pixel
	constant wall_width : integer := 100;
	constant wall_height : integer := 25;
	signal   wall_x_pos : integer := 220;
	constant wall_y_pos : integer := 50;
	constant wall_red : std_logic_vector(2 downto 0) := "111";
	constant wall_green : std_logic_vector(2 downto 0) := "111";
	constant wall_blue : std_logic_vector(1 downto 0) := "11";
	
	--signals/constants control drawing the bar
	signal bar_draw : std_logic; --Tells whether to draw the bar or not at a given pixel
	constant bar_width : integer := 100;
	constant bar_height : integer := 25;
	constant bar_y_pos : integer := 400;
	signal bar_x_pos : integer := 220;
	constant bar_red : std_logic_vector(2 downto 0) := "111";
	constant bar_green : std_logic_vector(2 downto 0) := "111";
	constant bar_blue : std_logic_vector(1 downto 0) := "11";
	
	--signals/constants control drawing the ball
	signal ball_draw : std_logic;
	constant ball_width : integer := 15;
	constant ball_height : integer := 15;
	signal ball_x_pos : integer := 270;
	signal ball_y_pos : integer := 200;
	constant ball_red : std_logic_vector(2 downto 0) := "111";
	constant ball_green : std_logic_vector(2 downto 0) := "111";
	constant ball_blue : std_logic_vector(1 downto 0) := "11";

	--Initialization paramters, show where to start stuff off after a reset
	constant bar_x_pos_start : integer := 220;
	constant ball_x_pos_start : integer := 270;
	constant ball_y_pos_start : integer := 200;
	constant ball_x_velocity_start : integer := 2;
	constant ball_y_velocity_start : integer := 2;
	
	--Keeping track of the position of the ball
	signal ball_x_velocity : integer := 2; --positive is to the right, negative is to the left
	signal ball_y_velocity : integer := 2; --positive is down, negative is up
	
	
	--Track whether the ball is out of play, used to reset the game
	signal ball_out_of_play : std_logic := '0';
	
	--Only update positions of objects every so often
	signal movement_counter : integer := 0; --Count clock cycles
	constant movement_constant : integer := 500000; --32 Mhz clock, update ever 1 million clock cycles so ~32 times per second
	
	--reset signal, put ball back in original spot
	signal reset : std_logic := '0';


	COMPONENT pixel_clock
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;

	begin


	Inst_pixel_clock: pixel_clock PORT MAP(
		CLKIN_IN => clk,
		CLKFX_OUT => vga_pixel_clock,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open
	);

	--Keep track of positioning of pixels to draw
	sync : process(vga_pixel_clock)
		begin
		if(rising_edge(vga_pixel_clock)) then
			if hcount = 799 then
				hcount <= 0;
				if vcount = 524 then
					vcount <= 0;
				else
					vcount <= vcount+1;
				end if;
			else
				hcount <= hcount+1;
			end if;
			
			if vcount >= 490 and vcount < 492 then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
			
			if hcount >= 656 and hcount < 752 then
				hsync <= '0';
			else 
				hsync <= '1';
			end if;
		end if;
	end process;
	
	--Draw each position on the screen
	draw : process(hcount, vcount, bar_x_pos)
		begin
		if hcount < 640 and vcount < 480 then
				--Decide whether to draw the wall on this pixel
				if (hcount > wall_x_pos) and (hcount < (wall_x_pos + wall_width)) and (vcount > wall_y_pos) and (vcount < (wall_y_pos + wall_height)) then
					wall_draw <= '1';
				else
					wall_draw <= '0';
				end if;
				
				--Decide whether to draw the bar on this pixel
				if (hcount > bar_x_pos) and (hcount < (bar_x_pos + bar_width)) and (vcount > bar_y_pos) and (vcount < (bar_y_pos + bar_height)) then
					bar_draw <= '1';
				else
					bar_draw <= '0';
				end if;				
				
				--Decide whether to draw the ball on this pixel
				if (hcount > ball_x_pos) and (hcount < (ball_x_pos + ball_width)) and (vcount > ball_y_pos) and (vcount < (ball_y_pos + ball_height)) then
					ball_draw <= '1';
				else
					ball_draw <= '0';
				end if;
				
				if wall_draw = '1' then
					red <= wall_red;
					green <= wall_green;
					blue <= wall_blue;
				elsif bar_draw = '1' then
					red <= bar_red;
					green <= bar_green;
					blue <= bar_blue;
				elsif ball_draw = '1' then
					red <= ball_red;
					green <= ball_green;
					blue <= ball_blue;
				else 
					red <= "000";
					green <= "000";
					blue <= "00";					
				end if;		
		else
			red <= "000";
			green <= "000";
			blue <= "00";
		end if;
	end process;
	
	--Calculates new positions based on time passing, also handles direction changes based 
	--on collisions
	update_positions : process(vga_pixel_clock, reset)
		begin
		if(rising_edge(vga_pixel_clock)) then
			if movement_counter = movement_constant then
				if reset = '0' then
					movement_counter <= 0;
					--Move the bar in response to the joystick
					if (joy_right = '0') and ((bar_x_pos + bar_width) < 680) then
						bar_x_pos <= bar_x_pos + 2;
					elsif (joy_left = '0') and (bar_x_pos > 0) then
						bar_x_pos <= bar_x_pos - 2;
					end if;
					
					--Move the wall in response to the ball
					if (ball_x_pos > wall_x_pos) then
						wall_x_pos <= wall_x_pos + 2;
					elsif (ball_x_pos < wall_x_pos) then
						wall_x_pos <= wall_x_pos - 2;
					end if;
					
					--Update ball velocity based on collision
					if (ball_y_pos <= (wall_y_pos + wall_height)) and (ball_y_velocity < 0) and ((ball_x_pos + ball_width) > wall_x_pos) and (ball_x_pos < (wall_x_pos + bar_width)) then --collision with top wall
						ball_y_velocity <= -ball_y_velocity;
					elsif ((ball_y_pos + ball_height) >= bar_y_pos) and (ball_y_velocity > 0) and ((ball_x_pos + ball_width) > bar_x_pos) and (ball_x_pos < (bar_x_pos + bar_width))  then --collision with wall
						ball_y_velocity <= -ball_y_velocity;
					end if;
					
					if (ball_x_pos <= 0) and (ball_x_velocity < 0) then
						ball_x_velocity <= -ball_x_velocity;
					elsif ((ball_x_pos + ball_width) >= 600) and (ball_x_velocity > 0) then
						ball_x_velocity <= -ball_x_velocity;
					end if;
					
					--Move the ball based on velocity
					ball_x_pos <= ball_x_pos + ball_x_velocity;
					ball_y_pos <= ball_y_pos + ball_y_velocity;
					
				else --reset
					ball_x_pos <= ball_x_pos_start;
					ball_y_pos <= ball_y_pos_start;
					ball_x_velocity <= ball_x_velocity_start;
					ball_y_velocity <= ball_y_velocity_start;
					bar_x_pos <= bar_x_pos_start;
				end if;
				
				
				--Check if ball is out of play
				if ball_y_pos > 480 then
					ball_out_of_play <= '1';
				else
					ball_out_of_play <= '0';
				end if;
				
			else
				movement_counter <= movement_counter + 1;
			end if;
		end if;
	end process;
	
	reset <= (not joy_select) or ball_out_of_play;

	LED(0) <= joy_right;
	LED(1) <= joy_left;
	LED(2) <= joy_up;
	LED(3) <= joy_down;
	LED(4) <= joy_select;
	LED(7 downto 5) <= "000";

end Behavioral;

