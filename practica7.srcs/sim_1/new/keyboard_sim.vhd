----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2021 14:30:16
-- Design Name: 
-- Module Name: vga_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard_test is
--  Port ( );
end keyboard_test;

architecture Behavioral of keyboard_test is

    component keyboard_iface is
	port
	(
        PS2CLK     : in std_logic;
        PS2DATA    : in std_logic;
        scancode   : out std_logic_vector(7 downto 0);
        key_pressed: out std_logic
	);
    end component;
    
    signal PS2CLK_s     : std_logic;
    signal PS2DATA_s    : std_logic;
    signal scancode_s   : std_logic_vector(7 downto 0) := "00000000";
    signal key_pressed_s: std_logic;

     
begin
    test_keyboard : keyboard_iface port map (PS2CLK_s, PS2DATA_s, scancode_s, key_pressed_s);
   
    process begin
    
    clk_loop : loop
         PS2CLK_s <= '0';
         wait for 5 ns;
         PS2CLK_s <= '1';
         wait for 5 ns;
    end loop clk_loop;
         
    end process;
    
    process begin

        PS2DATA_s <= '1';
        wait for 40 ns;
        
        -- Inicio transmision
        PS2DATA_s <= '0';
        wait for 10 ns;
        
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '1';
        wait for 10 ns;
        PS2DATA_s <= '0';
        
        
        
        wait for 10 ns;
        PS2DATA_s <= '0';
        wait for 10 ns;
        PS2DATA_s <= '1';
        wait;
    
    end process;
   
end Behavioral;
