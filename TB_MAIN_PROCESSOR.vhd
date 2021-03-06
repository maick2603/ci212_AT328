-------------------------------------------------------------------------------
-- Title      : Testbench for design "ALU"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tb_main_processor.vhd
-- Author     : Burkart Voss  <bvoss@Troubadix>
-- Company    : 
-- Created    : 2015-06-23
-- Last update: 2016-11-05
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2015 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2015-06-23  1.0      bvoss Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--library work;
--use work.pkg_processor.all;

-------------------------------------------------------------------------------

entity tb_main_processor is

end tb_main_processor;

-------------------------------------------------------------------------------

architecture testbench of tb_main_processor is

  component ULA
    port (
      OPCODE : in  STD_LOGIC_VECTOR (3 downto 0);
      IN_A    : in  STD_LOGIC_VECTOR (7 downto 0);
      IN_B    : in  STD_LOGIC_VECTOR (7 downto 0);
      RESULT    : out STD_LOGIC_VECTOR (7 downto 0);
      Status : out STD_LOGIC_VECTOR (7 downto 0));
  end component;

  -- component ports
  signal OPCODE : STD_LOGIC_VECTOR (3 downto 0);
  signal IN_A    : STD_LOGIC_VECTOR (7 downto 0);
  signal IN_B    : STD_LOGIC_VECTOR (7 downto 0);
  signal RESULT    : STD_LOGIC_VECTOR (7 downto 0);
  signal Status : STD_LOGIC_VECTOR (7 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- testbench

  -- component instantiation
  DUT: ULA
    port map (
      OPCODE => OPCODE,
      IN_A    => IN_A,
      IN_B    => IN_B,
      RESULT    => RESULT,
      Status => Status);


  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    OPCODE <= "0000";   -- Add
    IN_A <= "00000100";
    IN_B <= "00000011";
    wait for 100 ns;
    OPCODE <= "0001";   -- Sub
    wait for 100 ns;
    OPCODE <= "0010";   -- OR
    wait for 100 ns;
    OPCODE <= "0100";
    wait for 100 ns;
    OPCODE <= "0101";
    wait for 100 ns;
    OPCODE <= "0111";
    wait for 100 ns;
    
  end process WaveGen_Proc;

  

end testbench;

-------------------------------------------------------------------------------

configuration tb_main_processor_testbench_cfg of tb_main_processor is
  for testbench
  end for;
end tb_main_processor_testbench_cfg;

-------------------------------------------------------------------------------
