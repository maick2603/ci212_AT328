-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--  Complete implementation of Patterson and Hennessy single cycle MIPS processor
--  Copyright (C) 2015  Darci Luiz Tomasi Junior
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, version 3.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--  Engineer: 	Darci Luiz Tomasi Junior
--	 E-mail: 	dltj007@gmail.com
--  Date :    	08/07/2015 - 20:07
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MEM IS
	port(clk        : in  std_logic;
       reset : in std_logic;
       data_out   : out std_logic_vector (7 downto 0);

       -- Memory
       S_memory : in  std_logic_vector(3 downto 0);
       data_in    : in  std_logic_vector(7 downto 0);
       addr       : in std_logic_vector (9 downto 0)

       );
END MEM;

ARCHITECTURE ARC_MEM OF MEM IS
	TYPE 		RAM_TYPE IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	RAM: RAM_TYPE;
	SIGNAL 	ADRESS :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN
	PROCESS(CLK)
		BEGIN
			IF RESET = '1' THEN
				RAM <= (OTHERS => "00000000");
			ELSIF CLK'EVENT AND CLK = '1' THEN
				IF S_memory = "0001" THEN --verificar escrita na memoria
					RAM(TO_INTEGER (UNSIGNED(addr))) <= data_in;
				END IF;
			END IF;
	END PROCESS;	
	data_out <=	RAM(TO_INTEGER(UNSIGNED(addr)));
END ARC_MEM;

