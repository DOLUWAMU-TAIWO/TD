library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity myFSM_tb is
end entity myFSM_tb;

architecture testbench of myFSM_tb is
    -- Signals
    signal reset : std_logic := '0';
    signal p : std_logic := '0';
    signal clk : std_logic := '0';
    signal q : bit;
    signal running_state_sig : std_logic;
    signal idle_state_sig : std_logic;

    -- Component Declaration
    component myFSM is
        port (
            reset: in std_logic;
            p: in std_logic;
            clk: in std_logic;
            q: out bit;
            running_state_sig: out std_logic;
            idle_state_sig: out std_logic
        );
    end component myFSM;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: myFSM
        port map (
            reset => reset,
            p => p,
            clk => clk,
            q => q,
            running_state_sig => running_state_sig,
            idle_state_sig => idle_state_sig
        );

    -- Clock Process
    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        wait;
    end process;

    -- Stimulus Process
    stimulus_process: process
    begin
        reset <= '1';  -- Assert reset
        wait for 20 ns;
        reset <= '0';  -- Deassert reset

        -- Test case 1: Idle_state -> Running_state
        p <= '1';  -- Set p to 1
        wait for 40 ns;
        p <= '0';  -- Set p to 0
        wait for 20 ns;

        -- Test case 2: Running_state -> Idle_state
        p <= '0';  -- Set p to 0
        wait for 40 ns;
        p <= '1';  -- Set p to 1
        wait for 20 ns;

        -- Test case 3: Idle_state (no state change)
        p <= '0';  -- Set p to 0
        wait for 40 ns;
        p <= '0';  -- Set p to 0
        wait for 20 ns;

        -- Test case 4: Running_state (no state change)
        p <= '1';  -- Set p to 1
        wait for 40 ns;
        p <= '1';  -- Set p to 1
        wait for 20 ns;

        wait;
    end process;

end architecture testbench;

