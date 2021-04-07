----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2021 14:30:16
-- Design Name: 
-- Module Name: vga_test - Behavioral
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

entity vga_test is
--  Port ( );
end vga_test;

architecture Behavioral of vga_test is

    component vgacore is
	port
	(
		reset: in std_logic;	
		clk_in: in std_logic;
		hsyncb: buffer std_logic;	
		vsyncb: out std_logic;	
		rgb: out std_logic_vector(11 downto 0)
	);
    end component;
    
    signal reset : std_logic := '0';
    signal clk_in: std_logic;
    signal hsyncb : std_logic;
    signal vsyncb : std_logic;
    signal rgb : std_logic_vector(11 downto 0);
     
begin
    test_vga : vgacore port map (reset, clk_in, hsyncb, vsyncb, rgb);
   
    process begin
    
    clk_loop : loop
         clk_in <= '0';
         wait for 5 ns;
         clk_in <= '1';
         wait for 5 ns;
    end loop clk_loop;
         
    end process;

end Behavioral;
