--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 12

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

Entity lcd_example is
 Port(clk, rst : in std_logic; --Reloj del sistema
 rw, rs, e : out std_logic; --read/write, setup/data, y enable para el lcd
 lcd_data : out std_logic_vector(7 downto 0)); --Señales de datos para el lcd
end lcd_example;

Architecture behavior of lcd_example is
 Signal lcd_enable : std_logic;
 Signal lcd_bus : std_logic_vector(9 downto 0);
 Signal lcd_busy : std_logic;
 
 Component lcd_controller is
 Port(clk : in std_logic;
	reset_n : in std_logic;
	lcd_enable : in std_logic;
	lcd_bus : in std_logic_vector(9 downto 0);
	busy : out std_logic;
	rw, rs, e : out std_logic;
	lcd_data : out std_logic_vector(7 downto 0));
 end Component;

 Begin
 dut: lcd_controller
 Port map(clk => clk, reset_n => rst, lcd_enable => lcd_enable, lcd_bus => lcd_bus,
	busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);

 Process(clk)
 VARIABLE char : integer range 0 to 13 := 0;
 Begin
 If (clk'event and clk = '1') then
	 If (lcd_busy = '0' AND lcd_enable = '0') then
		 lcd_enable <= '1';
		 If (char < 13) then
			char := char + 1;
		 End If;
		 Case char IS
			 When 1 => lcd_bus <= "1001011001";
			 When 2 => lcd_bus <= "1001100001";
			 When 3 => lcd_bus <= "1000100000";
			 When 4 => lcd_bus <= "1001110000";
			 When 5 => lcd_bus <= "1011100001";
			 When 6 => lcd_bus <= "1001110011";
			 When 7 => lcd_bus <= "1001100101";
			 When 8 => lcd_bus <= "1001101101";
			 When 9 => lcd_bus <= "1001100101";
			 When 10 => lcd_bus <= "1000111010";
			 When 11 => lcd_bus <= "1000101001";
			 When others => lcd_enable <= '0';
			 End Case;
		 else
		lcd_enable <= '0';
	 End If;
 End If;
 End Process;

End behavior;
