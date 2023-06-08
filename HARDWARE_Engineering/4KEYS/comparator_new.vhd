library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator is
    Port (
        reset: in std_logic;
        clk: in std_logic;
        key: in std_logic_vector(3 downto 0);
        passwordMatch: out std_logic;
        s: out bit;
        r: out bit;
        firstKey: in std_logic;   -- Input signal for First Key state
        secondKey: in std_logic;  -- Input signal for Second Key state
        thirdKey: in std_logic;   -- Input signal for Third Key state
        fourthKey: in std_logic;  -- Input signal for Fourth Key state
        runningState: in std_logic -- Input signal for Running State
    );
end entity comparator;

architecture Behavioral of comparator is
    signal passwordMatchReg: std_logic := '0';
    signal count: integer range 0 to 4 := 0;
    
    signal password1: std_logic_vector(3 downto 0) := "1000";
    signal password2: std_logic_vector(3 downto 0) := "0110";
    signal password3: std_logic_vector(3 downto 0) := "0011";
    signal password4: std_logic_vector(3 downto 0) := "0101";
    
    signal sSignal, rSignal: bit := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            passwordMatchReg <= '0';
            count <= 0;
            sSignal <= '0';
            rSignal <= '0';
        elsif rising_edge(clk) then
            if runningState = '1' then
                if count = 0 and firstKey = '1' then
                    if key = password1 then
                        count <= count + 1;
                    else
                        count <= 0;
                    end if;
                elsif count = 1 and secondKey = '1' then
                    if key = password2 then
                        count <= count + 1;
                    else
                        count <= 0;
                    end if;
                elsif count = 2 and thirdKey = '1' then
                    if key = password3 then
                        count <= count + 1;
                    else
                        count <= 0;
                    end if;
                elsif count = 3 and fourthKey = '1' then
                    if key = password4 then
                        count <= count + 1;
                    else
                        count <= 0;
                    end if;
                else
                    count <= 0;
                end if;
                
                if count = 4 then
                    passwordMatchReg <= '1';
                    count <= 0;
                    sSignal <= '1';
                    rSignal <= '0';
                else
                    passwordMatchReg <= '0';
                    sSignal <= '0';
                    rSignal <= '1';
                end if;
            else
                passwordMatchReg <= '0';
                count <= 0;
                sSignal <= '0';
                rSignal <= '0';
            end if;
        end if;
    end process;
    
    passwordMatch <= passwordMatchReg;
    s <= sSignal;
    r <= rSignal;

end Behavioral;
