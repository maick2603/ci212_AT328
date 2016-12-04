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
--  Date :    	18/06/2015 - 20:12
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY DECODER IS
	PORT(
	Instr  		       : in  std_logic_vector(15 downto 0);   
    sreg               : in  std_logic_vector(7 downto 0);  
    addr_opa           : out std_logic_vector(4 downto 0);  
    addr_opb           : out std_logic_vector(4 downto 0);  
    OPCODE             : out std_logic_vector(3 downto 0);  
    S_decoder_memory   : out std_logic;
    S_regfile          : out std_logic;  
    S_SREG             : out std_logic_vector(7 downto 0);  
    offset_pc          : out std_logic_vector(11 downto 0); 

    sel_regfile_datain : out std_logic_vector(1 downto 0);  
    sel_alu_immediate  : out std_logic   
	);
	
END DECODER;

ARCHITECTURE ARC_DECODER OF DECODER IS

BEGIN

	PROCESS(Instr, sreg)
	 	variable branches : integer := 0;
	BEGIN
		addr_opa 	            <= "00000";
	    addr_opb                <= "00000";
	    OPCODE                  <= "0000";
	    S_regfile             	<= '0';
	    S_SREG                	<= "00000000";
	    sel_regfile_datain		<= "00";
	    sel_alu_immediate       <= '0';
	    offset_pc               <= "000000000000";
	    S_decoder_memory      	<= '0';

    	branches := to_integer(unsigned(Instr(2 downto 0)));

		case Instr(15 downto 10) is    
		    when "000011" => -- ADD: somente soma os dois registradores e coloca o RESULTADO em A
		        addr_opa    <= Instr(8 downto 4);
		        addr_opb    <= Instr(9) & Instr (3 downto 0);
		        OPCODE      <= "0000";
		        S_regfile 	<= '1';
		        S_SREG    	<= "00111111";
		    when "000101" => -- CP : é um sub sem a escrita habilitada
		        addr_opa 	<= Instr(8 downto 4);
		        addr_opb 	<= Instr(9) & Instr (3 downto 0);
		        OPCODE   	<= "0001";
		        S_SREG <= "00111111";
		    when "000110" => -- SUB : subtrai
		        addr_opa    <= Instr(8 downto 4);
		        addr_opb    <= Instr(9) & Instr (3 downto 0);
		        OPCODE   	<= "0001";
		        S_regfile 	<= '1';
		        S_SREG    	<= "00111111";
		    when "001011" => -- MOV
		        addr_opa    <= Instr(8 downto 4);
		        addr_opb    <= Instr(9) & Instr (3 downto 0);
		        w_e_regfile <= '1';
		        regfile_datain_selector <= "01";
		    when others =>
		        case Instr(15 downto 12) is  -- instruções codificadas nos 4 primeiros bits
		          	when "1110" => -- LDI
			            addr_opa                <= '1' & Instr(7 downto 4);
			            S_regfile             	<= '1';
			            S_SREG                	<= "00000000";
			            sel_regfile_datain 	  	<= "11";
		          	when others =>
		            	case Instr(15 downto 9) is   -- instruções codificadas nos 7 primeiros bits
		              		when "1001010" =>
				                case Instr(3 downto 0) is
					                when "1010" =>        -- DEC
					                    addr_opa    <= Instr(8 downto 4);
					                    OPCODE      <= op_dec;
					                    S_regfile <= '1';
					                    S_SREG    <= "00011110";
					                when others =>
					                    null;               
				                end case;
				            when "1000000" => -- LD (index z soomente)
				                addr_opa                <= Instr(8 downto 4);
				                sel_regfile_datain <= "10";
				                S_regfile             <= '1';
				            when others =>
				                null;
		            	end case;
		    	end case;
		end case;
	end process;
END ARC_DECODER;


