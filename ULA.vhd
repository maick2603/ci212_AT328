-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--trabalho CI212 
--ULA
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY ULA IS
	PORT(
			OPCODE:				IN    	STD_LOGIC_VECTOR (3 downto 0); 	--opcode de 4 bits
			IN_A: 				IN  	STD_LOGIC_VECTOR (7 downto 0); 	--reg A			
			IN_B: 				IN  	STD_LOGIC_VECTOR (7 downto 0); 	--reg B		
			RESULT: 			OUT		STD_LOGIC_VECTOR (7 downto 0); 	--A = A OP B
         	STATUS:		 		OUT  	STD_LOGIC_VECTOR (7 downto 0)	--status
        ); 			
END ULA;

ARCHITECTURE ARC_ULA OF ULA IS
	--flags
	SIGNAL Z: 					STD_LOGIC :='0'; --zero
	SIGNAL C: 					STD_LOGIC :='0'; --carry 
	SIGNAL V: 					STD_LOGIC :='0'; --overflow
	SIGNAL N: 					STD_LOGIC :='0'; --negative
	SIGNAL S: 					STD_LOGIC :='0'; --sign
	SIGNAL ERG : 				STD_LOGIC_VECTOR (7 downto 0) :="00000000";
	--regs para as ops.
	SIGNAL DATA_A :				STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DATA_B :				STD_LOGIC_VECTOR(7 DOWNTO 0);
	

begin
	DATA_A <= IN_A;
	DATA_B <= IN_B;			
	process
		constant add_opr: STD_LOGIC_VECTOR(3 downto 0):="0000";
		constant sub_opr: STD_LOGIC_VECTOR(3 downto 0):="0001";
		constant dec_opr: STD_LOGIC_VECTOR(3 downto 0):="0101";
		constant ONE_opr: STD_LOGIC_VECTOR(7 downto 0):="00000001";
	begin
		case OPCODE IS
			when add_opr =>
				ERG <= DATA_A + DATA_B; 	--ADD
			when sub_opr =>
				ERG <= DATA_A - DATA_B; 	--SUB
			when dec_opr =>
				ERG <= DATA_A - ONE_opr; 	--DEC
			 when others => 
			 	null;
		end case;
		Z <=not (ERG(7) or ERG(6) or ERG(5) or ERG(4) or ERG(3) or ERG(2) or ERG(1) or ERG(0));
	    C <= '0';
	    V <= '0';
	    N <= ERG(7);

	    case OPCODE IS
			when add_opr =>
		        C<=(DATA_A(7) AND DATA_B(7)) OR (DATA_B(7) AND (not ERG(7))) OR ((not ERG(7)) AND DATA_A(7));
		        V<=(DATA_A(7) AND DATA_B(7) AND (not ERG(7))) OR ((not DATA_A(7)) and (not DATA_B(7)) and  ERG(7));	    
	   		when sub_opr =>
		        C<=(not DATA_A(7) and DATA_B(7)) or (DATA_B(7) and ERG(7)) or (not DATA_A(7) and ERG(7));
		        V<=(DATA_A(7) and not DATA_B(7) and not ERG(7)) or (not DATA_A(7) and DATA_B(7) and ERG(7));
	    	when dec_opr =>
	        	V <= (not DATA_A(7) and DATA_A(6) and DATA_A(5) and DATA_A(4) and DATA_A(3) and DATA_A(2) and DATA_A(1) and DATA_A(0));
		   when others => 
				null;
		end case;
	end process;
	

	S <= V xor N;
  	RESULT <= ERG;
  	Status <= '0' & '0' & '0' & S & V & N & Z & C;
END ARC_ULA;


