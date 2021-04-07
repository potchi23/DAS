----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2021 18:00:29
-- Design Name: 
-- Module Name: deco2 - Behavioral
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

entity deco2 is
    Port (
        e : in std_logic_vector (1 downto 0);
        z : out std_logic_vector (3 downto 0);
        enable : in std_logic
    );
end deco2;

architecture Behavioral of deco2 is

begin
    z <= "0001" when e = "00" and enable = '1' else
         "0010" when e = "01" and enable = '1' else
         "0100" when e = "10" and enable = '1' else
         "1000" when e = "11" and enable = '1' else
         "0000" when enable = '0' else
         "1111";

end Behavioral;
