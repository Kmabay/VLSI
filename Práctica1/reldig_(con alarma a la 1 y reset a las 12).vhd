--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 01
--Actividades Complementarias

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
	signal minuto,rapido,n,e,z,u,d,A,B,reset,UM,UH,DM,DH: std_logic;
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
	


	Unidades: process(minuto,reset)  --Unidades de minuto
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (minuto) then
			if (cuenta ="1001" or reset='1') then--cuando llegue a 9
				A<='1';--para el reset
				cuenta:="0000";
				n <= '1';
			else
				cuenta:= cuenta+1;
				n <= '0';
			end if;
			
		end if;
		if cuenta = "0000" then--para la alarma. en este caso de 0 minutos
				UM <= '1';
			else
				UM <= '0';
			end if;
		Qum <= cuenta;
	end process;
	
	
	decenas: process(n,reset)   --decenas de minutos
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (n) then
			if (cuenta ="0101" or reset='1') then--cuando llegue a 5
				cuenta:="0000";
				e <= '1';--valor 'bandera' para las unidades de hora
				B<='1';--para el reset
			else
				cuenta:= cuenta+1;
				e <= '0';
			end if;
			
		end if;   
		if cuenta = "0000" then--if para la alarma
				DM <= '1';
			else
				DM <= '0';
			end if;
		Qdm <= cuenta;
	end process;
	
	
	HoraU: Process(e, reset)  --Unidades de hora
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge(E) then
			if cuenta="1001" then--cuando llegue a 9
				cuenta:= "0000";
				Z<='1';
			else
				cuenta:=cuenta+1;
				Z<='0';
			end if;
		end if;
		if cuenta = "0001" then--para la alarma para este caso cuando sea 1 hora en las unidades
				UH<='1';
			else
				UH<='0';
		end if;
      if reset = '1' then--reset con un if parecido al del principio
			cuenta := "0000";
		end if; 
		Quh<=cuenta;
		U<=cuenta(1);--tomando el segundo valor de cuenta para aplicar el reset
	end process;
	

	HoraD: Process(Z,reset) --Decenas de hora
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge(Z) then
			if cuenta="0010" then-- cuando llega a 2
				cuenta:= "0000";
			else
				cuenta:=cuenta+1;
			end if;
			
		end if;
		if cuenta = "0000" then--if para la alarma
				DH <= '1';
			else
				DH <= '0';
			end if;
		if reset = '1' then--if del reset
			cuenta := "0000";
		end if;
		Qdh<=cuenta;
		D<=cuenta(0);--tomando el primer dígito de cuenta
	end process;
	
	
	
	inicia: process (U,D,A,B)
	begin
		reset <= (U and D and A and B);--reset solomcon los valores pedidos 11:59
	end process;
	
	alarma:process (UM,UH,DM,DH)--alarma que prende un foco en el instante pedido
	begin
		if((UM and UH and DM and DH)='1') then
			foco <= '1';
		else
			foco <='0';
		end if;
	end process;
	
	
	Contrapid: process (rapido)
		variable cuenta: std_logic_vector(1 downto 0) := "00";
	begin
		if rising_edge(rapido) then
			cuenta:= cuenta+1;
		end if;
		Qr <= cuenta;
	end process;
	
	--decodificador para los display
	
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
