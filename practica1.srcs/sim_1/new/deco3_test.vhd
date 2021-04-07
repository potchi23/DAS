----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2021 18:22:15
-- Design Name: 
-- Module Name: test_deco2 - Behavioral
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

entity test_deco3 is
--  Port ( );
end test_deco3;

architecture Behavioral of test_deco3 is

    component deco3
        Port (
            e: in std_logic_vector (2 downto 0);
            z: out std_logic_vector (7 downto 0);
            en: in std_logic
        );
    end component;
    
    signal x : std_logic_vector (2 downto 0);
    signal w : std_logic_vector (7 downto 0);
    signal en: std_logic;
    
begin
    a1 : deco3 port map (x, w, en);
    
    process begin
        en <= '1';
        wait for 10 ns;
        x <= "000";
        wait for 20 ns;
        
        x <= "100";
        wait for 20 ns;
        
        x <= "101";
        wait for 20 ns;
        
        x <= "111";
        wait for 30 ns;
        
        
        en <= '0';
        
        wait for 10 ns;
        
        x <= "000";
        wait for 20 ns;
        
        x <= "101";
        wait for 20 ns;
        
        x <= "111";
        wait for 30 ns;
        
    end process;

end Behavioral;
