-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--trabalho CI212 
--PROG_MEMORY
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--library work;
--use work.pkg_instrmem.all;

ENTITY PROG_MEMORY IS
	Port ( Addr : in STD_LOGIC_VECTOR (8 downto 0);
           Instr : out STD_LOGIC_VECTOR (15 downto 0));
END PROG_MEMORY;

ARCHITECTURE ARC_INST OF PROG_MEMORY IS
type t_instrMem  is array(0 to 511) of std_logic_vector(15 downto 0); -- 512 de mem
	SIGNAL PROGMEM : t_instrMem := (
		"0000110000100001",
		"0000110000110101",
		others => (others => '0')
	);
begin
  	Instr <= PROGMEM(to_integer(unsigned(Addr)));	
END ARC_INST;