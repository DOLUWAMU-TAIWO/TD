library ieee;
use ieee.std_logic_1164.all;

entity comparator4 is
    port (
        fourthKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the fourth key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match4comp : out std_logic;                          -- Signal indicating a match with the fourth password
        nokey : out std_logic;                              -- Signal indicating no key is pressed
        comp4Complete : out std_logic                        -- Signal indicating completion of the comparison process for comp4
    );
end entity comparator4;

architecture behavioral of comparator4 is
    signal password : std_logic_vector(3 downto 0) := "0011";  -- Set password to "0011" (binary)
begin
    process (clk, reset, fourthKeyPressed, running_state, AnyKeyPressed)
    begin
        if reset = '1' then
            nokey <= '0';
            match4comp <= '0';
            comp4Complete <= '0';
        elsif rising_edge(clk) then
            if AnyKeyPressed = '0' then
                nokey <= '1';   -- Set nokey to '1' if no key is pressed
                match4comp <= '0';
                comp4Complete <= '0';  -- Set comp4Complete to '1' to indicate completion of the comparison process for comp4
            elsif running_state = '1' then
                nokey <= '0';
                if fourthKeyPressed = password then
                    match4comp <= '1';   -- Set match4comp to '1' if the fourthKeyPressed matches the password
                else
                    match4comp <= '0';   -- Set match4comp to '0' if the fourthKeyPressed does not match the password
                end if;
                comp4Complete <= '1';  -- Set comp4Complete to '1' to indicate completion of the comparison process for comp4
            else
                nokey <= '0';
                match4comp <= '0';   -- No operation when not in the running state
                comp4Complete <= '0';  -- Set comp4Complete to '0' as the process for comp4 is not complete
            end if;
        end if;
    end process;
end architecture behavioral;
