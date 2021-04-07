----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2021 12:17:16
-- Design Name: 
-- Module Name: contador - Behavioral
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
use IEEE.std_logic_unsigned.all;

entity contador is
  Port (
    clk : in std_logic;
    en  : in std_logic;
    rst : in std_logic;
    z   : out std_logic_vector(2 downto 0)
   );
end contador;

architecture Behavioral of contador is

begin

    process (clk, en)
        variable cnt : std_logic_vector(2 downto 0) := "000";
       
    begin
        
        if(rst = '1') then
            cnt := "000";

        elsif(rising_edge(clk)) then
            if(en = '1') then
                cnt := cnt + "001";
            end if;
        end if;
         
        z <= cnt;   
         
    end process; 

end Behavioral;
