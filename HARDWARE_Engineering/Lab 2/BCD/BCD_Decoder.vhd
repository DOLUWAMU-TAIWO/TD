

entity BCD_Decoder is
  port (
    bcd : in bit_vector(3 downto 0);    -- Input BCD value
    segment : out bit_vector(6 downto 0)    -- Output segment pattern
  );
end entity BCD_Decoder;

architecture Behavioral of BCD_Decoder is
begin
  with bcd select
    segment <=
      "1111110" when "0000", -- Display '0'
      "0110000" when "0001", -- Display '1'
      "1101101" when "0010", -- Display '2'
      "1111001" when "0011", -- Display '3'
      "0110011" when "0100", -- Display '4'
      "1011011" when "0101", -- Display '5'
      "1011111" when "0110", -- Display '6'
      "1110000" when "0111", -- Display '7'
      "1111111" when "1000", -- Display '8'
      "1111011" when "1001", -- Display '9'
      "0000000" when others; -- Display 'E' for invalid input
end architecture Behavioral;

