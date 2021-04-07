----------------------------------------------------------------------------------
-- Company: UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 27.03.2021 21:47:49
-- Design Name: 
-- Module Name: RAM - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- RAM distribuida
entity distr_RAM is
  Port ( 
    clkFPGA : in std_logic;
    we      : in std_logic;
    data_in : in std_logic_vector(31 downto 0);
    data_out: out std_logic_vector(31 downto 0);
    addr    : in std_logic_vector(13 downto 0)
  );
end distr_RAM;

architecture Behavioral of distr_RAM is
    
    -- Array que servirá como RAM
    type RAM_type is array (16383 downto 0) of std_logic_vector(31 downto 0); -- 2^14 x 32 
    signal RAM0 : RAM_type := (others => (others => '0'));
    
begin
    
    -- Escritura síncorna
    sync_write: process(clkFPGA, we, data_in, addr)
    begin
    
        if(rising_edge(clkFPGA) and we = '1') then
            RAM0(to_integer(unsigned(addr))) <= data_in;
        end if;
    
    end process sync_write;
    
    -- Escritura asíncrona
    async_read: process(addr)
    begin
    
        data_out <= RAM0(to_integer(unsigned(addr)));
        
    end process async_read;

end Behavioral;