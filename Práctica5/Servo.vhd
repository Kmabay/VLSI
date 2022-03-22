--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 05
--Actividades Complementarias

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

Entity Servo is
	Port (reloj_sv : in std_logic;
			Pini, Pfin, Inc, Dec : in std_logic;
			control: out std_logic;
			control2 : out std_logic;
			display1,display2,display3: out std_logic_vector(6 downto 0));
End entity;

Architecture Behavioral of Servo is

Component divisor is
	Port (reloj : in std_logic;
			div_reloj: out std_logic);
End Component;

Component pwm is
	Port (reloj_pwm : in std_logic;
		D: in std_logic_vector(7 downto 0);
		S: out std_logic);
End Component;

component angle is
	port( Deg: std_logic_vector(7 downto 0);
		disp1,disp2,disp3: out std_logic_vector(6 downto 0));
end Component;


Signal reloj_serv: std_logic;
Signal ancho,ancho2 : std_logic_vector(7 downto 0) := X"00";


Begin
	U1 : divisor Port map(reloj_sv, reloj_serv);
	U2: pwm Port map(reloj_serv, ancho, control);
	U3: pwm Port map(reloj_serv, ancho2, control2);
	U4: angle port map(ancho2,display1,display2,display3);
	
Servo1:Process(reloj_serv, Pini, Pfin, Inc, Dec)
	Variable valor,valor2 : std_logic_vector(7 downto 0) := X"0F";
	Variable cuenta : integer range 0 to 1023 := 0;
	Begin
	If reloj_serv= '1' and reloj_serv'event then
		If (cuenta > 0) then
		cuenta := cuenta - 1;
		Else
			If Pini = '0' then
				valor := X"05";
				valor2 :=X"1F";
			Elsif Pfin = '0' then
				valor := X"1F";
				valor2 :=X"05";
			Elsif Inc = '0' and (valor < X"1F" or valor2 <X"05") then
				valor := valor + 1;
				valor2 :=valor2-1;
			Elsif Dec = '0' and (valor > X"05" or valor2 >X"1F") then
				valor := valor - 1;
				valor2:= valor2 +1;
			End if;
			
		cuenta := 1023;
		End if;
	End if;
	
 ancho <= valor;
 ancho2 <= valor2;

 End process;
 
 End behavioral;
