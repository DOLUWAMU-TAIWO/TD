library ieee;
use ieee.std_logic_1164.all;

entity Latch is
    port (
        Clk : in std_logic;
        Set : in std_logic;
        Reset : in std_logic;
        D : in std_logic;
        Q : out std_logic
    );
end entity Latch;

architecture Behavioral of Latch is
    signal internal_q : std_logic;
begin
    process (Clk)
    begin
        if Reset = '1' then
            internal_q <= '0';  -- Reset the latch to '0' when Reset is asserted
        elsif rising_edge(Clk) then
            if Set = '1' then
                internal_q <= '1';  -- Set the latch to '1' when Set is asserted
            else
                internal_q <= D;    -- Hold the previous value of the latch when neither Set nor Reset is asserted
            end if;
        end if;
    end process;

    Q <= internal_q;
end architecture Behavioral;
