----------------------------------------------------------------------------------
-- Company: UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 08.03.2021 14:27:16
-- Design Name: 
-- Module Name: encoder - Behavioral
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

entity encoder is
    Port (
        e  : in std_logic_vector(2 downto 0);
        z  : out std_logic_vector(1 downto 0)  
    );
end encoder;

architecture Behavioral of encoder is
    
begin
    z <= "00" when e = "000" else
         "01" when e = "001" else
         "10" when e = "01-" else
         "11";

end Behavioral;
