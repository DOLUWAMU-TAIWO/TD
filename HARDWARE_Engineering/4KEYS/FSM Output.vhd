library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_output_ready_generator is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        outputReady: in std_logic;
        outputReady_First: out std_logic;
        outputReady_Second: out std_logic;
        outputReady_Third: out std_logic;
        outputReady_Fourth: out std_logic
    );
end entity FSM_output_ready_generator;

architecture Behavioral of FSM_output_ready_generator is
    type State is (State1, State2, State3, State4);
    signal currentState, nextState: State;
begin
    -- State memory process
    state_memory: process(clk, reset)
    begin
        if reset = '1' then
            currentState <= State1;
        elsif rising_edge(clk) then
            currentState <= nextState;
        end if;
    end process state_memory;

    -- Next state logic process
    next_state_logic: process(currentState, outputReady)
    begin
        case currentState is
            when State1 =>
                if outputReady = '1' then
                    nextState <= State2;
                else
                    nextState <= State1;
                end if;

            when State2 =>
                if outputReady = '1' then
                    nextState <= State3;
                else
                    nextState <= State2;
                end if;

            when State3 =>
                if outputReady = '1' then
                    nextState <= State4;
                else
                    nextState <= State3;
                end if;

            when State4 =>
                if outputReady = '1' then
                    nextState <= State1;
                else
                    nextState <= State4;
                end if;
        end case;
    end process next_state_logic;

    -- Output generation process
    output_generation: process(currentState)
    begin
        case currentState is
            when State1 =>
                outputReady_First <= '1';
                outputReady_Second <= '0';
                outputReady_Third <= '0';
                outputReady_Fourth <= '0';
            when State2 =>
                outputReady_First <= '0';
                outputReady_Second <= '1';
                outputReady_Third <= '0';
                outputReady_Fourth <= '0';
            when State3 =>
                outputReady_First <= '0';
                outputReady_Second <= '0';
                outputReady_Third <= '1';
                outputReady_Fourth <= '0';
            when State4 =>
                outputReady_First <= '0';
                outputReady_Second <= '0';
                outputReady_Third <= '0';
                outputReady_Fourth <= '1';
        end case;
    end process output_generation;
    
end Behavioral;
