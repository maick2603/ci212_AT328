-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--trabalho CI212 
--PROG_MEMORY
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
library work;
use work.pkg_instrmem.all;

ENTITY PROG_MEMORY IS
	Port ( Addr : in STD_LOGIC_VECTOR (8 downto 0);
           Instr : out STD_LOGIC_VECTOR (15 downto 0));
END PROG_MEMORY;

ARCHITECTURE ARC_INST OF PROG_MEMORY IS
begin
  	Instr <= PROGMEM(to_integer(unsigned(Addr)));	
END ARC_INST;

