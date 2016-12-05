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
--  Date :    	02/07/2015 - 21:48
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX2 IS
	PORT(
		CTRL :					IN			STD_LOGIC;	
		IN_A :					IN 			STD_LOGIC_VECTOR(7 DOWNTO 0);
		IN_B :					IN 			STD_LOGIC_VECTOR(7 DOWNTO 0);
		OUT_A :					OUT 		STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END MUX2;

ARCHITECTURE ARC_MUX2 OF MUX2 IS

BEGIN
	process
 		constant CASE_B : STD_LOGIC := '1';
 		constant CASE_A : STD_LOGIC := '0';
	begin
		if CTRL = CASE_A then
			OUT_A <= IN_A;
		ELSE
			OUT_A <= IN_B;
		end if;
	end process;
END ARC_MUX2;