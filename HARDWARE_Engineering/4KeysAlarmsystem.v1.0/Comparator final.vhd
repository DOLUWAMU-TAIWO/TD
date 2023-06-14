library ieee;
use ieee.std_logic_1164.all;

entity comparator_final is
    port (
        comp1Complete : in std_logic;
        comp2Complete : in std_logic;
        comp3Complete : in std_logic;
        comp4Complete : in std_logic;
        match1comp : in std_logic;                           -- Signal indicating a match with the first password
        match2comp : in std_logic;                           -- Signal indicating a match with the second password
        match3comp : in std_logic;                           -- Signal indicating a match with the third password
        match4comp : in std_logic;                           -- Signal indicating a match with the fourth password
        clk : in std_logic;                                  -- Clock signal
        reset : in std_logic;                                -- Reset signal
        running_state : in std_logic;                         -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                         -- Signal indicating if any key is pressed
        s : out std_logic;                                   -- Signal indicating a successful comparison of the passwords
        r : out std_logic;                                   -- Signal indicating a failed comparison of the passwords
        processComplete : out std_logic                      -- Signal indicating completion of the process
    );
end entity comparator_final;

architecture behavioral of comparator_final is
begin
    process (clk, reset, running_state, match1comp, match2comp, match3comp, match4comp, AnyKeyPressed)
    begin
        if reset = '1' then
            s <= '0';
            r <= '0';
            processComplete <= '0';
        elsif rising_edge(clk) then
            if running_state = '1' and AnyKeyPressed = '1' then
                if comp1Complete = '1' and comp2Complete = '1' and comp3Complete = '1' and comp4Complete = '1' then
                    if match1comp = '1' and match2comp = '1' and match3comp = '1' and match4comp = '1' then
                        s <= '1';          -- Set s to '1' if all match signals are '1'
                        r <= '0';
                        processComplete <= '1';   -- Set processComplete to '1' to indicate completion of the process
                    else
                        s <= '0';
                        r <= '1';            -- Set r to '1' if any of the match signals is '0'
                        processComplete <= '1';  -- Set processComplete to '1' to indicate completion of the process
                    end if;
                else
                    s <= '0';
                    r <= '0';
                    processComplete <= '0';  -- Set processComplete to '0' if any of the comparison processes is not complete
                end if;
            else
                s <= '0';
                r <= '0';
                processComplete <= '0';  -- No operation when not in the running state or no key pressed
            end if;
        end if;
    end process;
end architecture behavioral;
