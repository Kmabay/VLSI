--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 01
--Reloj en cuenta regresiva

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity reldig is
port( reloj,stop: in std_logic;
	   L0: out std_logic_vector(6 downto 0);
	   L1: out std_logic_vector(6 downto 0);
	   L2: out std_logic_vector(6 downto 0);
	   L3: out std_logic_vector(6 downto 0);--vectores para los display restantes
		foco: out std_logic);--foco que indicara la alarma
end reldig;

architecture arq of reldig is
	signal minuto,rapido,n,e,z,u,d,reset: std_logic;
	signal Qs,Qum,Qdm,Quh,Qdh: std_logic_vector(3 downto 0);
	signal Qr: std_logic_vector(1 downto 0);
	
begin

	divisor: process(reloj)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge(reloj) then
		 if stop = '1' then               
			if cuenta=X"48009E0" then
				cuenta:= X"0000000";
			else
				cuenta:= cuenta+1;
			end if;
		 end if;                         
		end if;
		minuto <= cuenta(22);
		rapido <= cuenta(10);
	end process;
	


	Unidades: process(minuto, reset)  --UniMin = Unidades de minuto
		variable cuenta: std_logic_vector(3 downto 0) := "1001";--9
	begin
		if rising_edge (minuto) then
			if cuenta ="0000" then
				cuenta:="1001";
				n <= '1';
			else
				cuenta:= cuenta-1;
				n <= '0';
			end if;	
		end if;
		if reset='0' then      
		  cuenta:="1001";
		end if;                
		qum <= cuenta;
	end process;
	
	
	decenas: process(n, reset)   --DecMin = Decenas de minutos
		variable cuenta: std_logic_vector(3 downto 0) := "0101";
	begin
		if rising_edge (n) then
			if cuenta ="0000" then
				cuenta:="0101";
				e <= '1';
			else
				cuenta:= cuenta-1;
				e <= '0';
			end if;
		end if;
		if reset='0' then     
			cuenta:="0101";
		end if;               
		Qdm <= cuenta;
	end process;
	
	
	HoraU: Process(E,reset)  --UniHr = Unidades de hora
		variable cuenta: std_logic_vector(3 downto 0) := "0011";--3
	begin
		if rising_edge(E) then
			if cuenta="0000" then
				cuenta:= "0011";
				Z<='1';
			else
				cuenta:=cuenta-1;
				Z<='0';
			end if;
		end if;
		if reset='0' then    
			cuenta:="0011";
		end if;              
		Quh<=cuenta;
		U<=cuenta(2);
	end process;
	

	HoraD: Process(Z,reset) --DecHr = Decenas de hora
		variable cuenta: std_logic_vector(3 downto 0) := "0010";
	begin
		if rising_edge(Z) then
			if cuenta="0000" then
				cuenta:= "0010";
			else
				cuenta:=cuenta-1;
			end if;
		end if;
		if reset='0' then     
			cuenta:="0010";
		end if;               
		Qdh<=cuenta;
		D<=cuenta(1);
	end process;
	
	
	inicia: process (U,D)
	begin
		reset1 <= (U and D);
	end process;
	
	
	Contrapid: process (rapido)
		variable cuenta: std_logic_vector(1 downto 0) := "00";
	begin
		if rising_edge(rapido) then
			cuenta:= cuenta+1;
		end if;
		Qr <= cuenta;
	end process;
	
	
	with Qum select L0 <= 
				"1000000" when "0000",
				"1111001" when "0001",
				"0100100" when "0010", 
				"0110000" when "0011",--
				"0011001" when "0100",
				"0010010" when "0101",
				"0000010" when "0110",
				"1111000" when "0111",
				"0000000" when "1000",
				"0011000" when "1001",
				"0000000" when others;
	
	with Qdm select L1 <=	
				"1000000" when "0000",		
				"1111001" when "0001",		
				"0100100" when "0010",		
				"0110000" when "0011",		
				"0011001" when "0100",		
				"0010010" when "0101",		
				"0000000" when others;
	
	
	with Quh select L2 <=
				"1000000" when "0000",
				"1111001" when "0001",
				"0100100" when "0010",
				"0110000" when "0011",
				"0011001" when "0100",
				"0010010" when "0101",
				"0000010" when "0110",
				"1111000" when "0111",
				"0000000" when "1000",
				"0011000" when "1001",
				"0000000" when others;
	
	
	with Qdh select L3 <=
				"1000000" when "0000",		
				"1111001" when "0001",		
				"0100100" when "0010",		
				"0000000" when others;

end architecture arq;