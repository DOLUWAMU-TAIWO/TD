library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        keypad_input : in std_logic_vector(3 downto 0);  -- Input from the keypad
        clk : in std_logic;                             -- Clock signal
        reset : in std_logic;                           -- Reset signal
        running_state : in std_logic;                    -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                   -- Signal indicating if any key is pressed
        nokey : out std_logic;                          -- Signal indicating no key is pressed
        s : out bit;                              -- Signal to set the latch
        r : out bit                              -- Signal to reset the latch
    );
end entity comparator;

architecture behavioral of comparator is
    signal password : std_logic_vector(3 downto 0) := "1000";  -- Set password to "1000" (binary)
begin
    process (clk, reset, AnyKeyPressed)
    begin
        if reset = '1' then
            s <= '0';
            r <= '0';
            nokey <= '0';
        elsif rising_edge(clk) then
            if AnyKeyPressed = '0' then
                nokey <= '1';   -- Set nokey to '1' if no key is pressed
                s <= '0';
                r <= '0';
            elsif running_state = '1' then
                nokey <= '0';
                if std_logic_vector(keypad_input) = password then
                    s <= '1';   -- Set s to '1' if the keypad input matches the password
                    r <= '0';
                else
                    s <= '0';
                    r <= '1';   -- Set r to '1' if the keypad input does not match the password
                end if;
            else
                nokey <= '0';
                s <= '0';
                r <= '0';   -- No operation when not in the running state
            end if;
        end if;
    end process;
end architecture behavioral;
