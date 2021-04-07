----------------------------------------------------------------------------------
-- Company: UCM
-- Engineer: Richard Junior Mercado Correa
-- 
-- Create Date: 28.02.2021 11:36:20
-- Design Name: 
-- Module Name: ascensorFSM - Behavioral
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

entity ascensorFSM is
  Port ( 
    clk  : in std_logic;
    rst  : in std_logic;
    piso : in std_logic_vector(1 downto 0);
    start: in std_logic;
    z    : out std_logic_vector(3 downto 0)
   );

end ascensorFSM;

architecture Behavioral of ascensorFSM is
    
    -- Estados del ascensor
    type states is (s0, s1, s2, s3);
    signal s_act : states := s0;
    signal s_sig : states := s0;
    
    -- Señal que nos servira para comparar el piso actual con el piso al que queremos ir indicado
    -- por los switches, para determinar si el ascensor tiene que subir o bajar.
    -- Tambien servirá para indicar a otros process en que piso estamos actualmente.
    signal p_s : std_logic_vector(1 downto 0) := "00";
    
    -- Señal que se usará para almacenar el piso en un registro
    signal piso_in: std_logic_vector(1 downto 0) := "00";
    
begin
    
    -- Proceso que controla el reloj
    sync: process(clk, rst) begin
        
        if (rst = '1') then
            s_act <= s0;

        elsif(rising_edge(clk)) then
            s_act <= s_sig;    
        end if;
        
    end process sync;
    
    -- Registro del piso
    mov_p: process (start, rst, clk, p_s, piso_in)
    begin
        if (rst = '1') then
            piso_in <= "00";
        
        -- Almacenamos el piso indicado por switches
        elsif(rising_edge(clk) and start = '1' and p_s = piso_in) then
            piso_in <= piso;
        end if;
    
    end process mov_p;
  
    
    -- Maquina de estados finita
    stat: process (s_act, s_sig, p_s, piso_in) 
    
    begin
        
        case s_act is
            
            -- Piso 0
            when s0 =>
                p_s <= "00";
                
                -- Si ya estamos en el piso indicado por los switches, el ascensor se queda donde está
                if(piso_in = "00") then
                    s_sig <= s_act;
                    
                -- Si no estamos en el piso indicado por los switches y tenemos que subir, subimos un piso
                else
                    s_sig <= s1;
                
                end if;    
            
            -- Piso 1
            when s1 =>
                p_s <= "01";
                 
                -- Si ya estamos en el piso indicado por los switches, el ascensor se queda donde está
                if(piso_in = "01") then
                    s_sig <= s_act;
                    
                -- Si no estamos en el piso indicado por los switches y tenemos que subir,
                -- subimos un piso
                elsif(piso_in /= "01" and p_s < piso_in) then
                    s_sig <= s2;
                    
                -- Si no estamos en el piso indicado por los switches y tenemos que bajar,
                -- bajamos un piso
                else
                    s_sig <= s0;
                
                end if;
                
            -- Piso 2
            when s2 =>
                p_s <= "10";
                  
                -- Si ya estamos en el piso indicado por los switches,
                -- el ascensor se queda donde está
                if(piso_in = "10") then
                    s_sig <= s_act;
                    
                -- Si no estamos en el piso indicado por los switches y tenemos que subir,
                -- subimos un piso
                elsif(piso_in /= "10" and p_s < piso_in) then
                    s_sig <= s3;
                    
                -- Si no estamos en el piso indicado por los switches y tenemos que bajar,
                -- bajamos un piso
                else
                    s_sig <= s1;
        
                end if;
            
            -- Piso 3
            when s3 =>
                p_s <= "11";
                
                -- Si ya estamos en el piso indicado por los switches,
                -- el ascensor se queda donde está
                if(piso_in = "11") then
                    s_sig <= s_act;

                -- Si no estamos en el piso indicado por los switches y tenemos que bajar,
                -- bajamos un piso
                else
                    s_sig <= s2;
                    
                end if;
                
        end case;
        
    end process stat;
    
    -- Salida de los LEDs según el estado del ascensor
    out_s : process(s_act) begin
    
        case s_act is
            
            -- Piso 0
            when s0 =>
                z <= "0001";
                
            -- Piso 1
            when s1 =>
                z <= "0010";
                
            -- Piso 2
            when s2 =>
                z <= "0100";
                
            -- Piso 3
            when s3 =>
                z <= "1000";

        end case;
        
    end process out_s;
    
end Behavioral;
