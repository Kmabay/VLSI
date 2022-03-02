--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 03
--Código ejemplo

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity divisor is
 Generic (N : integer := 24);
 Port( reloj: in std_logic;
  div_reloj : out std_logic);
end divisor;

architecture behavioral of divisor is
begin
 process (reloj)
  variable cuenta : std_logic_vector (27 downto 0) := X"0000000";
  begin
  if rising_edge(reloj) then
   cuenta := cuenta + 1;
  end if;
  div_reloj <= cuenta(N);
 end process;
end behavioral;
