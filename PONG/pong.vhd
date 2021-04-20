----------------------------------------------------------------------------------
-- Company:  UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 16.04.2021 16:05:22
-- Design Name: 
-- Module Name: pong - Structural
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

entity pong is
    Port (
        clkFPGA : in std_logic;
        reset   : in std_logic;
        
        -- VGA
        hsyncb  : buffer std_logic;	
		vsyncb  : out std_logic;	
		rgb     : out std_logic_vector(11 downto 0);
        
        -- Teclado
        PS2CLK        : in std_logic;
        PS2DATA       : in std_logic;
        
        -- Display de 7 segmentos
        seg : out std_logic_vector (6 downto 0)
     );
end pong;

architecture Structural of pong is
    
    component freq_div is
        Port(
            clkFPGA : in std_logic;
            rst     : in std_logic;
            clkOUT  : out std_logic;
            count   : in std_logic_vector (31 downto 0)
        );
    end component;
    
    component vgacore is
        Port(
            reset  : in std_logic;	
            clk_in : in std_logic;
            hsyncb : buffer std_logic;	
            vsyncb : out std_logic;	
            rgb    : out std_logic_vector(11 downto 0);
		
            clk_ball : in std_logic;
            clk_bar  : in std_logic;
		
            scancode      : in std_logic_vector(7 downto 0);
            key_depressed : in std_logic;
            
            rebound_count : out std_logic_vector(2 downto 0)
        );
    end component;
    
    component keyboard_iface is
        Port (
            PS2CLK        : in std_logic;
            PS2DATA       : in std_logic;
            scancode      : out std_logic_vector(7 downto 0);
            reset         : in std_logic;
            key_depressed : out std_logic
        );
    end component;
    
    component bin2seg is
        Port(
            bin : in  std_logic_vector(2 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal clk_ball : std_logic;
    signal clk_bar  : std_logic;
    
    signal key_depressed_s : std_logic;
    signal scancode_s      : std_logic_vector(7 downto 0);
    signal rebound_count_s : std_logic_vector(2 downto 0);
    
begin
    component_freq_div_pelota : freq_div port map(clkFPGA, reset, clk_ball, x"00050000");
    
    component_freq_div_barra  : freq_div port map(clkFPGA, reset, clk_bar, x"00020000");
    
    component_vgacore         : vgacore port map(reset, clkFPGA, hsyncb, vsyncb, rgb, clk_ball, clk_bar, scancode_s, key_depressed_s, rebound_count_s);
    
    component_keyboard_iface  : keyboard_iface port map(PS2CLK, PS2DATA, scancode_s, reset, key_depressed_s);
    
    component_7seg_disp       : bin2seg port map(rebound_count_s, seg);

end Structural;
