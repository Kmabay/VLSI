--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 06
--Actividades Complementaria

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity Sensor is 
	Port (clk: in std_logic;
	sensor_disp: out std_logic;
	sensor_eco: in std_logic;
	display_uni: out std_logic_vector(6 downto 0);
	display_dec: out std_logic_vector(6 downto 0);
	aviso1: out std_logic_vector(6 downto 0);
	aviso2: out std_logic_vector(6 downto 0);
	aviso3: out std_logic_vector(6 downto 0);
	aviso4: out std_logic_vector(6 downto 0)
	);
end Sensor;

architecture behavioral of Sensor is 



Signal cuenta: unsigned (16 downto 0) :=(others =>'0');
Signal centimetros: unsigned (15 downto 0):=(others =>'0');
Signal Centimetros_unid: unsigned (3 downto 0) :=(others =>'0');
Signal centimetros_dece: unsigned ( 3 downto 0):= (others =>'0');
Signal sal_unid: unsigned (3 downto 0) :=(others =>'0');
Signal sal_dece: unsigned (3 downto 0) :=(others =>'0');
Signal digito: unsigned (3 downto 0):= (others =>'0');
Signal digito2: unsigned (3 downto 0) :=(others =>'0');
Signal eco_pasado: std_logic := '0';
Signal eco_sinc: std_logic :='0';
Signal eco_nsinc: std_logic:='0';
Signal espera: std_logic:='0';
Signal numeros: unsigned (15 downto 0) :=(others =>'0');
Signal unidades1: std_logic_vector(3 downto 0);
Signal decenas1: std_logic_vector(3 downto 0);


begin 
	
	numero:process(clk)
	begin
		if rising_edge(clk) then 
			if numeros(numeros'high)='1' then
				digito<=sal_unid;
			else 
				digito2<=sal_dece;
			end if;
			numeros<=numeros+1;
		end if;
	end process;
	

	Trigger: process(clk)
	begin 
		if rising_edge (clk) then 
			if espera='0' then 
				if cuenta=500 then 
					sensor_disp<='0';
					espera<='1';
					cuenta<=(others=>'0');
				else 
					sensor_disp<='1';
					cuenta<=cuenta+1;
				end if;
				

				elsif eco_pasado ='0' and eco_sinc='1' then 
					cuenta<=(others => '0');
					centimetros<=(others => '0');
					centimetros_unid <=(others => '0');
					centimetros_dece<=(others => '0');
					
				elsif eco_pasado ='1' and eco_sinc ='0' then 
					sal_unid<= centimetros_unid;
					sal_dece<= centimetros_dece;
					
					unidades1 <= conv_STD_LOGIC_VECTOR(sal_unid,4);
					decenas1 <= conv_STD_LOGIC_VECTOR(sal_dece,4);
					
				elsif cuenta=2900-1 then 
					if centimetros_unid =9 then 
						centimetros_unid <=(others=>'0');
						centimetros_dece<=centimetros_dece+1;
					else 
						centimetros_unid<=centimetros_unid+1;
					end if;
					
					centimetros<=centimetros+1;
					cuenta<=(others=>'0');
					if centimetros=400 then 
						espera<='0';
					end if;
					
					else 
						cuenta<=cuenta+1;
				end if;
					eco_pasado<=eco_sinc;
					eco_sinc<=eco_nsinc;
					eco_nsinc<=sensor_eco;
			end if;
				if (decenas1="0001" and unidades1 <="0101") or (decenas1 ="0000" and unidades1 <= "1001") then
					aviso4 <= "0010010"; --S
					aviso3 <= "0000111"; --T
					aviso2 <= "1000000"; --O
					aviso1 <= "0001100"; --P
				else
					aviso1 <= "1111111";
					aviso2 <= "1111111";
					aviso3 <= "1111111";
					aviso4 <= "1111111";
				end if;
			
		end process;
	
Unidades:process(digito)
	begin
		case digito is 
			when "0000"=>display_uni<="1000000";--0
			when "0001"=>display_uni<="1111001";--1
			when "0010"=>display_uni<="0100100";--2
			when "0011"=>display_uni<="0110000";--3
			when "0100"=>display_uni<="0011001";--4
			when "0101"=>display_uni<="0010010";--5
			when "0110"=>display_uni<="0000010";--6
			when "0111"=>display_uni<="1111000";--7
			when "1000"=>display_uni<="0000000";--8
			when "1001"=>display_uni<="0011000";--9
			when others=>display_uni<="1111111";
		end case;
	end process;

Decenas:process(digito2)
	begin
		case digito2 is 
			when "0000"=>display_dec<="1000000";
			when "0001"=>display_dec<="1111001";
			when "0010"=>display_dec<="0100100";
			when "0011"=>display_dec<="0110000";
			when "0100"=>display_dec<="0011001";
			when "0101"=>display_dec<="0010010";
			when "0110"=>display_dec<="0000010";
			when "0111"=>display_dec<="1111000";
			when "1000"=>display_dec<="0000000";
			when "1001"=>display_dec<="0011000";
			when others=>display_dec<="1111111";
		end case;
	end process;
	end behavioral;	
