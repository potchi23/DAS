----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2021 12:32:45
-- Design Name: 
-- Module Name: test_cont - Behavioral
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

entity test_cont is
--  Port ( );
end test_cont;

architecture Behavioral of test_cont is

component contador is
  Port (
    clk : in std_logic;
    en  : in std_logic;
    rst : in std_logic;
    z   : out std_logic_vector(2 downto 0)
   );
end component;

    signal clk : std_logic;
    signal en  : std_logic;
    signal rst : std_logic;
    signal z   : std_logic_vector(2 downto 0);

begin
    
    cont_test : contador port map (clk, en, rst, z);

    process begin
        en <= '1';
        rst <= '0';
    
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        
        clk <= '0';
        en <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        en <= '1';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
                clk <= '0';
                rst <= '1';
        wait for 10 ns;
        clk <= '1';
        rst <= '0';
        wait for 10 ns;
    end process;
    
end Behavioral;
