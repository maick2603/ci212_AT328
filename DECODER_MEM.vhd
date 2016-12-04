library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity DECODER_MEM is
    port (
        index_z : in std_logic_vector(15 downto 0);
        S_decoder_memory : in std_logic;
        memory_output_selector : out std_logic_vector (3 downto 0);
        S_memory : out std_logic_vector(3 downto 0);
        addr_memory : out std_logic_vector(9 downto 0)
    );
end entity DECODER_MEM;

architecture Behavioral of decoder_memory is
begin
  process (index_z, S_decoder_memory)  
  begin
    S_memory <= "0000";
    addr_memory <= "0000000000";
    id_port := "0000";
    if unsigned(index_z) >= unsigned(x"0060")
      and unsigned(index_z) <= unsigned(x"045F") then
            addr_memory <= std_logic_vector(resize(unsigned(index_z) - unsigned(x"0060"),
                                                    addr_memory'length));
            id_port := "0001";
      end if;
    end case;

    memory_output_selector <= id_port;
    if w_e_decoder_memory = '1' then
      w_e_memory <= "0001";
    end if;

  end process;
end Behavioral;
  
