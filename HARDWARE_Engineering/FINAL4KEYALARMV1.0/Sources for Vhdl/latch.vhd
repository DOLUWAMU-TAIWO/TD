library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch is
    port (
        s : in bit;               -- Signal to set the latch
        r : in bit;               -- Signal to reset the latch
        clk : in std_logic;       -- Clock signal
        reset : in std_logic;     -- Reset signal
        latch_active : in std_logic;  -- Signal indicating if the latch process is active
        correct : out bit;        -- Signal representing correct input
        wrong : out bit           -- Signal representing wrong input
    );
end entity latch;

architecture behavioral of latch is
begin
    process (clk, reset, latch_active)
    begin
        if reset = '1' then
            correct <= '0';
            wrong <= '0';
        elsif rising_edge(clk) then
            if latch_active = '1' then
                if (s = '1') and (r = '0') then
                    correct <= '1';     -- Set correct when s = '1' and r = '0'
                    wrong <= '0';       -- Clear wrong
                elsif (s = '0') and (r = '1') then
                    correct <= '0';     -- Clear correct when s = '0' and r = '0'
                    wrong <= '1';       -- Clear wrong
                else
                    correct <= '0';     -- Clear correct for all other cases
                    wrong <= '0';       -- Set wrong
                end if;
            else
                correct <= '0';
                wrong <= '0';
            end if;
        end if;
    end process;
end architecture behavioral;
