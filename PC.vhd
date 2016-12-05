-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--trabalho CI212 
--PC
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY PC IS
	PORT(
		CLK :						IN		STD_LOGIC;
		RESET :						IN		STD_LOGIC;
		OFFSET_PC :					IN 		STD_LOGIC_VECTOR(11 DOWNTO 0);
		ADDR :						OUT		STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END PC;

ARCHITECTURE ARC_PC OF PC IS
	signal PC_reg : std_logic_vector(11 downto 0);
BEGIN
	Process(CLK, RESET)
	Begin
		if clk'event and clk = '1' then     -- rising clock edge
	      	if reset = '1' then               -- synchronous reset (active high)
	        	PC_reg <= "000000000000";
	      	else
	        	PC_reg <= std_logic_vector(unsigned(PC_reg) + unsigned(OFFSET_PC) + 1);
	      	end if;
	    end if;	
	end Process;
	ADDR <= PC_reg(8 downto 0);
END ARC_PC;

