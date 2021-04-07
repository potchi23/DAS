----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2021 13:00:24
-- Design Name: 
-- Module Name: ascensor_test - Behavioral
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

entity ascensor_test is
--  Port ( );
end ascensor_test;

architecture Behavioral of ascensor_test is

component ascensorFSM is
  Port ( 
    clk  : in std_logic;
    rst  : in std_logic;
    piso : in std_logic_vector(3 downto 0);
    m    : in std_logic;
    z    : out std_logic_vector(3 downto 0)
   );

end component;
    
    signal clk : std_logic;
    signal rst : std_logic;
    signal piso: std_logic_vector(3 downto 0);
    signal m   : std_logic;
    signal z   : std_logic_vector(3 downto 0);
    
begin
    
    a : ascensorFSM port map (clk, rst, piso, m, z);
    
    clock: process
    begin
        
        clock_loop: loop
            clk <= '0';
            wait for 20 ns;
            clk <= '1';
            wait for 20 ns;
        end loop clock_loop;
        
    end process clock;
    
    states : process
    begin
        rst <= '0';
        m <= '1';
        piso <= "1000";
       
        wait for 20 ns;
        
        piso <= "0010";
       
    end process states;
    

end Behavioral;
