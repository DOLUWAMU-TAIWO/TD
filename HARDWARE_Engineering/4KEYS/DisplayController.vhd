library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DisplayController is
    Port ( 
        clk     : in  std_logic;                     -- Clock signal
        correct : in  bit;                            -- Signal representing correct input
        wrong   : in  bit;                            -- Signal representing wrong input
        reset   : in  std_logic;                      -- Reset signal
        idle_state : in std_logic;                    -- Signal representing idle state
        anode   : out std_logic_vector(7 downto 0);   -- Controls the display digits
        segOut  : out std_logic_vector(6 downto 0);   -- Seven-segment display output
        buzzer  : out std_logic                       -- Buzzer output
    );
end DisplayController;

architecture Behavioral of DisplayController is
    signal currentDisplay : std_logic_vector(6 downto 0) := "1000000";  -- Initialize with value for zero
    signal buzzerState    : std_logic := '0';                         -- Initialize buzzer state to off
begin
    -- Only display the leftmost digit
    anode <= "11111110";

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                currentDisplay <= "1000000";   -- Set to value for zero when reset is active
                buzzerState <= '0';            -- Turn off the buzzer when reset is active
            else
                if idle_state = '1' then
                    currentDisplay <= "1000000";   -- Set to value for "1" when in idle state
                    buzzerState <= '0';            -- Turn off the buzzer when in idle state
                elsif correct = '1' and wrong = '0' then
                    currentDisplay <= "1000110";   -- Set to value for "C" for correct input
                    buzzerState <= '0';            -- Turn off the buzzer when the password is correct
                elsif correct = '0' and wrong = '1' then
                    currentDisplay <= "0001110";   -- Set to value for "F" for wrong input
                    buzzerState <= '1';            -- Turn on the buzzer when the password is wrong
                else
                    currentDisplay <= "1111111";   -- Set to value for no display when both correct and wrong are active or inactive
                    buzzerState <= '0';            -- Turn off the buzzer when no input is provided
                end if;
            end if;
        end if;
    end process;

    segOut <= currentDisplay;  -- Assign the current display value to segOut
    buzzer <= buzzerState;     -- Assign the current buzzer state to the buzzer output

end Behavioral;
