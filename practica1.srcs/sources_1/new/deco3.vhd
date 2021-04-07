----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2021 18:00:29
-- Design Name: 
-- Module Name: deco3 - Structural
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

entity deco3 is
  Port (
    e : in std_logic_vector (2 downto 0);
    z : out std_logic_vector(7 downto 0);
    en : in std_logic
  );
end deco3;

architecture Structural of deco3 is
    component deco2
        Port (
            e : in std_logic_vector (1 downto 0);
            z : out std_logic_vector (3 downto 0);
            enable : in std_logic
        );
    end component;
    
    signal in1, in2, in3    : std_logic_vector (1 downto 0);
    signal out1, out2, out3 : std_logic_vector (3 downto 0);
    
begin
    
    in1(1) <= '0';
    in1(0) <= e(2);
    d1 : deco2 port map (in1, out1, en);
    
    in2(1) <= e(1);
    in2(0) <= e(0);
    d2 : deco2 port map(in2, out2, out1(1));
    
    in3(1) <= e(1);
    in3(0) <= e(0);
    d3 : deco2 port map(in3, out3, out1(0));
    
    z(7) <= out2(3);
    z(6) <= out2(2);
    z(5) <= out2(1);
    z(4) <= out2(0);
    
    z(3) <= out3(3);
    z(2) <= out3(2);
    z(1) <= out3(1);
    z(0) <= out3(0);
    
end Structural;
