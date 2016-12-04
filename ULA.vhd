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
	SIGNAL ERG : 				STD_LOGIC_VECTOR (7 downto 0);
	--regs para as ops.
	SIGNAL DATA_A :				STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DATA_B :				STD_LOGIC_VECTOR(7 DOWNTO 0);
	

begin
	DATA_A <= IN_A;
	DATA_B <= IN_B;			
	process(ULA_CTRL, DATA_RS, DATA_RT)
	ERG <= "00000000"; --zerar resultado 
		begin
			case OPCODE IS
				when "0000" =>
					ERG <= DATA_A + DATA_B; 	--ADD
				when "0001" =>
					ERG <= DATA_A - DATA_B; 	--SUB
				when "0101" =>
					ERG <= DATA_A - "00000001" 	--DEC
			end case;
		end process;
	Z <=not (ERG(7) or ERG(6) or ERG(5) or ERG(4) or ERG(3) or ERG(2) or ERG(1) or ERG(0));
    C <= '0';
    V <= '0';
    N <= ERG(7);


    --flags
    case OPCODE is
      when "0000" =>
        c<=(OPA(7) AND OPB(7)) OR (OPB(7) AND (not erg(7))) OR ((not erg(7)) AND OPA(7));
        v<=(OPA(7) AND OPB(7) AND (not erg(7))) OR ((not OPA(7)) and (not OPB(7)) and  erg(7));
      when "0001" =>
        c<=(not OPA(7) and OPB(7)) or (OPB(7) and erg(7)) or (not OPA(7) and erg(7));
        v<=(OPA(7) and not OPB(7) and not erg(7)) or (not OPA(7) and OPB(7) and erg(7));
      when "0101" =>
        v <= (not OPA(7) and OPA(6) and OPA(5) and OPA(4) and OPA(3) and OPA(2) and OPA(1) and OPA(0));      
      when others => 
      	null;
    end case;


                              
    
	S <= V xor N;
  	RES <= ERG;
  	Status <= '0' & '0' & '0' & S & V & N & Z & C;
END ARC_ULA;


