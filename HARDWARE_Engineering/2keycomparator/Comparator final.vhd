library ieee;
use ieee.std_logic_1164.all;

entity second_comparator is
    port (
        secondKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the second key pressed
        match1comp : in std_logic;                           -- Signal indicating a match with the first password
        clk : in std_logic;                                  -- Clock signal
        reset : in std_logic;                                -- Reset signal
        running_state : in std_logic;                         -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                         -- Signal indicating if any key is pressed
        s : out bit;                                   -- Signal indicating a successful comparison of the second password
        r : out bit;                                   -- Signal indicating a failed comparison of the second password
        processComplete : out std_logic                      -- Signal indicating completion of the process
    );
end entity second_comparator;

architecture behavioral of second_comparator is
    signal password : std_logic_vector(3 downto 0) := "1010";  -- Set password to "1010" (binary)
begin
    process (clk, reset, running_state, secondKeyPressed, match1comp, AnyKeyPressed)
    begin
        if reset = '1' then
            s <= '0';
            r <= '0';
            processComplete <= '0';
        elsif rising_edge(clk) then
            if running_state = '1' and AnyKeyPressed = '1' then
                if match1comp = '1' then
                    if secondKeyPressed = password then
                        s <= '1';          -- Set s to '1' if the secondKeyPressed matches the password
                        r <= '0';
                    else
                        s <= '0';
                        r <= '1';            -- Set r to '1' if the secondKeyPressed does not match the password
                    end if;
                    processComplete <= '1';   -- Set processComplete to '1' to indicate completion of the process
                else
                    s <= '0';
                    r <= '0';
                    processComplete <= '0';  -- No match in the first comparison, no further operation
                end if;
            else
                s <= '0';
                r <= '0';
                processComplete <= '0';  -- No operation when not in the running state or no key pressed
            end if;
        end if;
    end process;
end architecture behavioral;
