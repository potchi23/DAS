----------------------------------------------------------------------------------
-- Company: UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 19.04.2021 23:58:39
-- Design Name: 
-- Module Name: bin2seg - Behavioral
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

entity bin2seg is
    Port (
        bin : in  std_logic_vector(2 downto 0);
        seg : out std_logic_vector(6 downto 0)
    );
end bin2seg;

architecture Behavioral of bin2seg is

begin
    
    process (bin)
    begin
        case bin is
            when "000" =>
                seg <= "0000001";
            when "001" =>
                seg <= "1001111";
            when "010" =>
                seg <= "0010010";        
            when "011" =>
                seg <= "0000110";
            when "100" =>
                seg <= "1001100";
            when "101" =>
                seg <= "0100100";
            when "110" =>
                seg <= "0100000";
            when "111" =>
                seg <= "0001111";
            when others =>
                seg <= (others => '1');
        end case;
    end process;
end Behavioral;
