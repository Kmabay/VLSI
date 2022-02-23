--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 02
--Actividades Complementarias

Library IEEE; 
Use IEEE.Std_logic_1164.all; 
Use IEEE.Std_logic_arith.all; 
Use IEEE.Std_logic_unsigned.all;
 
entity Practica2 is 
	Port( 
			inicio, reloj: in std_logic;
			selector: in std_logic_vector (1 downto 0);		
			display1, display2, display3, display4, display5, display6 : buffer std_logic_vector (6 downto 0)
			); 
			
end Practica2; 

architecture behavioral of Practica2 is 
	signal segundo : std_logic; 
	signal Q: std_logic_vector(4 downto 0):= "00000"; 
	begin 
		divisor: process (reloj) 
		variable cuenta : std_logic_vector (27 downto 0) := X"0000000"; begin 
		if rising_edge(reloj) then 
			if cuenta = X"48009E0" then 
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
	
	menu: process(inicio)
	begin
	
	if (inicio='0') then 
	
	case Q is

	when "00000" => display1 <= "0000011"; -- b
	when "00001" => display1 <= "0000100"; -- e 
	when "00010" => display1 <= "0000011"; -- b
	when "00011" => display1 <= "1111011"; -- i
	when "00100" => display1 <= "0100001"; -- d
	when "00101" => display1 <= "0100000"; -- a 
	when "00110" => display1 <= "0010010"; -- s
	when "00111" => display1 <= "1111111"; --  
	when "01000" => display1 <= "0110000"; -- 3 
	when "01001" => display1 <= "1111111"; -- 
	when "01010" => display1 <= "0100001"; -- d
	when "01011" => display1 <= "1101111"; -- i
	when "01100" => display1 <= "0010010"; -- s 
	when "01101" => display1 <= "0001100"; -- p
	when "01110" => display1 <= "0100011"; -- o
	when "01111" => display1 <= "0101011"; -- 
	when "10000" => display1 <= "1101111"; -- 
	when "10001" => display1 <= "0000011"; --  
	when "10010" => display1 <= "1001111"; -- 
	when "10011" => display1 <= "0000100"; --  
	when "10100" => display1 <= "0010010"; -- 
	when "10101" => display1 <= "1111111"; -- 
	when others => display1 <= "1111111";
	end case;
	
	else
		if(selector="00") then
			case Q is
				when "00000" => display1 <= "0010001";--y
				when "00001" => display1 <= "0100000";--a
				when "00010" => display1 <= "0100111";--c
				when "00011" => display1 <= "1100011";--u
				when "00100" => display1 <= "1001111";--l
				when "00101" => display1 <= "0001111";--t
				when "00110" => display1 <= "1111111";--
				when "00111" => display1 <= "1001111";--1
				when "01000" => display1 <= "0110000";--3
				when "01001" => display1 <= "1111111";--
				when others => display1 <= "1111111" ;--
			end case;
		elsif(selector="01")then
			case Q is
				when "00000" => display1 <= "1100001";--j
				when "00001" => display1 <= "1100011";--u
				when "00010" => display1 <= "0010000";--g
				when "00011" => display1 <= "0100011";--o
				when "00100" => display1 <= "1111111";--
				when "00101" => display1 <= "0000000";--9
				when "00110" => display1 <= "1111111";--
				when others => display1 <= "1111111" ; -- 
			end case;
		elsif(selector="10")then
			case Q is
				when "00000" => display1 <= "1000001";--v
				when "00001" => display1 <= "1001111";--i
				when "00010" => display1 <= "1000001";--v
				when "00011" => display1 <= "0000100";--e
				when "00100" => display1 <= "1001111";--1
				when "00101" => display1 <= "1000000";--0
				when "00110" => display1 <= "1000000";--0
				when "00111" => display1 <= "1111111";--
				when "01000" => display1 <= "0100100";--2
				when "01001" => display1 <= "0100100";--2
				when "01011" => display1 <= "1111111";--
				when others => display1 <= "1111111" ; -- 
			end case;
		else
			case Q is
				when "00000" => display1 <= "0100000"; -- a
				when "00001" => display1 <= "0010000"; -- g 
				when "00010" => display1 <= "0100011"; -- o 
				when "00011" => display1 <= "0001111"; -- t
				when "00100" => display1 <= "0100000"; -- a 
				when "00101" => display1 <= "0100001"; -- d 
				when "00110" => display1 <= "0100011"; -- o 
				when "00111" => display1 <= "1111111"; --  
				when others => display1 <= "1111111" ; -- 
			end case;
		end if;
	end if;
	end process;
		
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