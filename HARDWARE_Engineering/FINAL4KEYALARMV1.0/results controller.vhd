library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_fsm is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        running_state : in std_logic;
        processComplete : in std_logic;
        latchActive : out std_logic
    );
end entity controller_fsm;

architecture behavioral of controller_fsm is
    type state_type is (IDLE, ACTIVE);
    signal current_state, next_state : state_type;
begin
    -- State register process
    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic
    process (current_state, running_state, processComplete)
    begin
        next_state <= current_state;  -- Default next state is the current state
        
        case current_state is
            when IDLE =>
                if running_state = '1' and processComplete = '1' then
                    next_state <= ACTIVE;  -- Transition to ACTIVE state when running and process is complete
                end if;
            when ACTIVE =>
                if running_state = '0' or processComplete = '0' then
                    next_state <= IDLE;  -- Transition back to IDLE state when not running or process is incomplete
                end if;
        end case;
    end process;

    -- Latch active signal assignment
    latchActive <= '1' when current_state = ACTIVE else '0';
end architecture behavioral;
