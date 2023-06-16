library ieee;
use ieee.std_logic_1164.all;

entity Comparator is
    port (
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        Equal : out std_logic;
        Set : out std_logic;
        Reset : out std_logic;
        Clk : in std_logic;
        Reset_Input : in std_logic
    );
end entity Comparator;

architecture Behavioral of Comparator is
    signal result : std_logic;
begin
    process (Clk, Reset_Input)
    begin
        if Reset_Input = '1' then
            result <= '0';  -- Reset the result to '0' when Reset_Input is asserted
        elsif rising_edge(Clk) then
            if A = B then
                result <= '1';  -- Set the result to '1' if A = B
            else
                result <= '0';  -- Set the result to '0' if A <> B
            end if;
        end if;
    end process;

    Equal <= result;
    Set <= result;
    Reset <= not result;
end architecture Behavioral;

