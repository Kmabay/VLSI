LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 

Entity Gen25MHz is
	port(clk50Mhz: in std_logic;clk25Mhz: inout std_logic:= '0');
End Entity;

Architecture bhv of Gen25Mhz is
Begin
	Process(clk50Mhz)
	Begin
		if clk50Mhz'event and clk50Mhz='1' then
			clk25Mhz <= not clk25Mhz;
		end if;
	end process;
end bhv;