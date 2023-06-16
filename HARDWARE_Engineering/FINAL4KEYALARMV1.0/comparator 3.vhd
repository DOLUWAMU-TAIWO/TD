library ieee;
use ieee.std_logic_1164.all;

entity comparator3 is
    port (
        thirdKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the third key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match3comp : out std_logic;                          -- Signal indicating a match with the third password
        nokey : out std_logic;                               -- Signal indicating no key is pressed
        comp3Complete : out std_logic                        -- Signal indicating completion of the comparison process for comp3
    );
end entity comparator3;

architecture behavioral of comparator3 is
    signal password : std_logic_vector(3 downto 0) := "0010";  -- Set password to "0010" (binary)
begin
    process (clk, reset, thirdKeyPressed, running_state, AnyKeyPressed)
    begin
        if reset = '1' then
            nokey <= '0';
            match3comp <= '0';
            comp3Complete <= '0';
        elsif rising_edge(clk) then
            if AnyKeyPressed = '0' then
                nokey <= '1';   -- Set nokey to '1' if no key is pressed
                match3comp <= '0';
                comp3Complete <= '0';
            elsif running_state = '1' then
                nokey <= '0';
                if thirdKeyPressed = password then
                    match3comp <= '1';   -- Set match3comp to '1' if the thirdKeyPressed matches the password
                else
                    match3comp <= '0';   -- Set match3comp to '0' if the thirdKeyPressed does not match the password
                end if;
                comp3Complete <= '1';  -- Set comp3Complete to '1' to indicate completion of the comparison process for comp3
            else
                nokey <= '0';
                match3comp <= '0';   -- No operation when not in the running state
                comp3Complete <= '0';  -- Set comp3Complete to '0' as the process for comp3 is not complete
            end if;
        end if;
    end process;
end architecture behavioral;
