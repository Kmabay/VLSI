--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 03
--Código ejemplo

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity leds is
Port( reloj: in std_logic;
 led1 : out std_logic;
 led2 : out std_logic;
 led3 : out std_logic;
 led4 : out std_logic);
end leds;
architecture behavioralLEDS of leds is

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
signal a1: std_logic_vector(7 downto 0):=X"08";
signal a2: std_logic_vector(7 downto 0):=X"20";
signal a3: std_logic_vector(7 downto 0):=X"60";
signal a4: std_logic_vector(7 downto 0):=X"F8";

begin
 N1: divisor generic map (10) port map (reloj, relojPWM);
 N2: divisor generic map (23) port map (reloj, relojCiclo);
 P1: PWM port map (relojPWM, a1, led1);
 P2: PWM port map (relojPWM, a2, led2);
 P3: PWM port map (relojPWM, a3, led3);
 P4: PWM port map (relojPWM, a4, led4);

 process (relojCiclo)
  variable cuenta : integer range 0 to 255 := 0;
  begin
  if (relojCiclo'event) and (relojCiclo = '1') then
   a1 <= a4;
   a2 <= a1;
   a3 <= a2;
   a4 <= a3;
  end if;
 end process;
end behavioralLEDS;
