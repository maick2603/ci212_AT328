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
--  Date :    	29/06/2015 - 20:31
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY REG IS
	PORT(
		clk         : in  std_logic;
        reset 		: in std_logic;
        addr_opa    : in  std_logic_vector (4 downto 0);
        addr_opb    : in  std_logic_vector (4 downto 0);
        S_regfile 	: in  std_logic;
        data_opa    : out std_logic_vector (7 downto 0);
        data_opb    : out std_logic_vector (7 downto 0);
        index_z     : out std_logic_vector (15 downto 0);
        data_in     : in  std_logic_vector (7 downto 0);
	);
END REG;

ARCHITECTURE ARC_REG OF REG IS
	
	TYPE 	STD_REG IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	REG_1	: STD_REG;
	SIGNAL  SREG_REG: STD_LOGIC_VECTOR(7 downto 0)
	
BEGIN	
	PROCESS(CLK, RESET)
		BEGIN
			if clk'event and clk = '1' then     -- rising clock edge
	      		if reset = '1' then
	        		REG_1 <= (others => "00000000");
	      		else
	        		if S_regfile = '1' then
	            		REG_1(to_integer(unsigned(addr_opa))) <= data_in;
	        		end if;
	      		end if;
	    	end if;
	END PROCESS;
 	data_opa <= REG_1(to_integer(unsigned(addr_opa)));
  	data_opb <= REG_1(to_integer(unsigned(addr_opb)));
  	index_z  <= REG_1(31) & REG_1(30); -- concatena os hi and lo do Index z
END ARC_REG;


