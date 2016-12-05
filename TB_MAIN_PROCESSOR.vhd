
library ieee;
use ieee.std_logic_1164.all;
library work;
--use work.pkg_processor.all;

-------------------------------------------------------------------------------

entity TB_MAIN_PROCESSOR is

end TB_MAIN_PROCESSOR;

-------------------------------------------------------------------------------

architecture testbench of TB_MAIN_PROCESSOR is

  component ULA
    port (
      OPCODE : in  STD_LOGIC_VECTOR (3 downto 0);
      IN_A    : in  STD_LOGIC_VECTOR (7 downto 0);
      IN_B   : in  STD_LOGIC_VECTOR (7 downto 0);
      RESULT    : out STD_LOGIC_VECTOR (7 downto 0);
      Status : out STD_LOGIC_VECTOR (7 downto 0));
  end component;

  -- component ports
  signal OPCODE : STD_LOGIC_VECTOR (3 downto 0);
  signal OPA    : STD_LOGIC_VECTOR (7 downto 0);
  signal OPB    : STD_LOGIC_VECTOR (7 downto 0);
  signal RES    : STD_LOGIC_VECTOR (7 downto 0);
  signal Status : STD_LOGIC_VECTOR (7 downto 0);
  constant op_NOP : std_logic_vector(3 downto 0) := "0000";  -- NoOperation (als Addition implementiert, die Ergebnisse
                   -- werden aber nicht gespeichert...
  constant op_sub : std_logic_vector(3 downto 0) := "0001";  -- Subtraction
  constant op_or : std_logic_vector(3 downto 0) := "0010";  -- bitwise OR
  constant op_ldi : std_logic_vector(3 downto 0) := "0011";  -- Load immediate

  constant op_and : std_logic_vector(3 downto 0) := "0100"; -- bitwise AND
  constant op_dec : std_logic_vector(3 downto 0) := "0101"; -- decrement
  constant op_inc : std_logic_vector(3 downto 0) := "0111"; -- increment

  constant op_lsr : std_logic_vector(3 downto 0) := "1000"; -- logical shift right
  constant op_xor : std_logic_vector(3 downto 0) := "1001"; -- bitwise xor
   constant op_add : std_logic_vector(3 downto 0) := "0000";  -- Addition

  -- clock
  signal Clk : std_logic := '1';

begin  -- testbench
  

  -- component instantiation
  DUT: ULA
    port map (
      OPCODE => OPCODE,
      IN_A    => OPA,
      IN_B    => OPB,
      RESULT    => RES,
      Status => Status);


  -- waveform generation
  WaveGen_Proc: process
   
  
  
  begin


    -- insert signal assignments here
    OPCODE <= op_add;   -- Add
    OPA <= "00000100";
    OPB <= "00000011";
    wait for 100 ns;
    OPCODE <= op_sub;   -- Sub
    wait for 100 ns;
    OPCODE <= op_or;   -- OR
    wait for 100 ns;
    OPCODE <= op_and;
    wait for 100 ns;
    OPCODE <= op_dec;
    wait for 100 ns;
    OPCODE <= op_inc;
    wait for 100 ns;
    
  end process WaveGen_Proc;

  

end testbench;
