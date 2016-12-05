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
--  Date :    	01/07/2015 - 22:08 
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MAIN_PROCESSOR IS
	PORT(
		CLK :										IN 			STD_LOGIC;
		RESET :									IN 				STD_LOGIC
	);
END MAIN_PROCESSOR;

ARCHITECTURE ARC_MAIN_PROCESSOR OF MAIN_PROCESSOR IS

	COMPONENT PC IS
		PORT(
			CLK :						IN		STD_LOGIC;
			RESET :						IN		STD_LOGIC;
			OFFSET_PC :					IN 		STD_LOGIC_VECTOR(11 DOWNTO 0);
			ADDR :						OUT		STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT PROG_MEMORY
		PORT(
			Addr  : in  std_logic_vector (8 downto 0);
      		Instr : out std_logic_vector (15 downto 0)
		);
	END COMPONENT;

	COMPONENT DECODER IS
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
	END COMPONENT;

	COMPONENT REG IS
		PORT(
			clk         : in  std_logic;
	        reset 		: in std_logic;
	        addr_opa    : in  std_logic_vector (4 downto 0);
	        addr_opb    : in  std_logic_vector (4 downto 0);
	        S_regfile 	: in  std_logic;
	        data_opa    : out std_logic_vector (7 downto 0);
	        data_opb    : out std_logic_vector (7 downto 0);
	        index_z     : out std_logic_vector (15 downto 0);
	        data_in     : in  std_logic_vector (7 downto 0)
		);
	END COMPONENT;

	COMPONENT ULA IS
		PORT(
			OPCODE:				IN    	STD_LOGIC_VECTOR (3 downto 0); 	--opcode de 4 bits
			IN_A: 				IN  	STD_LOGIC_VECTOR (7 downto 0); 	--reg A			
			IN_B: 				IN  	STD_LOGIC_VECTOR (7 downto 0); 	--reg B		
			RESULT: 			OUT		STD_LOGIC_VECTOR (7 downto 0); 	--A = A OP B
	     	STATUS:		 		OUT  	STD_LOGIC_VECTOR (7 downto 0) 	--status
	    );		
	END COMPONENT;

	COMPONENT DECODER_MEM is
	  	port (
		    index_z : in std_logic_vector(15 downto 0);
		    S_decoder_memory : in std_logic;
		    memory_output_selector : out std_logic_vector (3 downto 0);
		    S_memory : out std_logic_vector(3 downto 0);
		    addr_memory : out std_logic_vector(9 downto 0)
	    );
	END COMPONENT;

	COMPONENT MEM IS
		port(
			clk        : in  std_logic;
	       	reset : in std_logic;
	       	data_out   : out std_logic_vector (7 downto 0);
	       	S_memory : in  std_logic_vector(3 downto 0);
	       	data_in    : in  std_logic_vector(7 downto 0);
	       	addr       : in std_logic_vector (9 downto 0)
	    );
	END COMPONENT;
	
	COMPONENT MUX2 IS
		PORT(
			CTRL :					IN	STD_LOGIC;	
			IN_A :					IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			IN_B :					IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			OUT_A :					OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT MUX4 IS
		PORT(
			CTRL :					IN	STD_LOGIC_VECTOR(1 downto 0);	
			IN_A :					IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
			IN_B :					IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			IN_C :					IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			IN_D :					IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			OUT_A :					OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	--PC
  signal Addr : std_logic_vector (8 downto 0);

  	--PROGRAM_MEM
  signal Instr : std_logic_vector (15 downto 0);

  	--DECODER
  signal addr_opa           	 : std_logic_vector(4 downto 0);
  signal addr_opb           	 : std_logic_vector(4 downto 0);
  signal OPCODE             	 : std_logic_vector(3 downto 0);
  signal w_e_regfile        	 : std_logic;
  signal w_e_decoder_memory 	 : std_logic;
  signal w_e_SREG_dec       	 : std_logic_vector(7 downto 0);
  signal offset_pc          	 : std_logic_vector(11 downto 0);
  signal regfile_datain_selector : std_logic_vector(1 downto 0);
  signal alu_sel_immediate       : std_logic;

  	--REG
  signal data_opa : std_logic_vector (7 downto 0);
  signal data_opb : std_logic_vector (7 downto 0);
  signal sreg     : std_logic_vector(7 downto 0);
  signal index_z  : std_logic_vector(15 downto 0);

  	--ALU
  signal data_res   : std_logic_vector(7 downto 0);
  signal status_alu : std_logic_vector(7 downto 0);

  	--DECODER_MEM
  signal w_e_memory             : std_logic_vector(3 downto 0);
  signal addr_memory            : std_logic_vector(9 downto 0);
  signal memory_output_selector : std_logic_vector(3 downto 0);

  	--MEM
  signal memory_data_out : std_logic_vector(7 downto 0);
  signal memory_output   : std_logic_vector(7 downto 0);


  signal PM_data        : std_logic_vector(7 downto 0);  -- usado para os calculos com Imediatos
  
  signal input_alu_opb  : std_logic_vector(7 downto 0);  -- saida do multiplexador da ULA
                                        
  signal input_data_reg : std_logic_vector(7 downto 0);  -- saida do multiplexador do REG
                                                         
  signal PIPELINE_IF_ID_Instr : std_logic_vector(15 downto 0); --PL IF/ID <= Instr

  --signal PIPELINE_ID_EX_PC : std_logic_vector(11 downto 0); --PL ID/EX <= PC+4
  --signal PIPELINE_ID_EX_Rr : std_logic_vector(7 downto 0); --PL ID/EX <= Rr
  --signal PIPELINE_ID_EX_Rd : std_logic_vector(7 downto 0); --PL ID/EX <= Rd
  
  --signal PIPELINE_EX_MEM_Rd : std_logic_vector(7 downto 0);


BEGIN
	--S_GERAL_OPCode 	<= S_REG_IF_ID_OUT_A(31 DOWNTO 26);
	--S_GERAL_RS 			<= S_REG_IF_ID_OUT_A(25 DOWNTO 21);
	--S_GERAL_RT			<= S_REG_IF_ID_OUT_A(20 DOWNTO 16);
	--S_GERAL_RD 			<= S_REG_IF_ID_OUT_A(15 DOWNTO 11);
	--S_GERAL_I_TYPE 	<= S_REG_IF_ID_OUT_A(15 DOWNTO 0);
	--S_GERAL_FUNCT		<= S_REG_IF_ID_OUT_A(5 DOWNTO 0);
	--S_GERAL_JUMP		<= S_REG_IF_ID_OUT_A(31 DOWNTO 0);
	--S_GERAL_PC_4		<= S_REG_IF_ID_OUT_B(31 DOWNTO 0);

	 C_PC : PC
    port map (
      reset => reset, 
      offset_pc => offset_pc,
      clk => CLK,
      Addr => Addr);

    C_PROG_MEMORY : PROG_MEMORY
    port map (
      --Addr  => PIPELINE_IF_ID_PC, 
      --Instr => PIPELINE_IF_ID_Instr);
      Addr  => Addr, 
      Instr => Instr);

    --PIPELINE_IF_ID_PC <= Addr when rising_edge(clk);
    --PIPELINE_IF_ID_Instr <= Instr;

    C_DECODER : DECODER
    port map (
      Instr                 => Instr,
      sreg                  => sreg,
      addr_opa              => addr_opa,
      addr_opb              => addr_opb,
      OPCODE                => OPCODE,
      offset_pc             => offset_pc,
      S_regfile             => w_e_regfile,
      S_decoder_memory      => w_e_decoder_memory,
      S_SREG                => w_e_SREG_dec,
      sel_alu_immediate     => alu_sel_immediate,
      sel_regfile_datain	=> regfile_datain_selector);

	C_REG : REG
    port map (
      clk         => clk,
      reset       => reset,
      addr_opa    => addr_opa,
      addr_opb    => addr_opb,
      S_regfile   => w_e_regfile,
      data_opa    => data_opa,
      data_opb    => data_opb,
      index_z     => index_z,
      data_in     => input_data_reg);

  -- instance "ALU_1"
  C_ULA : ULA
    port map (
      OPCODE => OPCODE,
      IN_A    => data_opa,
      IN_B    => input_alu_opb,
      RESULT    => data_res,
      STATUS => status_alu);

  -- instance "decoder_memory_1"
  C_DECODER_MEM : DECODER_MEM
    port map (
      index_z                => index_z,
      S_decoder_memory     => w_e_decoder_memory,
      memory_output_selector => memory_output_selector,
      S_memory             => w_e_memory,
      addr_memory            => addr_memory);

  -- instance "data_memory_1"
  C_MEM : MEM
    port map (
      clk        => clk,
      reset      => reset,
      S_memory => w_e_memory,
      data_in    => data_opa,
      addr       => addr_memory,
      data_out   => memory_data_out);

  -- variable from instruction
  PM_Data <= Instr(11 downto 8) & Instr(3 downto 0);

  C_MUX2 : MUX2
  	port map (
  		CTRL => alu_sel_immediate,
  		IN_A => data_opb,
  		IN_B => PM_Data,
  		OUT_A=> input_alu_opb);

  C_MUX4: MUX4
  	port map (
  		CTRL => regfile_datain_selector,
  		IN_A => data_res,
  		IN_B => data_opb,
  		IN_C => memory_data_out,
  		IN_D => PM_Data,
  		OUT_A=> input_data_reg);

  -- SREG
  sreg_process : process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        sreg <= "00000000";
      else
        sreg <= (not(w_e_SREG_dec) and sreg) or (w_e_SREG_dec and status_alu);
      end if;
    end if;
  end process sreg_process;
END ARC_MAIN_PROCESSOR;

