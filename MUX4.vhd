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

ENTITY MUX4 IS
	PORT(
		CTRL :					IN			STD_LOGIC_VECTOR(1 downto 0);	
		IN_A :					IN 			STD_LOGIC_VECTOR(7 DOWNTO 0);
		IN_B :					IN 			STD_LOGIC_VECTOR(7 DOWNTO 0);
		IN_C :					IN 			STD_LOGIC_VECTOR(7 DOWNTO 0);
		IN_D :					IN 			STD_LOGIC_VECTOR(7 DOWNTO 0);
		OUT_A :					OUT 		STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END MUX4;

ARCHITECTURE ARC_MUX4 OF MUX4 IS

BEGIN
	case CTRL is
		when "00" =>
			OUT_A <= IN_A
		when "01" =>
			OUT_A <= IN_B
		when "10" =>
			OUT_A <= IN_C
		when "11" =>
			OUT_A <= IN_D

END ARC_MUX4;

