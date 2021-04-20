----------------------------------------------------------------------------------
-- Company: UCM 
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 27.02.2021 16:52:52
-- Design Name: 
-- Module Name: divisor_frecuencia - Behavioral
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

entity freq_div is
  Port ( 
    clkFPGA : in std_logic;
    rst     : in std_logic;
    clkOUT  : out std_logic;
    count   : in std_logic_vector (31 downto 0)
  );
  
end freq_div;

architecture Behavioral of freq_div is
    signal clk_sig : std_logic := '0';
    signal i     : std_logic_vector(31 downto 0) := (others => '0');
    
begin
    
    process(clkFPGA, rst, clk_sig) 
        
    begin
        if(rst = '1') then
            i <= (others => '0');
            clk_sig <= '0';    
            
        elsif(rising_edge(clkFPGA)) then
            i <= i + x"00000001";
            
            if(i = count) then
               clk_sig <= not clk_sig;
               i <= (others => '0');
            end if;
            
        end if;
        
    end process;
    
    clkOUT <= clk_sig;
    
end Behavioral;
