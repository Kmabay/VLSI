--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 10
--Actividades Complementarias

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.ALL;
Use IEEE.numeric_std.all;

Entity vga is
	generic( constant h_pulse: integer := 96;
				constant h_bp: integer := 48;
				constant h_pixels:integer := 640;
				constant h_fp: integer := 16;
				constant v_pulse: integer := 2;
				constant v_bp: integer := 33;
				constant v_pixels:integer := 480;
				constant v_fp: integer := 10);
	port( clk50Mhz: in std_logic;
			red: out std_logic_vector(3 downto 0);
			green: out std_logic_vector(3 downto 0);
			blue : out std_logic_vector(3 downto 0);
			h_sync: out std_logic;
			v_sync : out std_logic;
			swt : in std_logic_vector(1 downto 0));
end entity;

Architecture bhv of vga is
constant h_period : integer := h_pulse+h_bp+h_pixels+h_fp;
constant v_period : integer := v_pulse+v_bp+v_pixels+v_fp;
signal h_count : integer range 0 to h_period-1 := 0;
signal v_count : integer range 0 to v_period-1 := 0;

signal reloj_pixel : std_logic;
signal column : integer := 0;
signal row : integer :=0;
signal display_ena : std_logic ;

Begin
	relojpixel : Process(clk50MHz) is
	Begin
		If rising_edge(clk50MHz) then
			reloj_pixel <= not reloj_pixel;
		End If;
	End Process relojpixel;
	
	contadores : Process(reloj_pixel) -- H_periodo=800, V_periodo=525 
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count < h_period-1) then
				h_count <= h_count + 1;
			else
				h_count <= 0;
				If (v_count < v_period-1) then
					v_count <= v_count + 1;
				else
					v_count <= 0;
				End If;
			End If;
		End If;
	End Process contadores;
	
	senial_vsync: Process(reloj_pixel) --v_pixel + v_fp + v_pulse = 525
	Begin
		If rising_edge(reloj_pixel) then
			If (v_count >= v_pixels + v_fp) and
				(v_count >= v_pixels + v_fp + v_pulse - 1) then
					v_sync <= '0';
			else
				v_sync <= '1';
			End If;
		End If;
	End Process senial_vsync;
	
	senial_hsync: Process(reloj_pixel) --h_pixels + h_fp + h_pulse = 784
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count >= h_pixels + h_fp) and	(h_count >= h_pixels + h_fp + h_pulse - 1) then
				h_sync <= '0';
			else
				h_sync <= '1';
			End If;
		End If;
	End Process senial_hsync;
	
	coords_pixel: Process(reloj_pixel) --h_pixels + h_fp + h_pulse = 784
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count < h_pixels) then
				column <= h_count;
			End If;
			If (v_count < v_pixels) then
				row <= v_count;
			End If;
		End If;
	End Process coords_pixel;
	
	display_enable: Process(reloj_pixel) --h_pixels = 640 y v_pixels = 480
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count < h_pixels and v_count < v_pixels) then
				display_ena <= '1';
			Else
				display_ena <= '0';
			End If;
		End If;
	End Process display_enable;
	
	imagen: Process(display_ena, row, column)
	Begin
		if (display_ena = '1') then 
		case swt is 
		When "00" =>
			if ((row > 1 and row <331) and (column > 97 and column < 189)) then -- azul
				red <= ( others => '0');
				green <= ( others => '0');
				blue <= ( others => '1');
			elsif((row > 1 and row <331) and (column > 187 and column < 283)) then -- rojo
				red <= ( others => '1');
				green <= ( others => '0');
				blue <= ( others => '0');
			elsif ((row > 1 and row <331) and (column > 281 and column < 372)) then -- magenta
				red <= ( others => '1');
				green <= ( others => '0');
				blue <= ( others => '1');
			elsif ((row > 1 and row <331) and (column > 370 and column < 461)) then -- verde
				red <= ( others => '0');
				green <= ( others => '1');
				blue <= ( others => '0');
			elsif ((row > 1 and row <331) and (column > 459 and column < 550)) then -- cian
				red <= ( others => '0');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif ((row > 1 and row <331) and (column > 548 and column < 639)) then -- amarillo
				red <= ( others => '1');
				green <= ( others => '1');
				blue <= ( others => '0');
			elsif ((row > 329 and row <391) and (column > 97 and column < 189)) then -- BLANCO
				red <= ( others => '1');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif((row > 329 and row <391) and (column > 187 and column < 283)) then -- NEGRO
				red <= ( others => '0');
				green <= ( others => '0');
				blue <= ( others => '0');
			elsif ((row > 329 and row <391) and (column > 281 and column < 372)) then -- CIAN
				red <= ( others => '0');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif ((row > 329 and row <391) and (column > 370 and column < 461)) then -- AMARILLO
				red <= ( others => '1');
				green <= ( others => '1');
				blue <= ( others => '0');
			elsif ((row > 329 and row <391) and (column > 459 and column < 550)) then -- MAGENTA
				red <= ( others => '1');
				green <= ( others => '0');
				blue <= ( others => '1');
			elsif ((row > 329 and row <391) and (column > 548 and column < 639)) then -- NEGRO
				red <= ( others => '1');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif ((row > 329 and row <391) and (column > 638 and column < 640)) then -- AZUL
				red <= ( others => '0');
				green <= ( others => '0');
				blue <= ( others => '1');
			elsif ((row > 389 and row <480) and (column > 97 and column < 189)) then -- negro
				red <= ( others => '0');
				green <= ( others => '0');
				blue <= ( others => '0');
			elsif((row > 389 and row <480) and (column > 187 and column < 372)) then -- gris
				red <= ( others => '0');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif ((row > 389 and row <480) and (column > 370 and column < 416)) then -- azul
				red <= ( others => '0');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif ((row > 389 and row <480) and (column > 414 and column < 501)) then -- blanco
				red <= ( others => '1');
				green <= ( others => '1');
				blue <= ( others => '1');
			elsif ((row > 389 and row <480) and (column > 499 and column < 550)) then -- índigo
				red <= ( others => '0');
				green <= ( others => '1');
				blue <= ( others => '1');
			else
				red <= ( others => '1');
				green <= ( others => '1');
				blue <= ( others => '1');
			end if;
			
			When "01" =>
				 if ((row > 50 and row < 76 ) and(column > 300 and column < 425 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 74 and row < 101 ) and (column > 250 and column < 475 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 99 and row < 126 ) and (column > 225 and column < 500 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 124 and row < 176 ) and (column > 200 and column < 350 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 124 and row < 176 ) and (column > 400 and column < 525 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 174 and row < 231 ) and (column > 175 and column < 550 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 229 and row < 251 ) and (column > 175 and column < 325 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 249 and row < 301 ) and (column > 175 and column < 550 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 299 and row < 351 ) and (column > 200 and column < 325 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 299 and row < 351 ) and (column > 225 and column < 525 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 349 and row < 376 ) and (column > 225 and column < 500 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 374 and row < 401 ) and (column > 250 and column < 475 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 399 and row < 425 ) and (column > 300 and column < 425 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				else
					 red <= (others => '0');
					 green <= (others => '0');
					 blue <= (others => '0');
				 End if;
				 
			When others =>
				if ((row > 50 and row < 76 ) and(column > 300 and column < 425 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 74 and row < 101 ) and (column > 250 and column < 475 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 99 and row < 126 ) and (column > 225 and column < 500 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 124 and row < 176 ) and (column > 200 and column < 350 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 124 and row < 151 ) and (column > 400 and column < 475 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 149 and row < 176 ) and (column > 400 and column < 425 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 174 and row < 201 ) and (column > 175 and column < 401 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 199 and row < 226 ) and (column > 175 and column < 350 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 224 and row < 251 ) and (column > 175 and column < 325 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 249 and row < 276 ) and (column > 175 and column < 350 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 274 and row < 301 ) and (column > 175 and column < 400 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 299 and row < 326 ) and (column > 200 and column < 425 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 324 and row < 351 ) and (column > 200 and column < 475 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 349 and row < 376 ) and (column > 225 and column < 500 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 374 and row < 401 ) and (column > 250 and column < 475 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				elsif
					((row > 399 and row < 425 ) and (column > 300 and column < 425 )) then
					 red <= ( others => '1');
					 green <= ( others => '1');
					 blue <= ( others => '0');
				else				 
					 red <= (others => '0');
					 green <= (others => '0');
					 blue <= (others => '0');
				 end if;
				 
				 
				end case;
			end if;
	End Process imagen;
	
End architecture bhv;
