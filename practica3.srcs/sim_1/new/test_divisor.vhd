----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2021 17:05:59
-- Design Name: 
-- Module Name: test_divisor - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_divisor is
--  Port ( );
end test_divisor;

architecture Behavioral of test_divisor is
    component divisor_frecuencia 
    
    port(
        clkFPGA : in std_logic;
        rst     : in std_logic;
        clkOUT  : out std_logic
    );
    
    end component;
    
    signal clk_in : std_logic;
    signal rst : std_logic;
    signal clk_out : std_logic;
    
begin
    test_div : divisor_frecuencia port map (clk_in, rst, clk_out);
   
    process begin
    
    clk_loop : loop
         rst <= '0';
         
         clk_in <= '0';
         wait for 5 ns;
         clk_in <= '1';
         wait for 5 ns;
         
    end loop clk_loop;
         
    end process;
   
end Behavioral;
