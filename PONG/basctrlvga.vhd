library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity vgacore is
	port
	(
		reset : in std_logic;	
		clk_in: in std_logic;
		hsyncb: buffer std_logic;	
		vsyncb: out std_logic;	
		rgb: out std_logic_vector(11 downto 0);
		
		clk_ball : in std_logic;
		clk_bar  : in std_logic;
		
		scancode      : in std_logic_vector(7 downto 0);
		key_depressed : in std_logic;
		
		rebound_count : out std_logic_vector(2 downto 0)
	);
end vgacore;

architecture vgacore_arch of vgacore is

signal hcnt  : std_logic_vector(8 downto 0);	
signal vcnt  : std_logic_vector(9 downto 0);	
signal clock : std_logic := '0';  --este es el pixel_clock
signal i     : std_logic_vector(31 downto 0) := (others => '0'); -- Contador para el divisor de frecuencia

-- Señales para el "multiplexor" que muestra los colores por el display
signal marco_ext : std_logic := '0';
signal marco_int : std_logic := '0';
signal ball_sig  : std_logic := '0';
signal bar_sig   : std_logic := '0';

-- Señales para FSM de la pelota
type ball_states is (down_left, up_left, up_right, down_right); -- Representamos dirección de la pelota
signal ball_state      : ball_states := down_left;
signal ball_next_state : ball_states := down_left;

-- Posición inicial de la pelota
signal ball_hpos_ini : std_logic_vector(11 downto 0) := x"0FA"; -- 250
signal ball_hpos_end : std_logic_vector(11 downto 0) := x"101"; -- 257
signal ball_vpos_ini : std_logic_vector(11 downto 0) := x"08C"; -- 140
signal ball_vpos_end : std_logic_vector(11 downto 0) := x"0A0"; -- 160

-- Señales para FSM de la barra
type bar_states is (stop, up, down); -- Representamos dirección de la barra
signal bar_state      : bar_states := stop;
signal bar_next_state : bar_states := stop;

-- Posición inicial de la barra
signal bar_vpos_ini : std_logic_vector(11 downto 0) := x"082"; -- 130
signal bar_vpos_end : std_logic_vector(11 downto 0) := x"0FA"; -- 250
signal bar_hpos_ini : std_logic_vector(11 downto 0) := x"00D"; -- 13
signal bar_hpos_end : std_logic_vector(11 downto 0) := x"014"; -- 20 

signal rebound_count_s: std_logic_vector(2 downto 0) := (others => '0'); -- contamos hasta 7 rebotes

-- RAM con 8 colores    
type RAM_type is array (7 downto 0) of std_logic_vector(11 downto 0);
signal RAM0 : RAM_type := (others => (others => '0'));
signal data_out        : std_logic_vector(11 downto 0);
signal we              : std_logic := '1';

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

-- Divisor de frecuencia VGA
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
    if (hcnt>=10 and hcnt < 295 and vcnt>=20 and vcnt<470) then -- RANGO: h: 337, v: 492
        marco_int <= '1';
    else
        marco_int <= '0';
    end if;
end process;

-- REPRESENTACION DE LA PELOTA --

-- Cambio de estado de la pelota
ball_sync : process (clk_ball, reset, ball_state, ball_next_state)
begin
    if(reset = '1') then
        ball_state <= down_left;
    elsif(rising_edge(clk_ball)) then
        ball_state <= ball_next_state;
    end if;
end process;

-- FSM pelota
ball_fsm : process(ball_state, ball_next_state, ball_hpos_ini, ball_hpos_end, ball_vpos_ini, ball_vpos_end, bar_hpos_ini, bar_hpos_end, bar_vpos_ini, bar_vpos_end)
begin

    -- Nota: Los numeros que se suman o se restan a las posiciones son microajustes para el correcto funcionamiento
    case ball_state is
        when down_left =>            
            if(ball_vpos_end >= 470 or (ball_hpos_ini >= bar_hpos_ini - 9 and ball_hpos_end <= bar_hpos_end + 9 and ball_vpos_end = bar_vpos_ini)) then
                ball_next_state <= up_left;
            elsif(ball_hpos_ini <= 10 or (ball_hpos_ini = bar_hpos_end and ball_vpos_ini >= bar_vpos_ini - 9 and ball_vpos_end <= bar_vpos_end + 9)) then
                ball_next_state <= down_right;
            else
                ball_next_state <= ball_state;
            end if;
            
        when up_left =>   
            if(ball_hpos_ini <= 10 or (ball_hpos_ini = bar_hpos_end and ball_vpos_ini >= bar_vpos_ini - 9 and ball_vpos_end <= bar_vpos_end + 9)) then
                ball_next_state <= up_right;
            elsif(ball_vpos_ini <= 20 or (ball_hpos_ini >= bar_hpos_ini - 9 and ball_hpos_end <= bar_hpos_end + 9 and ball_vpos_ini = bar_vpos_end))then
                ball_next_state <= down_left; 
            else
                ball_next_state <= ball_state;
            end if;
        
        when up_right =>
            if(ball_vpos_ini <= 20  or (ball_hpos_ini >= bar_hpos_ini - 9 and ball_hpos_end <= bar_hpos_end + 9 and ball_vpos_ini = bar_vpos_end)) then
                ball_next_state <= down_right;
            elsif(ball_hpos_end >= 295) then
                ball_next_state <= up_left;
            else
                ball_next_state <= ball_state;
            end if;
            
        when down_right =>
            if(ball_vpos_end = 470 or (ball_hpos_ini >= bar_hpos_ini - 9 and ball_hpos_end <= bar_hpos_end + 9 and ball_vpos_end = bar_vpos_ini)) then
                ball_next_state <= up_right;
            elsif(ball_hpos_end = 295) then
                ball_next_state <= down_left;
            else
                ball_next_state <= ball_state;
            end if; 
    end case;
end process;

-- Registro para almacenar la posición de la pelota
ball_pos_reg : process(clk_ball, reset, ball_hpos_ini, ball_hpos_end, ball_vpos_ini, ball_vpos_end)
begin

    if(reset = '1') then
        ball_hpos_ini <= x"0FA";
        ball_hpos_end <= x"101";
        ball_vpos_ini <= x"08C";
        ball_vpos_end <= x"0A0";
    
    elsif(rising_edge(clk_ball)) then
        case ball_state is
            when down_left =>
                ball_hpos_ini <= ball_hpos_ini - 1;
                ball_hpos_end <= ball_hpos_end - 1;
                ball_vpos_ini <= ball_vpos_ini + 1;
                ball_vpos_end <= ball_vpos_end + 1;
            
            when up_left =>
                ball_hpos_ini <= ball_hpos_ini - 1;
                ball_hpos_end <= ball_hpos_end - 1;
                ball_vpos_ini <= ball_vpos_ini - 1;
                ball_vpos_end <= ball_vpos_end - 1;
        
            when up_right =>
                ball_hpos_ini <= ball_hpos_ini + 1;
                ball_hpos_end <= ball_hpos_end + 1;
                ball_vpos_ini <= ball_vpos_ini - 1;
                ball_vpos_end <= ball_vpos_end - 1;

            when down_right =>
                ball_hpos_ini <= ball_hpos_ini + 1;
                ball_hpos_end <= ball_hpos_end + 1;
                ball_vpos_ini <= ball_vpos_ini + 1;
                ball_vpos_end <= ball_vpos_end + 1;
        end case;
    end if;
end process;
 
-- Proceso para mostrar la pelota
ball_beh : process (hcnt, vcnt, ball_hpos_ini, ball_hpos_end, ball_vpos_ini, ball_vpos_end)
begin
    if(hcnt > ball_hpos_ini and hcnt < ball_hpos_end and vcnt > ball_vpos_ini and vcnt < ball_vpos_end) then
        ball_sig <= '1';
    else
        ball_sig <= '0';
    end if;
end process;

-- REPRESENTACION DE LA BARRA --

-- Proceso para cambiar estado
bar_sync : process(clk_bar, reset, bar_state, bar_next_state)
begin
    if(reset = '1') then
        bar_state <= stop;
    elsif(rising_edge(clk_bar)) then
        bar_state <= bar_next_state;
    end if;
end process;

-- FSM barra
bar_fsm : process(bar_state, bar_next_state, scancode, key_depressed, bar_vpos_ini, bar_vpos_end)
begin
    case bar_state is
        when stop =>
            if(key_depressed = '0' and scancode = "10111000" and bar_vpos_ini > 20) then -- se detecta señal subida
                bar_next_state <= up;
            elsif(key_depressed = '0' and scancode = "11011000" and bar_vpos_end < 470) then -- se detecta señal de bajada
                bar_next_state <= down;
            else -- no se detecta señal
                bar_next_state <= bar_state;
            end if;
            
        when up =>
            if(key_depressed = '0' and scancode = "10111000" and bar_vpos_ini > 20) then -- se detecta señal de subida
                bar_next_state <= bar_state;
            elsif(key_depressed = '0' and scancode = "11011000") then -- se detecta señal de bajada
                bar_next_state <= down;
            else -- se detecta obstaculo o no hay señal
                bar_next_state <= stop;
            end if;
        
        when down =>
            if(key_depressed = '0' and scancode = "10111000") then -- se detecta señal de subida
                bar_next_state <= up;
            elsif(key_depressed = '0' and scancode = "11011000" and bar_vpos_end < 469) then -- se detecta señal de bajada
                bar_next_state <= bar_state;
            else -- se detecta obstaculo o no hay señal
                bar_next_state <= stop;
            end if;
    end case;
end process;

-- Registro para almacenar la posición de la barra
bar_pos_reg : process(clk_bar, reset, bar_hpos_ini, bar_hpos_end, bar_vpos_ini, bar_vpos_end)
begin

    if(reset = '1') then
        bar_vpos_ini <= x"082";
        bar_vpos_end <= x"0FA";
        bar_hpos_ini <= x"00D";
        bar_hpos_end <= x"014";
    
    elsif(rising_edge(clk_bar)) then
        case bar_state is
            when stop =>
                bar_vpos_ini <= bar_vpos_ini;
                bar_vpos_end <= bar_vpos_end;
                bar_hpos_ini <= bar_hpos_ini;
                bar_hpos_end <= bar_hpos_end;
            
            when up =>
                bar_vpos_ini <= bar_vpos_ini - 1;
                bar_vpos_end <= bar_vpos_end - 1;
                bar_hpos_ini <= bar_hpos_ini;
                bar_hpos_end <= bar_hpos_end;
        
            when down =>
                bar_vpos_ini <= bar_vpos_ini + 1;
                bar_vpos_end <= bar_vpos_end + 1;
                bar_hpos_ini <= bar_hpos_ini;
                bar_hpos_end <= bar_hpos_end;
        end case;
    end if;
end process;

-- Proceso para mostrar la barra
bar_beh : process (hcnt, vcnt, bar_hpos_ini, bar_hpos_end, bar_vpos_ini, bar_vpos_end)
begin
    if(hcnt > bar_hpos_ini and hcnt < bar_hpos_end and vcnt > bar_vpos_ini and vcnt < bar_vpos_end) then
        bar_sig <= '1';
    else
        bar_sig <= '0';
    end if;
end process;

-- Contador de rebotes
reb_count : process (reset, clk_ball, rebound_count_s, ball_hpos_ini, ball_hpos_end, ball_vpos_ini, ball_vpos_end, bar_hpos_ini, bar_hpos_end, bar_vpos_ini, bar_vpos_end)
begin
    if(reset = '1') then
        rebound_count_s <= (others => '0');
   -- Nota: Los numeros que se suman o se restan a las posiciones son microajustes para el correcto funcionamiento
    elsif(rising_edge(clk_ball) and ((ball_hpos_ini >= bar_hpos_ini - 9 and ball_hpos_end <= bar_hpos_end + 9 and ball_vpos_end = bar_vpos_ini + 1) or
                                     (ball_hpos_ini = bar_hpos_end - 1 and ball_vpos_ini >= bar_vpos_ini - 9 and ball_vpos_end <= bar_vpos_end + 9) or
                                     (ball_hpos_ini >= bar_hpos_ini + 9 and ball_hpos_end <= bar_hpos_end + 9 and ball_vpos_ini = bar_vpos_end - 1))) then
        rebound_count_s <= rebound_count_s + 1;
    end if;
end process;
rebound_count <= rebound_count_s; -- Salida al decodificador

-- DRAM para cambiar el color del fondo

-- Proceso para evitar reescribir la RAM
we_p : process(RAM0)
begin
    if(RAM0(7) = x"000") then -- Comprobamos que la posición 7 no está vacía
        we <= '1';
    else
        we <= '0';
    end if;
end process;

-- Escritura asíncrona
sync_write: process(clk_in, we, RAM0)
begin
    if(rising_edge(clk_in) and we = '1') then
        RAM0(0) <= x"000"; -- negro
        RAM0(1) <= x"0F0"; -- verde
        RAM0(2) <= x"FB1"; -- amarillo
        RAM0(3) <= x"F0F"; -- morado
        RAM0(4) <= x"950"; -- marron
        RAM0(5) <= x"F00"; -- rojo
        RAM0(6) <= x"E60"; -- naranja
        RAM0(7) <= x"AAA"; -- gris
    end if; 
end process sync_write;
	
-- Lectura asíncrona
async_read: process(rebound_count_s, RAM0)
begin
    data_out <= RAM0(to_integer(unsigned(rebound_count_s)));
end process async_read;

-- Multiplexor para sacar un color por pantalla
mux_vga: process(marco_ext, marco_int, ball_sig, bar_sig, data_out)
begin 
    
    -- Bit 2: R
    -- Bit 1: G
    -- Bit 0: B
    if(ball_sig = '1') then
        rgb <= x"FFF";
    elsif(bar_sig = '1') then
        rgb <= x"FFF";
    elsif(marco_int = '1') then
        rgb <= data_out;
    elsif(marco_ext = '1') then
        rgb <= x"00F";
    else
        rgb <= x"000";
    end if;
    
end process;

end vgacore_arch;