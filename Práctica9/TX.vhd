--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 09
--Actividad Complementaria

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TX is 
	port(reloj: in std_logic;swt: in std_logic_vector(3 downto 0);TX_WIRE,led: out std_logic);
End Entity;

Architecture bhv of TX is

Signal valor:integer := 70000;
Signal conta:integer := 0;
Signal INICIO : std_logic;
Signal dato : std_logic_vector(7 downto 0);
Signal flag : std_logic := '0';
Signal PRE : integer range 0 to 5208 := 0;
Signal INDICE : integer range 0 to 9 := 0;
Signal PRE_val : integer range 0 to 41600;
Signal baud : std_logic_vector(2 downto 0);
Signal i : integer range 0 to 9;
Signal pulso : std_logic := '0';
signal hex_Val: std_logic_vector(7 downto 0):= (others => '0');
signal BUFF  : std_logic_vector(9 downto 0);
signal conta2: integer range 0 to 49999999 := 0;
signal dato_bin: std_logic_vector(3 downto 0);


Begin
	TX_divisor: process(reloj)
	begin
		if rising_edge(reloj) then
			conta2 <= conta2+1;
			if (conta2 < 140000) then
				pulso <= '1';
			else
				pulso <= '0';
			end if;
		end if;
	end process TX_divisor;


	TX_prepara : process(reloj,pulso)
		Type arreglo is array (0 to 8) of std_logic_vector(7 downto 0);
		Variable asc_dato : arreglo := (x"30",x"20",x"62",x"61",x"73",x"65",x"20",x"32",x"0A");
		Begin
			asc_dato(0) := hex_val;
			if(pulso = '1') then
				if rising_edge(reloj) then
					if(conta = valor) then 
						conta <= 0;
						INICIO <= '1';
						dato <= asc_dato(i);
						if(i=8) then
							i <= 0;
						else
							i <= i+1;
						end if;
					else
						conta <= conta+1;
						INICIO <= '0';
					end if;
				end if;
			end if;
		end process TX_prepara;
	
	TX_envia : Process(reloj,inicio,dato)
	Begin
		if(reloj'EVENT and reloj = '1') then
			if(FLAG = '0' and INICIO = '1') then
				FLAG <= '1';
				BUFF(0) <= '0';
				BUFF(9) <= '1';
				BUFF(8 downto 1) <= dato;
			end if;
			if (flag = '1') then
				if(PRE < PRE_val) then
					PRE <= PRE + 1;
				else
					PRE <= 0;
				end if;
				if(PRE = PRE_val/2) then
					TX_WIRE <= BUFF(INDICE);
					if(indice < 9)then
						indice <= indice+1;
					else
						FLAG <= '0';
						INDICE <= 0;
					end if;
				end if;
			end if;
		end if;
	end process TX_envia;
	
	LED <= pulso;
	baud <= "011";
	dato_bin <= swt;
	
	with(dato_bin) select
		hex_val <= X"30" when "0000",
					  X"31" when "0001",
					  X"32" when "0010",
					  X"33" when "0011",
					  X"34" when "0100",
					  X"35" when "0101",
					  X"36" when "0110",
					  X"37" when "0111",
					  X"38" when "1000",
					  X"39" when "1001",
					  X"41" when "1010",
					  X"42" when "1011",
					  X"43" when "1100",
					  X"44" when "1101",
					  X"45" when "1110",
					  X"46" when "1111",
					  X"23" when others;
	
	WITH (baud) SELECT
		PRE_val <=  41600 WHEN "000", --1200 bauds
						20800 WHEN "001", --2400 bauds
						10400 WHEN "010", --4800 bauds
						 5200 WHEN "011", --9600 bauds
						 2600 WHEN "100", --19200 bauds
						 1300 WHEN "101", --38400 bauds
						  866 WHEN "110", --57600 bauds
						  432 WHEN OTHERS; --115200 bauds

end architecture bhv;
