----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
    scancode   : out std_logic_vector(7 downto 0);
    key_depressed: out std_logic
  );
end keyboard_iface;

architecture Behavioral of keyboard_iface is
    -- PS2
    signal ps2_s : std_logic_vector(10 downto 0) := (others => '0');
    signal start : std_logic;
begin 

    
    -- Montamos paquete
    ps2_proc : process(ps2_s, PS2CLK)
    begin
        if(falling_edge(PS2CLK)) then
            ps2_s <= ps2_s(9 downto 0) & PS2DATA;
        end if;
    end process;
    
    -- Proceso para saber si estamos pulsando el boton o no
    is_depressed: process(ps2_s, PS2CLK, PS2DATA)
    begin
        if(PS2CLK = '1' and PS2DATA = '1') then
            key_depressed <= '1';
        else
            key_depressed <= '0';
        end if;
    end process;
    
    -- Miramos si el paquete es valido
    transfer_proc : process(ps2_s, PS2CLK)
    begin
        if(falling_edge(PS2CLK) and ps2_s(10) = '0' and ps2_s(1) = '1' and ps2_s(0) = '1') then
            scancode <= ps2_s(9 downto 2);
        end if;
    end process;
    
    -- Proceso de presión
--    press_proc : process (PS2CLK, PS2DATA, bit_count)
--    begin        
--        if (falling_edge(PS2CLK) and PS2DATA = '0' and bit_count = "000") then
--            press_s <= '1';
--        end if;
--    end process press_proc;
    
--    -- Proceso de transferencia
--    tr_proc : process(PS2CLK, PS2DATA, press_s, bit_count, press_scancode_s)
--    begin
--        if (falling_edge(PS2CLK) and press_s = '1' and bit_count <= "111") then
--            key_pressed <= '0';
--            press_scancode_s <= press_scancode_s(6 downto 0) & PS2DATA;
--            bit_count <= bit_count + "001";
--        end if;
       
--       if (bit_count = "111") then
--        scancode <= press_scancode_s;
--        end if;
--    end process tr_proc;
    
--     Proceso de finalizacion
--    end_proc : process(PS2CLK, press_s, bit_count)
--    begin
--        if(falling_edge(PS2CLK) and PS2DATA='1' and bit_count = "111") then
--            press_s <= '0';
--            key_pressed <= '1';
--        end if;
--    end process;
    
end Behavioral;
