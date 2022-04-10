--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 08
--Actividad Complementaria

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RX is 
	port(Clk: in std_logic;
			 RX_WIRE : in std_logic
			 display1: buffer std_logic_vector (6 downto 0);
			 display2: buffer std_logic_vector (6 downto 0);
			 display3: buffer std_logic_vector (6 downto 0);
			 display4: buffer std_logic_vector (6 downto 0);
			 display5: buffer std_logic_vector (6 downto 0);
			 display6: buffer std_logic_vector (6 downto 0);
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
			 SWT : in std_logic_vector(5 downto 0););
End Entity;


      
Architecture behavioral of RX is
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

Signal BUFF : std_logic_vector(9 downto 0);
Signal Flag : std_logic := '0';
Signal chek : std_logic := '1';
Signal PRE : integer range 0 TO 5208 := 0;
Signal INDICE : integer range 0 TO 9 := 0;
Signal PRE_val : integer range 0 to 41600;
Signal baud : std_logic_vector(2 downto 0);
signal relojPWM : std_logic;
signal relojCiclo : std_logic;
signal LEDS: STD_LOGIC_VECTOR(7 DOWNTO 0); 
signal Contador1: std_logic_vector(3 downto 0):= "0000";
signal Contador2: std_logic_vector(3 downto 0):= "0000";
signal Contador3: std_logic_vector(3 downto 0):= "0000";
signal Contador4: std_logic_vector(3 downto 0):= "0000";
signal Contador5: std_logic_vector(3 downto 0):= "0000";
signal a1: std_logic_vector(7 downto 0):= X"04";
signal a2: std_logic_vector(7 downto 0):= X"07";
signal a3: std_logic_vector(7 downto 0):= X"10";
signal a4: std_logic_vector(7 downto 0):= X"20";
signal a5: std_logic_vector(7 downto 0):= X"30";
signal a6: std_logic_vector(7 downto 0):= X"50";
signal a7: std_logic_vector(7 downto 0):= X"80";
signal a8: std_logic_vector(7 downto 0):= X"FF";
signal a9: std_logic_vector(7 downto 0):=X"00";
signal a10: std_logic_vector(7 downto 0):=X"00";




Begin
	N1: divisor generic map (10) port map (Clk, relojPWM);
   N2: divisor generic map (23) port map (Clk, relojCiclo);
   P1: PWM port map (relojPWM, a1, led1);
   P2: PWM port map (relojPWM, a2, led2);
   P3: PWM port map (relojPWM, a3, led3);
   P4: PWM port map (relojPWM, a4, led4);
	 P5: PWM port map (relojPWM, a5, led5);
   P6: PWM port map (relojPWM, a6, led6);
   P7: PWM port map (relojPWM, a7, led7);
   P8: PWM port map (relojPWM, a8, led8);
	
	RX_dato : Process(Clk)
	variable cuenta : integer range 0 to 255 := 0;

	Begin 
	
		If(Clk'EVENT and CLK = '1') then 
			If(Flag = '0' and RX_WIRE= '0') then
				Flag<= '1';
				INDICE<= 0;
				PRE<= 0;
			End If;
			If(Flag = '1') then 
				BUFF(INDICE)<=RX_WIRE;
			IF (PRE < PRE_val) THEN
                    PRE <= PRE + 1;
				else
					PRE<= 0;
				End If;
				If(PRE = PRE_val/2) then
					If(INDICE< 9) then
						INDICE <= INDICE + 1;
					else
						If(BUFF(0) = '0' and BUFF(9)= '1') then
						LEDS<=BUFF(8 downTO 1);--
						else
							 LEDS <= "00000000";
						End If;
						Flag <= '0';
					End If;
				End If;
			End If;
		End If;
	End Process RX_dato;
	
	
	baud<="011";
	WITH (baud) SELECT
    PRE_val <= 41600 WHEN "000", --1200 bauds
        20800 WHEN "001", --2400 bauds
        10400 WHEN "010", --4800 bauds
        5200 WHEN "011", --9600 bauds
        2600 WHEN "100", --19200 bauds
        1300 WHEN "101", --38400 bauds
        866 WHEN "110", --57600 bauds
        432 WHEN OTHERS; --115200 bauds
	
process (relojCiclo,LEDS)
    begin
         if rising_edge (relojCiclo) then
					IF (LEDS = "00110001" ) THEN
						  a8 <= a7;
						  a7 <= a6;
						  a6 <= a5;
						  a5 <= a4;
						  a4 <= a3;
						  a3 <= a2;
						  a2 <= a1;
						  a1 <= a8;
			       elsif (LEDS = "00110010") THEN

						  a8 <= a1;
						  a7 <= a8;
						  a6 <= a7;
						  a5 <= a6;
				  		a4 <= a5;
						  a3 <= a4;
						  a2 <= a3;
						  a1 <= a2;

				    elsif (LEDS = "00110011") then

					 
							if SWT(0) = '1' then 
								a1 <= a8;						
							else
								a1 <= a9;
							end if;
							
							if SWT(1) = '1' then
								a2 <= a8;
							else
								a2 <= a9;
							end if;
							
							if SWT(2) = '1' then
								a3 <= a8;
							else
								a3 <= a9;
							end if;
							
							if SWT(3) = '1' then 
								a4 <= a8;
							else
								a4 <= a9;
							end if;
							
							if SWT(4) = '1' then
								a5 <= a8;
							else
								a5 <= a9;
							end if;
							
							if SWT(5) = '1' then
								a6 <= a8;
							else
								a6 <= a9;
							end if;

					 elsif (LEDS = "00110100") then
							Contador1 <= Contador1 + 1; 
							Contador2 <= Contador2 + 1;
							Contador3 <= Contador3 + 1; 
							Contador4 <= Contador4 + 1; 
							Contador5 <= Contador5 + 1;
					 end if;
			end if;
end process;

with Contador1 select
			display1 <=
							"1000000" when	"0000",
							"1111001" when	"0001",							
							"1111111" when others;
with Contador2 select
			display2 <=
							"1000000" when	"0000",
							"1000000" when	"0001",						
							"1111111" when others;
with Contador3 select							
			display3 <=
							"1000000" when	"0000",
							"1000000" when	"0001",							
							"1111111" when others;
with Contador4 select						
			display4 <=
							"1000000" when	"0000",
							"1000000" when	"0001",							
							"1111111" when others;	
with Contador5 select
			display5 <=
							"1000000" when	"0000",
							"1111001" when	"0001",
							"0100100" when "0010",
							"0110000" when "0011",
							"0011001" when "0100",
							"0010010" when "0101",
							"0000010" when "0110",
							"1111000" when "0111",
							"0000000" when "1000",
							"0011000" when "1001",
							"1111111" when others;
End architecture behavioral;
