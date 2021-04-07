----------------------------------------------------------------------------------
-- Company: UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 28.02.2021 14:41:32
-- Design Name: 
-- Module Name: ascensor - Structural
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

entity ascensor is
  Port (
    clk  : in std_logic;
    rst  : in std_logic;
    piso : in std_logic_vector(2 downto 0);
    start    : in std_logic;
    z    : out std_logic_vector(3 downto 0)
  );
end ascensor;

architecture Structural of ascensor is
    
    -- Componente de la máquina de estados del ascensor    
    component ascensorFSM
    Port ( 
        clk  : in std_logic;
        rst  : in std_logic;
        piso : in std_logic_vector(1 downto 0); -- Entrada de switches
        start: in std_logic; -- Entrada de botón
        z    : out std_logic_vector(3 downto 0) -- Salida de LEDs
    );
    end component;
    
    -- Componente de divisor de frecuencia
    component divisor_frecuencia
    Port ( 
        clkFPGA  : in std_logic;
        rst      : in std_logic;
        clkOUT   : out std_logic;
        count    : in std_logic_vector(31 downto 0)
    );
    end component;
    
    -- Componente del codificador
    component encoder
    Port(
        e  : in std_logic_vector(2 downto 0);
        z  : out std_logic_vector(1 downto 0)  
    );
    end component;
    
    signal clkOUT : std_logic; -- Señal de reloj para conectar el reloj del
                               -- divisor de frecuencia con el ascensor
                               
    signal piso_bin : std_logic_vector(1 downto 0); -- Señal que conecta el codificador
                                                    -- con el ascensor
    
begin
    div_freq : divisor_frecuencia port map(clk, rst, clkOUT, x"05F5E100");
    
    enc : encoder port map(piso, piso_bin);
    
    asc : ascensorFSM port map(clkOUT, rst, piso_bin, start, z);

end Structural;
