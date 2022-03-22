--Alexi Uriel Cabrera Mayoral
--Diseño Digital VLSI
--Practica 05
--Actividades Complementarias

Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

entity angle is
	port( Deg: std_logic_vector(7 downto 0);
		disp1,disp2,disp3: out std_logic_vector(6 downto 0));
	end entity;
	

architecture behavioral of angle is

begin
	process(Deg)
	begin
	if (Deg = X"03" and Deg <= X"05") then
		disp3<="1000000";--0
		disp2<="1000000";--0
		disp1<="1000000";--0
	
	elsif (Deg > X"05" and Deg <= X"07") then
		disp3<="1000000";--0
		disp2<="1111001";--1
		disp1<="0010010";--5

	elsif (Deg > X"07" and Deg <= X"09") then
		disp3<="1000000";--0
		disp2<="0110000";--3
		disp1<="1000000";--0

	elsif (Deg > X"09" and Deg <= X"0B") then
		disp3<="1000000";--0
		disp2<="0011001";--4
		disp1<="0010010";--5

	elsif (Deg > X"0B" and Deg <= X"0D") then
		disp3<="1000000";--0
		disp2<="0000010";--6
		disp1<="1000000";--0

	elsif (Deg > X"0D" and Deg <= X"0F") then
		disp3<="1000000";--0
		disp2<="1111000";--7
		disp1<="0010010";--5

	elsif (Deg > X"0F" and Deg <= X"11") then
		disp3<="1000000";--0
		disp2<="0011000";--9
		disp1<="1000000";--0

	elsif (Deg > X"11" and Deg <= X"13") then
		disp3<="1111001";--1
		disp2<="1000000";--0
		disp1<="0010010";--5
		
	elsif (Deg > X"13" and Deg <= X"15") then
		disp3<="1111001";--1
		disp2<="0100100";--2
		disp1<="1000000";--0

	elsif (Deg > X"15" and Deg <= X"17") then
		disp3<="1111001";--1
		disp2<="0110000";--3
		disp1<="0010010";--5

	elsif (Deg > X"17" and Deg <= X"19") then
		disp3<="1111001";--1
		disp2<="0010010";--5
		disp1<="1000000";--0

	elsif (Deg > X"19" and Deg < X"1B") then
		disp3<="1111001";--1
		disp2<="0000010";--6
		disp1<="0010010";--5

	elsif (Deg > X"1B" and Deg < X"1D") then
		disp3<="1111001";--1
		disp2<="0000000";--8
		disp1<="1000000";--0

	end if;
end process;
	
end architecture;