library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divf is
generic(num: integer:=25000000);
	port(
		clk: in std_logic;
	  clkl: buffer std_logic:='0'
	);
end entity;

architecture arqdivf of divf is
signal cuenta: integer range 0 to num;
begin
   process (clk)
   begin
      if rising_edge (clk) then
			if(cuenta=num) then
				cuenta<=0;
				clkl<= not clkl;
			else
				cuenta<=cuenta+1;
			end if;
      end if;
      end process;
end architecture;
