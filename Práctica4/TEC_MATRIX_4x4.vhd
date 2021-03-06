--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 04
--Actividades Complementaria

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_unsigned.all;

entity TEC_MATRIX_4x4 is
	Generic (FREQ_CLK: integer := 50_000_00);
	Port( CLK: IN STD_LOGIC;
		COLUMNAS: in std_logic_vector(3 downto 0);
		FILAS: out std_logic_vector(3 downto 0);
		BOTON_PRES: buffer std_logic_vector (3 downto 0);
		IND: out std_logic;
		dsp0,dsp1,dsp2,dsp3,swap,tmp : buffer STD_LOGIC_VECTOR(6 downto 0)
		);
end TEC_MATRIX_4x4;

architecture bhv of TEC_MATRIX_4x4 is

--DEMORAS
CONSTANT DELAY_1MS : INTEGER := (FREQ_CLK/1000)-1;
CONSTANT DELAY_10MS : INTEGER := (FREQ_CLK/100)-1;

SIGNAL CONTA_1MS: INTEGER RANGE 0 TO DELAY_1MS := 0;
SIGNAL BANDERA: STD_LOGIC := '0';
SIGNAL CONTA_10MS: INTEGER RANGE 0 TO DELAY_10MS := 0;
SIGNAL BANDERA2 : STD_LOGIC := '0';
 
SIGNAL CONTADOR: INTEGER RANGE 0 TO 4 := 0;

--REGISTRO DE 8 BITS PARA CADA BOTON
SIGNAL BOT_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_9 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_A : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_B : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_C : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_D : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_0 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_AS : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
SIGNAL BOT_GA : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');


--SEÑAL PARA LAS FILAS Y EL CONTEO
SIGNAL FILA_REG_S : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS=>'0');
SIGNAL FILA : INTEGER RANGE 0 TO 3 := 0;

--SEÑALES QUE INDICAN QUE SE APRETO UN BOTON
SIGNAL IND_S : STD_LOGIC := '0';
SIGNAL EDO : INTEGER RANGE 0 TO 1 := 0;




BEGIN

FILAS <= FILA_REG_S;
--RETARDO 1 MS (PARA LAS COLUMNAS LLENADO DE REGISTROS)--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		CONTA_1MS <= CONTA_1MS+1;
		BANDERA <= '0';
		IF CONTA_1MS = DELAY_1MS THEN
			CONTA_1MS <= 0;
			BANDERA <= '1';
		END IF;
	END IF;
END PROCESS;

----------------
--RETARDO 10 MS (PARA ACTIVAR LOS RENGLONES)--
PROCESS(CLK)
BEGIN
IF RISING_EDGE(CLK) THEN
	CONTA_10MS <= CONTA_10MS+1;
	BANDERA2 <= '0';
		IF CONTA_10MS = DELAY_10MS THEN
			CONTA_10MS <= 0;
			BANDERA2 <= '1';
		END IF;
	END IF;
END PROCESS;
----------------

--PROCESO EN LAS FILAS ----
PROCESS(CLK, BANDERA2)
BEGIN
	IF RISING_EDGE(CLK) AND BANDERA2 = '1' THEN
		FILA <= FILA+1;
		IF FILA = 3 THEN
			FILA <= 0;
		END IF;
	END IF;
END PROCESS;

WITH FILA SELECT
	FILA_REG_S <= "1000" WHEN 0,
					"0100" WHEN 1,
					"0010" WHEN 2,
					"0001" WHEN OTHERS;
-------------------------------

----------PROCESO EN EL TECLADO AL SELECCIONAR UN VALOR------------
PROCESS(CLK,BANDERA)
BEGIN
	IF RISING_EDGE(CLK) AND BANDERA = '1' THEN
		IF FILA_REG_S = "1000" THEN
			BOT_1 <= BOT_1(6 DOWNTO 0)&COLUMNAS(3);
			BOT_2 <= BOT_2(6 DOWNTO 0)&COLUMNAS(2);
			BOT_3 <= BOT_3(6 DOWNTO 0)&COLUMNAS(1);
			BOT_A <= BOT_A(6 DOWNTO 0)&COLUMNAS(0);
		ELSIF FILA_REG_S = "0100" THEN
			BOT_4 <= BOT_4(6 DOWNTO 0)&COLUMNAS(3);
			BOT_5 <= BOT_5(6 DOWNTO 0)&COLUMNAS(2);
			BOT_6 <= BOT_6(6 DOWNTO 0)&COLUMNAS(1);
			BOT_B <= BOT_B(6 DOWNTO 0)&COLUMNAS(0);
		ELSIF FILA_REG_S = "0010" THEN
			BOT_7 <= BOT_7(6 DOWNTO 0)&COLUMNAS(3);
			BOT_8 <= BOT_8(6 DOWNTO 0)&COLUMNAS(2);
			BOT_9 <= BOT_9(6 DOWNTO 0)&COLUMNAS(1);
			BOT_C <= BOT_C(6 DOWNTO 0)&COLUMNAS(0);
		ELSIF FILA_REG_S = "0001" THEN
			BOT_AS <= BOT_AS(6 DOWNTO 0)&COLUMNAS(3);
			BOT_0 <= BOT_0(6 DOWNTO 0)&COLUMNAS(2);
			BOT_GA <= BOT_GA(6 DOWNTO 0)&COLUMNAS(1);
			BOT_D <= BOT_D(6 DOWNTO 0)&COLUMNAS(0);
		END IF;
	END IF;
END PROCESS;
----------------------------------------------------------------------------
--SALIDA--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
			IF BOT_0 = "11111111" THEN BOTON_PRES <= "0000"; IND_S <= '1';
		ELSIF BOT_1 = "11111111" THEN BOTON_PRES <= "1000"; IND_S <= '1';
		ELSIF BOT_2 = "11111111" THEN BOTON_PRES <= "0100"; IND_S <= '1';
		ELSIF BOT_3 = "11111111" THEN BOTON_PRES <= "1100"; IND_S <= '1';
		ELSIF BOT_4 = "11111111" THEN BOTON_PRES <= "0010"; IND_S <= '1';
		ELSIF BOT_5 = "11111111" THEN BOTON_PRES <= "1010"; IND_S <= '1';
		ELSIF BOT_6 = "11111111" THEN BOTON_PRES <= "0110"; IND_S <= '1';
		ELSIF BOT_7 = "11111111" THEN BOTON_PRES <= "1110"; IND_S <= '1';
		ELSIF BOT_8 = "11111111" THEN BOTON_PRES <= "0001"; IND_S <= '1';
		ELSIF BOT_9 = "11111111" THEN BOTON_PRES <= "1001"; IND_S <= '1';
		ELSIF BOT_A = "11111111" THEN BOTON_PRES <= "0101"; IND_S <= '1';
		ELSIF BOT_B = "11111111" THEN BOTON_PRES <= "1101"; IND_S <= '1';
		ELSIF BOT_C = "11111111" THEN BOTON_PRES <= "0011"; IND_S <= '1';
		ELSIF BOT_D = "11111111" THEN BOTON_PRES <= "1011"; IND_S <= '1';
		ELSIF BOT_AS = "11111111" THEN BOTON_PRES <= "0111"; IND_S <= '1';
		ELSIF BOT_GA = "11111111" THEN BOTON_PRES <= "1111"; IND_S <= '1';
		ELSE IND_S <= '0';
		END IF;
	END IF;
END PROCESS;
-----------------------------
--ACTIVACIÓN PARA LA BANDERA UN CICLO DE RELOJ (INDICACIÓN DE QUE SE PRESIONA UN BOTON)--
PROCESS(CLK)
BEGIN
	IF RISING_EDGE(CLK) THEN
		IF EDO = 0 THEN
			IF IND_S = '1' THEN
				IND <= '1';
				EDO <= 1;
			ELSE
				EDO <= 0;
				IND <= '0';
			END IF;
		ELSE
			IF IND_S = '1' THEN
				EDO <= 1;
				IND <= '0';
			ELSE
				EDO <= 0;
			END IF;
		END IF;
	END IF;

END PROCESS;
--------------------------------------

-----------------------------
--REPRESENTACIÓN DE BOTON A DISPLAY--
WITH BOTON_PRES SELECT
	tmp <= 	"1000000" WHEN "0000", 
				"1111001" WHEN "1000", 
				"0100100" WHEN "0100", 
				"0110000" WHEN "1100", 
				"0011001" WHEN "0010", 
				"0010010" WHEN "1010", 
				"0000010" WHEN "0110", 
				"1111000" WHEN "1110", 
				"0000000" WHEN "0001", 
				"0011000" WHEN "1001", 
				"0100000" WHEN "0101", 
				"0000011" WHEN "1101", 
				"1000110" WHEN "0011", 
				"0100001" WHEN "1011", 
				"0111001" WHEN "0111", 
				"0001001" WHEN "1111", 
				"1111111" WHEN OTHERS;



	corrimiento: process(clk) 
		begin 

		if rising_edge(clk) then
			IF (CONTADOR = 0) THEN
				dsp3 <= "1111111";
				dsp2 <= "1111111";
				dsp1 <= "1111111";
				dsp0 <= tmp;
				CONTADOR <= CONTADOR+1;
			elsif (CONTADOR = 1) then
				dsp3 <= "1111111";
				dsp2 <= "1111111";
				dsp1 <= dsp0;
				dsp0 <= tmp;
				CONTADOR <= CONTADOR+1;
			elsif (CONTADOR = 2) then
				dsp3 <= "1111111";
				dsp2 <= dsp1;
				dsp1 <= dsp0;
				dsp0 <= tmp;
				CONTADOR <= CONTADOR+1;
			elsif (CONTADOR = 3) THEN
				dsp3 <= dsp2;
				dsp2 <= dsp1;
				dsp1 <= dsp0;
				dsp0 <= tmp;
				CONTADOR <= CONTADOR+1;
			elsif(contador = 4) then
				CONTADOR <= 0;
			END IF;
		end if;
	end process;
	
END bhv;
