library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        firstKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match1comp : out std_logic;                          -- Signal indicating a match with the first password
        nokey : out std_logic                               -- Signal indicating no key is pressed
    );
end entity comparator;

architecture behavioral of comparator is
    signal password : std_logic_vector(3 downto 0) := "1000";  -- Set password to "1000" (binary)
begin
    process (clk, reset, firstKeyPressed, running_state, AnyKeyPressed)
    begin
        if reset = '1' then
            nokey <= '0';
            match1comp <= '0';
        elsif rising_edge(clk) then
            if AnyKeyPressed = '0' then
                nokey <= '1';   -- Set nokey to '1' if no key is pressed
                match1comp <= '0';
            elsif running_state = '1' then
                nokey <= '0';
                if firstKeyPressed = password then
                    match1comp <= '1';   -- Set match1comp to '1' if the firstKeyPressed matches the password
                else
                    match1comp <= '0';   -- Set match1comp to '0' if the firstKeyPressed does not match the password
                end if;
            else
                nokey <= '0';
                match1comp <= '0';   -- No operation when not in the running state
            end if;
        end if;
    end process;
end architecture behavioral;
