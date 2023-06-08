library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_password is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        decodedKey: in std_logic_vector(3 downto 0);
        outputReady: out std_logic;
        key1: out std_logic_vector(3 downto 0);
        passwordMatch: in std_logic;
        fsmTransition: in std_logic;
        keysent: out std_logic
    );
end entity FSM_password;

architecture Behavioral of FSM_password is
    type State is (Check_State, Process_State);
    signal currentState, nextState: State;
    signal keyReg: std_logic_vector(3 downto 0);
begin
    state_memory: process(clk, reset)
    begin
        if reset = '1' then
            currentState <= Check_State;
            keyReg <= (others => '0');
        elsif rising_edge(clk) then
            currentState <= nextState;
            case currentState is
                when Check_State =>
                    if decodedKey /= "0000" then
                        keyReg <= decodedKey;
                        nextState <= Process_State;
                    else
                        nextState <= Check_State;
                    end if;

                when Process_State =>
                    if passwordMatch = '0' or fsmTransition = '1' then
                        nextState <= Check_State;
                    else
                        nextState <= Process_State;
                    end if;
            end case;
        end if;
    end process state_memory;

    outputReady <= '1' when currentState = Process_State else '0';
    key1 <= keyReg;
    

end Behavioral;
