library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity vgacore is
	port
	(
		reset: in std_logic;	
		clk_in: in std_logic;
		hsyncb: buffer std_logic;	
		vsyncb: out std_logic;	
		rgb: out std_logic_vector(11 downto 0)
	);
end vgacore;

architecture vgacore_arch of vgacore is

signal hcnt: std_logic_vector(8 downto 0);	
signal vcnt: std_logic_vector(9 downto 0);	

signal clock: std_logic := '0';  --este es el pixel_clock

signal i     : std_logic_vector(31 downto 0) := (others => '0'); -- Contador para el divisor de frecuencia

-- Señales para el "multiplexor" que muestra los colores por el display
signal marco_ext : std_logic := '0';
signal marco_int : std_logic := '0';
signal rect_int  : std_logic := '0';

begin

-- Contador horizontal
-- Cuenta el número de píxeles en cada línea y cuando se alcanzan los 381 píxeles
-- se reinicia el contador
hor_cnt: process(clock,reset)
begin
	-- reset asynchronously clears pixel counter
	if reset='1' then
		hcnt <= "000000000";
	-- horiz. pixel counter increments on rising edge of dot clock
	elsif (clock'event and clock='1') then
		-- horiz. pixel counter rolls-over after 381 pixels
		if hcnt<380 then
			hcnt <= hcnt + 1;
		else
			hcnt <= "000000000";
		end if;
	end if;
end process;

-- Contador vertical
-- Cuenta el número de líneas en el marco y reinicia el contador
-- cuando se alcanzan los 528 líneas
ver_cnt: process(hsyncb,reset)
begin
	-- reset asynchronously clears line counter
	if reset='1' then
		vcnt <= "0000000000";
	-- vert. line counter increments after every horiz. line
	elsif (hsyncb'event and hsyncb='1') then
		-- vert. line counter rolls-over after 528 lines
		if vcnt<527 then
			vcnt <= vcnt + 1;
		else
			vcnt <= "0000000000";
		end if;
	end if;
end process;

-- Comparador para comprobar si el contador horizontal está sincronizado
cmp_hor_sync: process(clock,reset)
begin
	-- reset asynchronously sets horizontal sync to inactive
	if reset='1' then
		hsyncb <= '1';
	-- horizontal sync is recomputed on the rising edge of every dot clock
	elsif (clock'event and clock='1') then
		-- horiz. sync is low in this interval to signal start of a new line
		if (hcnt>=291 and hcnt<337) then
			hsyncb <= '0';
		else
			hsyncb <= '1';
		end if;
	end if;
end process;

-- Comparador para comprobar si el contador vertical está sincronizado
cmp_ver_sync: process(hsyncb,reset)
begin
	-- reset asynchronously sets vertical sync to inactive
	if reset='1' then
		vsyncb <= '1';
	-- vertical sync is recomputed at the end of every line of pixels
	elsif (hsyncb'event and hsyncb='1') then
		-- vert. sync is low in this interval to signal start of a new frame
		if (vcnt>=490 and vcnt<492) then
			vsyncb <= '0';
		else
			vsyncb <= '1';
		end if;
	end if;
end process;

-- A partir de aqui implementar los módulos que faltan, necesarios para dibujar en el monitor

-- Divisor de frecuencia
clk_div: process(clk_in, reset) 
  
begin
    if(reset = '1') then
        i <= (others => '0');
        clock <= '0';    
            
    elsif(rising_edge(clk_in)) then
        i <= i + x"00000001";
            
        if(i = x"00000004") then
            clock <= not clock;
            i <= (others => '0');
        end if;
    end if;
end process;

-- Comparador para el marco exterior
cmp_disp_marco_ext: process(hcnt, vcnt, marco_ext)
begin
    if (hcnt>=0 and hcnt<337 and vcnt>=0 and vcnt<492) then -- RANGO: h: 337, v: 492
        marco_ext <= '1';
    else
        marco_ext <= '0';
    end if;
end process;

-- Comparador para el marco interior
cmp_disp_marco_int: process(hcnt, vcnt, marco_int)
begin
    if (hcnt>=20 and hcnt<317 and vcnt>=20 and vcnt<472) then -- RANGO: h: 337, v: 492
        marco_int <= '1';
    else
        marco_int <= '0';
    end if;
end process;

-- Comparador para el rectangulo dentro del marco
cmp_disp_rect_int: process(hcnt, vcnt, rect_int)
begin
    if (hcnt>=100 and hcnt<200 and vcnt>=80 and vcnt<200) then -- RANGO: h: 337, v: 492
        rect_int <= '1';
    else
        rect_int <= '0';
    end if;
end process;

-- Multiplexor para sacar un color por pantalla
mux_vga: process(marco_ext, marco_int, rect_int)
begin
    
    -- Bit 2: R
    -- Bit 1: G
    -- Bit 0: B
    
    if(marco_ext = '1') then
        rgb <= x"00F";
    elsif(marco_int = '1') then
        rgb <= x"000";
    elsif(rect_int = '1') then
        rgb <= x"F00";
    else
        rgb <= x"000";
    end if;
    
end process;

end vgacore_arch;