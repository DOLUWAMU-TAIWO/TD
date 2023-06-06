library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DisplayController is
    Port ( 
        clk         : in  std_logic;                     -- Clock signal
        correct     : in  bit;                            -- Signal representing correct input
        wrong       : in  bit;                            -- Signal representing wrong input
        reset       : in  std_logic;                      -- Reset signal
        idle_state  : in std_logic;                       -- Signal representing idle state
        nokey       : in std_logic;                        -- Signal representing no key pressed
        anode       : out std_logic_vector(7 downto 0);   -- Controls the display digits
        segOut      : out std_logic_vector(6 downto 0);   -- Seven-segment display output
        buzzer  : out std_logic;                      -- Buzzer output for main code
        buzzergreen : out std_logic;
        buzzerblue   : out std_logic 
                             -- Buzzer output for "no key" condition
    );
end DisplayController;

architecture Behavioral of DisplayController is
    signal currentDisplay : std_logic_vector(6 downto 0) := "1000000";  -- Initialize with value for zero
    signal buzzerStateMain : std_logic := '0';                       -- Initialize main buzzer state to off
    signal buzzerStateblue : std_logic :=  '0';                        -- Initialize "no key" buzzer state to off
    signal buzzerstategreen: std_logic := '0';
begin
    -- Only display the leftmost digit
    anode <= "11111110";

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                currentDisplay <= "1000000";   -- Set to value for zero when reset is active
                buzzerStateMain <= '0';            -- Turn off the main buzzer when reset is active
                buzzerStateblue <= '0';             -- Turn off the "no key" buzzer when reset is active
                 buzzerstategreen <= '0' ; 
            else
                if idle_state = '1' then
                    currentDisplay <= "1000000";   -- Set to value for "1" when in idle state
                    buzzerStateMain <= '0';            -- Turn off the main buzzer when in idle state
                    buzzerStateblue <= '0';             -- Turn off the "no key" buzzer when in idle state
                    buzzerstategreen <= '0' ; 
                elsif nokey = '1' then
                    currentDisplay <= "1000000";   -- Set to value for "0" when no key is pressed
                    buzzerStateMain <= '0';            -- Turn off the main buzzer for "no key" condition
                    buzzerStateblue <= '1';             -- Turn on the "no key" buzzer
                     buzzerstategreen <= '0' ; 
                elsif correct = '1' and wrong = '0' then
                    currentDisplay <= "1000110";   -- Set to value for "C" for correct input
                    buzzerStateMain <= '0';            -- Turn off the main buzzer when the password is correct
                    buzzerStateblue <= '0';             -- Turn off the "no key" buzzer when the password is correct
                    buzzerstategreen <= '1' ;           --turn on green led for correct
                elsif correct = '0' and wrong = '1' then
                    currentDisplay <= "0001110";   -- Set to value for "F" for wrong input
                    buzzerStateMain <= '1';            -- Turn on the main buzzer when the password is wrong
                    buzzerStateblue <= '0';             -- Turn off the "no key" buzzer when the password is wrong
                     buzzerstategreen <= '0' ; 
                else
                    currentDisplay <= "1111111";   -- Set to value for no display when both correct and wrong are active or inactive
                    buzzerStateMain <= '0';            -- Turn off the main buzzer when no input is provided
                    buzzerStateblue <= '0';             -- Turn off the "no key" buzzer when no input is provided
                     buzzerstategreen <= '0' ; 
                end if;
            end if;
        end if;
    end process;

    segOut <= currentDisplay;       -- Assign the current display value to segOut
    buzzer <= buzzerStateMain;  -- Assign the current main buzzer state to the buzzerMain output
    buzzerblue <= buzzerStateblue;    -- Assign the current "no key" buzzer state to the buzzerRed output
    buzzergreen <= buzzerstategreen; -- 

end Behavioral;
