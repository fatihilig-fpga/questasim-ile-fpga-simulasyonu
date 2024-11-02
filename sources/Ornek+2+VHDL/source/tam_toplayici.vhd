library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tam_toplayici is
   port (
      reset          : in std_logic;
      in_giris_elde  : in std_logic;
      in_giris_1     : in std_logic;
      in_giris_2     : in std_logic;
      out_cikis      : out std_logic;
      out_cikis_elde : out std_logic
   );
end tam_toplayici;

architecture behavioral of tam_toplayici is
   signal s_cikis_elde : std_logic;
begin
   process (all) begin
      if (reset = '1') then
         out_cikis      <= '0';
         s_cikis_elde   <= '0';
      else
         out_cikis      <= in_giris_elde xor in_giris_1 xor in_giris_2;
         s_cikis_elde   <= ((in_giris_1 xor in_giris_2) and in_giris_elde)
                           or (in_giris_1 and in_giris_2);
      end if;
   end process;
   out_cikis_elde <= s_cikis_elde;
end behavioral;
