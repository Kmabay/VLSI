--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 07
--Actividades Complementarias

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

Entity mot_pasodeuno is
		Port (reloj, reset, stop,dir: in std_logic;
				dato_motor: out std_logic_vector(3 downto 0);
				sel : in std_logic_vector(1 downto 0);
				display: out std_logic_vector(6 downto 0));
End Entity;

Architecture behavioral of mot_pasodeuno is

Component divf is
		Port (reloj : in std_logic;relojS: out std_logic);
End Component;

Type state is (inicia, cero, uno, dos, tres, cuatro, cinco, seis, siete);
Signal pr_state, nx_state : state;
signal relojS: std_logic;
signal Contador: std_logic_vector(3 downto 0);

begin
		u0 : entity work.divf(arqdivf) generic map(250000) port map(reloj,relojS);
		
	arranca: Process (reset, relojS)
		Begin
				If (reset='0') then
						pr_state <= inicia;
				elsif relojS ='1' and relojS'event then
						pr_state <= nx_state;
				End if;
		End Process;
		
	marcha: Process(pr_state, stop,dir)
	variable cuenta: std_logic_vector(3 downto 0) := "1111";
		begin
		if(dir = '0') then
			if sel = "10" then
				Case pr_state is
					when inicia =>
						if stop = '0' then
							nx_state <= inicia;
						else
							nx_state <= cero;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when cero =>
						if stop = '0' then
							nx_state <= cero;
						else
							nx_state <= uno;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when uno =>
						if stop = '0' then
							nx_state <= uno;
						else
							nx_state <= dos;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when dos =>
						if stop = '0' then
							nx_state <= dos;
						else
							nx_state <= tres;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when tres =>
						if stop = '0' then
							nx_state <= tres;
						else
							nx_state <= cuatro;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when cuatro =>
						if stop = '0' then
							nx_state <= cuatro;
						else
							nx_state <= cinco;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when cinco =>
						if stop = '0' then
							nx_state <= cinco;
						else
							nx_state <= seis;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when seis =>
						if stop = '0' then
							nx_state <= seis;
						else
							nx_state <= siete;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when siete =>
						if stop = '0' then
							nx_state <= siete;
						else
							nx_state <= cero;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when others =>
						if stop = '0' then
							nx_state <= pr_state;
						else
							nx_state <= inicia;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
				End Case;
			else
				Case pr_state is
					when inicia =>
						if stop = '0' then
							nx_state <= inicia;
						else
							nx_state <= cero;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when cero =>
						if stop = '0' then
							nx_state <= cero;
						else
							nx_state <= uno;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when uno =>
						if stop = '0' then
							nx_state <= uno;
						else
							nx_state <= dos;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when dos =>
						if stop = '0' then
							nx_state <= dos;
						else
							nx_state <= tres;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when tres =>
						if stop = '0' then
							nx_state <= tres;
						else
							nx_state <= cuatro;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when cuatro =>
						if stop = '0' then
							nx_state <= cuatro;
						else
							nx_state <= cero;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
					when others =>
						if stop = '0' then
							nx_state <= pr_state;
						else
							nx_state <= inicia;
							if cuenta = "1111" then
								cuenta := "0000";
							else
								cuenta:=cuenta+1;
							end if;
						end if;
				end case;
			end if;
		else
			if sel = "10" then
				Case pr_state is
					when inicia =>
						if stop = '0' then
							nx_state <= inicia;
						else
							nx_state <= cero;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when cero =>
						if stop = '0' then
							nx_state <= cero;
						else
							nx_state <= siete;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when siete =>
						if stop = '0' then
							nx_state <= siete;
						else
							nx_state <= seis;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when seis =>
						if stop = '0' then
							nx_state <= seis;
						else
							nx_state <= cinco;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when cinco =>
						if stop = '0' then
							nx_state <= cinco;
						else
							nx_state <= cuatro;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when cuatro =>
						if stop = '0' then
							nx_state <= cuatro;
						else
							nx_state <= tres;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when tres =>
						if stop = '0' then
							nx_state <= tres;
						else
							nx_state <= dos;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when dos =>
						if stop = '0' then
							nx_state <= dos;
						else
							nx_state <= uno;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when uno =>
						if stop = '0' then
							nx_state <= uno;
						else
							nx_state <= cero;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when others =>
						if stop = '0' then
							nx_state <= pr_state;
						else
							nx_state <= inicia;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
				End Case;
			else
				Case pr_state is
					when inicia =>
						if stop = '0' then
							nx_state <= inicia;
						else
							nx_state <= cero; 
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when cero =>
						if stop = '0' then
							nx_state <= cero;
						else
							nx_state <= cuatro;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when uno =>
						if stop = '0' then
							nx_state <= uno;
						else
							nx_state <= cero;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when dos =>
						if stop = '0' then
							nx_state <= dos;
						else
							nx_state <= uno;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when tres =>
						if stop = '0' then
							nx_state <= tres;
						else
							nx_state <= dos;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when cuatro =>
						if stop = '0' then
							nx_state <= cuatro;
						else
							nx_state <= tres;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;
					when others =>
						if stop = '0' then
							nx_state <= pr_state;
						else
							nx_state <= inicia;
							if cuenta = "0000" then
								cuenta := "1111";
							else
								cuenta:=cuenta-1;
							end if;
						end if;					
				end case;
			end if;	
		end if;
		Contador <= cuenta;
    end process;
		
	secuencias:Process(pr_state)
		Begin
				if sel = "01" then
					Case pr_state is
						When inicia => dato_motor <= "0000";
						When cero 	=> dato_motor <= "1000";
						When uno 	=> dato_motor <= "0100";
						When dos 	=> dato_motor <= "0010";
						When tres 	=> dato_motor <= "0001";
						When others => NULL;
					End Case;

				
				elsif sel = "11" then
					Case pr_state is
						When inicia => dato_motor <= "0000";
						When cero 	=> dato_motor <= "1100";
						When uno 	=> dato_motor <= "1000";
						When dos 	=> dato_motor <= "0011";
						When tres 	=> dato_motor <= "1001";
						When others => NULL;
					End Case;
				
				
				elsif sel = "10" then
					Case pr_state is
						When inicia => dato_motor <= "0000";
						When cero 	=> dato_motor <= "1000";
						When uno 	=> dato_motor <= "1100";
						When dos 	=> dato_motor <= "0100";
						When tres 	=> dato_motor <= "0110";
						When cuatro => dato_motor <= "0010";
						When cinco 	=> dato_motor <= "0011";
						When seis 	=> dato_motor <= "0001";
						When siete 	=> dato_motor <= "1001";
						When others => NULL;
					End Case;
				end if;				
		End Process;
	with Contador select display <= 
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
				"0001000" when "1010",
				"0000011" when "1011",
				"1000110" when "1100",
				"0100001" when "1101",
				"0000110" when "1110",
				"0001110" when "1111",
				"0000000" when others;

End architecture behavioral;
