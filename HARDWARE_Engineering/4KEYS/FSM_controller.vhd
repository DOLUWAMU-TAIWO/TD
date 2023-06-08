library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity myFSM is
    port (
        reset: in std_logic;
        p: in std_logic;
        clk: in std_logic;
        q: out bit;
        running_state_sig: out std_logic;
        idle_state_sig: out std_logic
    );
end entity myFSM;

architecture behavioral of myFSM is
    type state is (Idle_state, Running_state);
    signal current_state, next_state: state;
begin
    state_memory: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= Idle_state;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    FSM_control: process(current_state, p)
    begin
        case current_state is
            when Idle_state =>
                if p = '1' then
                    next_state <= Running_state;
                else
                    next_state <= Idle_state;
                end if;

            when Running_state =>
                if p = '0' then
                    next_state <= Idle_state;
                else
                    next_state <= Running_state;
                end if;
        end case;
    end process;

    running_state_sig <= '1' when current_state = Running_state else '0';
    idle_state_sig <= '1' when current_state = Idle_state else '0';
    q <= '1' when current_state = Running_state else '0';
end behavioral;
