----------------------------------------------------------------------------------
-- Company: UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 30.03.2021 13:18:18
-- Design Name: 
-- Module Name: keyboard_iface - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard_iface is
  Port (
    PS2CLK     : in std_logic;
    PS2DATA    : in std_logic;
    scancode   : out std_logic_vector(0 to 7);
    key_depressed: out std_logic
  );
end keyboard_iface;

architecture Behavioral of keyboard_iface is
    -- PS2
    signal ps2_s : std_logic_vector(21 downto 0) := (others => '0');
    signal start : std_logic;
begin 

    -- Montamos paquete
    ps2_proc : process(ps2_s, PS2CLK)
    begin
        if(falling_edge(PS2CLK)) then
            ps2_s <= ps2_s(20 downto 0) & PS2DATA;
        end if;
    end process;
    
    -- Proceso para saber si estamos pulsando el boton o no
    is_depressed: process(ps2_s, PS2CLK, PS2DATA)
    begin
        if(ps2_s(20 downto 13) = x"0F") then 
            key_depressed <= '1';
        else
            key_depressed <= '0';
        end if;
    end process;
    
    -- Mostramos en leds el scancode
    leds_proc : process(ps2_s, PS2CLK)
    begin
        if(rising_edge(PS2CLK) and ps2_s(20 downto 13) = x"0F") then
            scancode <= ps2_s(9 downto 2);
        end if;
    end process;
    
end Behavioral;
