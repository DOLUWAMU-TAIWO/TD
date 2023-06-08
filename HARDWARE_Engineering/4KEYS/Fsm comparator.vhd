library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_comparator is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        outputReady_First: in std_logic;
        outputReady_Second: in std_logic;
        outputReady_Third: in std_logic;
        outputReady_Fourth: in std_logic;
        firstKey: out std_logic;
        secondKey: out std_logic;
        thirdKey: out std_logic;
        fourthKey: out std_logic;
        fsmTransition: out std_logic
    );
end entity FSM_comparator;

architecture Behavioral of FSM_comparator is
    type State is (First_Key, Second_Key, Third_Key, Fourth_Key);
    signal currentState, nextState: State;
    signal fsmTransitionReg: std_logic := '0';  -- Removed fsmTransitionRegDelayed

begin

    memory_process: process(clk, reset)
    begin
        if reset = '1' then
            currentState <= First_Key;
            fsmTransitionReg <= '0';
        elsif rising_edge(clk) then
            currentState <= nextState;
            -- fsmTransitionReg <= fsmTransitionRegDelayed;  -- Removed delayed value assignment
        end if;
    end process memory_process;

    next_state_process: process(currentState, outputReady_First, outputReady_Second, outputReady_Third, outputReady_Fourth)
    begin
        case currentState is
            when First_Key =>
                if outputReady_First = '1' then
                    nextState <= Second_Key;
                    fsmTransitionReg <= '1';
                else
                    nextState <= First_Key;
                    fsmTransitionReg <= '0';
                end if;
            
            when Second_Key =>
                if outputReady_Second = '1' then
                    nextState <= Third_Key;
                    fsmTransitionReg <= '1';
                else
                    nextState <= Second_Key;
                    fsmTransitionReg <= '0';
                end if;
            
            when Third_Key =>
                if outputReady_Third = '1' then
                    nextState <= Fourth_Key;
                    fsmTransitionReg <= '1';
                else
                    nextState <= Third_Key;
                    fsmTransitionReg <= '0';
                end if;
            
            when Fourth_Key =>
                if outputReady_Fourth = '1' then
                    nextState <= First_Key;
                    fsmTransitionReg <= '1';
                else
                    nextState <= Fourth_Key;
                    fsmTransitionReg <= '0';
                end if;
        end case;
    end process next_state_process;
    
    output_process: process(currentState)
    begin
        case currentState is
            when First_Key =>
                firstKey <= '1';
                secondKey <= '0';
                thirdKey <= '0';
                fourthKey <= '0';
            
            when Second_Key =>
                firstKey <= '0';
                secondKey <= '1';
                thirdKey <= '0';
                fourthKey <= '0';
            
            when Third_Key =>
                firstKey <= '0';
                secondKey <= '0';
                thirdKey <= '1';
                fourthKey <= '0';
            
            when Fourth_Key =>
                firstKey <= '0';
                secondKey <= '0';
                thirdKey <= '0';
                fourthKey <= '1';
        end case;
    end process output_process;
    
    fsmTransition <= fsmTransitionReg;

end Behavioral;
