library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch is
    port (
        s : in bit;               -- Signal to set the latch
        r : in bit;               -- Signal to reset the latch
        clk : in std_logic;       -- Clock signal
        reset : in std_logic;     -- Reset signal
        process_complete : in std_logic;  -- Signal indicating keys have been sent
        correct : out bit;        -- Signal representing correct input
        wrong : out bit          -- Signal representing wrong input
    );
end entity latch;

architecture behavioral of latch is
    signal latch_active : std_logic := '0';  -- Signal indicating if the latch process is active
begin
    process (clk, reset, process_complete)
    begin
        if reset = '1' then
            correct <= '0';
            wrong <= '0';
            latch_active <= '0';  -- Reset the latch_active signal
        elsif rising_edge(clk) then
            if process_complete = '1' then
                latch_active <= '1';  -- Set latch_active signal to '1' when process_complete = '1'
            end if;
            
            if latch_active = '1' then
                if (s = '1') and (r = '0') then
                    correct <= '1';     -- Set correct when s = '1' and r = '0'
                    wrong <= '0';       -- Clear wrong
                else
                    correct <= '0';     -- Clear correct for all other cases
                    wrong <= '1';       -- Set wrong
                end if;
            else
                correct <= '0';
                wrong <= '0';
            end if;
        end if;
    end process;
end architecture behavioral;
