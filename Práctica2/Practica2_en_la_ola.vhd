Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity Practica2 is
	Port( reloj: in std_logic;
			display1, display2, display3, display4, display5,display6: buffer std_logic_vector (6 downto 0));
end Practica2;

architecture behavioral of Practica2 is
	signal segundo: std_logic;
	signal Q: std_logic_vector(3 downto 0):= "0000";

	begin
	divisor: process (reloj)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if (rising_edge(reloj)) then
			if (cuenta = X"48009E0") then
				cuenta := X"0000000";
			else
				cuenta := cuenta + 1;
			end if;
		end if;
		segundo <= cuenta(22);
	end process;
	
	contador: process (segundo)
	begin
		if rising_edge(segundo) then
			Q <= Q + 1;
		end if;
	end process;
	
	with Q select
		display1 <= "0000110" when "0000",
						"0101011" when "0001",
						"1111111" when "0010",
						"1000111" when "0011",
						"0001000" when "0100",
						"1111111" when "0101",
						"1000000" when "0110",
						"1000111" when "0111",
						"0001000" when "1000",
						"1111111" when others;


	FF1: process(segundo)
	begin
		if rising_edge(segundo) then
			display2 <= display1;
		end if;
	end process;

	FF2: process(segundo)
	begin
		if rising_edge(segundo) then
			display3 <= display2;
		end if;
	end process;

	FF3: process(segundo)
	begin
		if rising_edge(segundo) then
			display4 <= display3;
		end if;
	end process;

	FF4: process(segundo)
	begin
		if rising_edge(segundo) then
			display5 <= display4;
		end if;
	end process;
	
	FF5: process(segundo)
	begin
		if rising_edge(segundo) then
			display6 <= display5;
		end if;
	end process;
end behavioral;