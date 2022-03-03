--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 03
--Actividades Complementaria 2

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity leds is
	Port( reloj: in std_logic;
		led1 : out std_logic;
		led2 : out std_logic;
		led3 : out std_logic;
		led4 : out std_logic;
		led5 : out std_logic;
		led6 : out std_logic;
		led7 : out std_logic;
		led8 : out std_logic;
		led9 : out std_logic;
		led10 : out std_logic;
		direccion: in std_logic);
end leds;

architecture behavioral of leds is

Component PWM is
	Port( reloj_pwm: in std_logic;
		D : in std_logic_vector (7 downto 0);
		S : out std_logic);
end component;

Component divisor is
	Generic (N : integer := 24);
	Port( reloj: in std_logic;
		div_reloj : out std_logic);
end component;

signal relojPWM : std_logic;
signal relojCiclo : std_logic;
signal a1: std_logic_vector(7 downto 0):=X"04";
signal a2: std_logic_vector(7 downto 0):=X"07";
signal a3: std_logic_vector(7 downto 0):=X"10";
signal a4: std_logic_vector(7 downto 0):=X"20";
signal a5: std_logic_vector(7 downto 0):=X"30";
signal a6: std_logic_vector(7 downto 0):=X"50";
signal a7: std_logic_vector(7 downto 0):=X"80";
signal a8: std_logic_vector(7 downto 0):=X"F8";
signal a9: std_logic_vector(7 downto 0):=X"00";
signal a10: std_logic_vector(7 downto 0):=X"00";

begin
	N1: divisor generic map (10) port map (reloj, relojPWM);
	N2: divisor generic map (23) port map (reloj, relojCiclo);
	P1: PWM port map (relojPWM, a1, led1);
	P2: PWM port map (relojPWM, a2, led2);
	P3: PWM port map (relojPWM, a3, led3);
	P4: PWM port map (relojPWM, a4, led4);
	P5: PWM port map (relojPWM, a5, led5);
	P6: PWM port map (relojPWM, a6, led6);
	P7: PWM port map (relojPWM, a7, led7);
	P8: PWM port map (relojPWM, a8, led8);

process (relojCiclo)
	variable cuenta : integer range 0 to 255 := 0;
	variable bandera : std_logic;
	begin
	if (relojCiclo'event) and (relojCiclo = '1') then
	
		
		if direccion = '0' then
			if a1 = X"F8" then
				bandera:= '1';
			elsif a8 = X"F8" then
				bandera:= '0';
			end if;
			if bandera = '1' then
				a8 <= a7;
				a7 <= a6;
				a6 <= a5;
				a5 <= a4;
				a4 <= a3;
				a3 <= a2;
				a2 <= a1;
				a1 <= a8;
			elsif bandera = '0' then
				a8 <= a1;
				a7 <= a8;
				a6 <= a7;
				a5 <= a6;
				a4 <= a5;
				a3 <= a4;
				a2 <= a3;
				a1 <= a2;
			end if;
		else
			if a1 = X"F8" then
				bandera:= '0';
			elsif a8 = X"F8" then
				bandera:= '1';
			end if;
			if bandera = '0' then
				a8 <= a7;
				a7 <= a6;
				a6 <= a5;
				a5 <= a4;
				a4 <= a3;
				a3 <= a2;
				a2 <= a1;
				a1 <= a8;
			elsif bandera = '1' then
				a8 <= a1;
				a7 <= a8;
				a6 <= a7;
				a5 <= a6;
				a4 <= a5;
				a3 <= a4;
				a2 <= a3;
				a1 <= a2;
			end if;
		end if;
	end if;
end process;
end behavioral;