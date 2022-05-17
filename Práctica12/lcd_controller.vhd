--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 12

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity lcd_controller is
 Generic( clk_freq : integer := 50; --Frecuencia del reloj del sistema en MHz
	 display_lines : std_logic:= '1';-- # de lineas del display (0=1-linea, 1=2-lineas)
	 character_font : std_logic := '0'; --Caracter (0 = 5x8 dots, 1 = 5x10 dots)
	 display_on_off : std_logic := '1'; --Display on/off (0 = off, 1 = on)
	 cursor : std_logic := '0'; --Cursor on/off (0 = off, 1 = on)
	 blink : std_logic := '1'; --Intermitencia on/off (0 = off, 1 = on)
	 inc_dec : std_logic := '1'; --Incrementar/decrementar (0 = decr, 1 = incr)
	shift : std_logic := '0'); --Desplazamiento on/off (0 = off, 1 = on)
 Port(clk : in std_logic; --Reloj del sistema
	 reset_n : in std_logic; --reinicia el sistema lcd
	 lcd_enable : in std_logic; --Mantiene los dato en el controlador lcd
	 lcd_bus : in std_logic_vector(9 downto 0); --señales de datos y control
	 busy : out std_logic := '1'; --Ocupado/Espera controlador lcd
	 rw, rs, e : out std_logic; --read/write, setup/data, y enable para el lcd
	 lcd_data : out std_logic_vector(7 downto 0)); --señales de datos lcd
end lcd_controller;

architecture controller of lcd_controller is
 Type CONTROL is(power_up, initialize, ready, send);
 Signal state : CONTROL;
Begin
 Process(clk)
 Variable clk_count : integer := 0; --contador para temporización
 Begin
 If(clk'event and clk = '1') then
 Case state is
	 When power_up =>
		 busy <= '1';
		 If(clk_count < (50000 * clk_freq)) then --Esperar 50 ms
			 clk_count := clk_count + 1;
			 state <= power_up;
		 Else --Alimentación completa y correcta
			 clk_count := 0;
			 rs <= '0';
			 rw <= '0';
			 lcd_data <= "00110000";
			state <= initialize;
		 End If;

	 --Ciclo para la secuencia de inicializacion
	 When initialize =>
		 busy <= '1';
		 clk_count := clk_count + 1;
		 If(clk_count < (10 * clk_freq)) then --function set
			 lcd_data <= "0011" & display_lines & character_font & "00";
			 e <= '1';
			state <= initialize;
		 elsif (clk_count < (60 * clk_freq)) then --Esperar 50 us
			 lcd_data <= "00000000";
			 e <= '0';
			 state <= initialize;
		 elsif (clk_count < (70 * clk_freq)) then --display on/off control
			 lcd_data <= "00001" & display_on_off & cursor & blink;
			 e <= '1';
			 state <= initialize;
		 elsif (clk_count < (120 * clk_freq)) then --Esperar 50 us
			 lcd_data <= "00000000";
			 e <= '0';
			 state <= initialize;
		 elsif (clk_count < (130 * clk_freq)) then --display clear
			 lcd_data <= "00000001";
			 e <= '1';
			 state <= initialize;
		 elsif (clk_count < (2130 * clk_freq)) then --Esperar 2 ms
			 lcd_data <= "00000000";
			 e <= '0';
			 state <= initialize;
		 elsif (clk_count < (2140 * clk_freq)) then --entry mode set
			 lcd_data <= "000001" & inc_dec & shift;
			 e <= '1';
			 state <= initialize;
		 elsif (clk_count < (2200 * clk_freq)) then --Esperar 60 us
			 lcd_data <= "00000000";
			 e <= '0';
			 state <= initialize;
		 else --Inicializacion completa
			 clk_count := 0;
			 busy <= '0';
			 state <= ready;
		 End If;

	 When ready =>
	 If(lcd_enable = '1') then
		 busy <= '1';
		 rs <= lcd_bus(9);
		 rw <= lcd_bus(8);
		 lcd_data <= lcd_bus(7 downto 0);
		 clk_count := 0;
		 state <= send;
	 else
		 busy <= '0';
		 rs <= '0';
		 rw <= '0';
		 lcd_data <= "00000000";
		 clk_count := 0;
		end if;

	 When send =>
	 busy <= '1';
	 If (clk_count < (50 * clk_freq)) then --Permanecer por 50us
		 IF(clk_count < clk_freq) then --negativo enable
			e <= '0';
		 elsif (clk_count < (14 * clk_freq)) then --medio-ciclo positivo de enable
			e <= '1';
		elsif (clk_count < (27 * clk_freq)) then --medio- ciclo negativo de enable
			e <= '0';
		End If;
		clk_count := clk_count + 1;
		 state <= send;
	 else
		 clk_count := 0;
		 state <= ready;
		 End If;
	 End Case;

 If (reset_n = '0') then
	state <= power_up;
 End If;

 End If;
 End Process;
End controller;
