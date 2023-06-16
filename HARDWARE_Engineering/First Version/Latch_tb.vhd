library ieee;
use ieee.std_logic_1164.all;

entity Latch_TB is
end entity Latch_TB;

architecture Behavioral of Latch_TB is
    component Latch is
        port (
            Clk : in std_logic;
            Set : in std_logic;
            Reset : in std_logic;
            D : in std_logic;
            Q : out std_logic
        );
    end component Latch;
    
    -- Inputs
    signal Clk : std_logic := '0';
    signal Set : std_logic := '0';
    signal Reset : std_logic := '0';
    signal D : std_logic := '0';

    -- Outputs
    signal Q : std_logic;

begin
    dut: Latch
        port map (
            Clk => Clk,
            Set => Set,
            Reset => Reset,
            D => D,
            Q => Q
        );

    -- Clock process
    process
    begin
        while now < 100 ns loop
            Clk <= '0';
            wait for 5 ns;
            Clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Initialize inputs
        Set <= '0';
        Reset <= '0';
        D <= '0';

        -- Apply test vectors
        wait for 10 ns; -- Wait for initial signal stability

        -- Test 1: Set the latch
        Set <= '1';
        wait for 10 ns;
        assert Q = '1' report "Test 1 failed" severity error;
        Set <= '0';
        wait for 10 ns;

        -- Test 2: Hold previous value
        D <= '1';
        wait for 10 ns;
        assert Q = '1' report "Test 2 failed" severity error;
        D <= '0';
        wait for 10 ns;

        -- Test 3: Reset the latch
        Reset <= '1';
        wait for 10 ns;
        assert Q = '0' report "Test 3 failed" severity error;
        Reset <= '0';
        wait for 10 ns;

        -- Test 4: Hold previous value
        D <= '1';
        wait for 10 ns;
        assert Q = '1' report "Test 4 failed" severity error;
        D <= '0';
        wait for 10 ns;

        -- Test 5: No changes
        wait for 10 ns;
        assert Q = '0' report "Test 5 failed" severity error;

        wait;
    end process;

end architecture Behavioral;
