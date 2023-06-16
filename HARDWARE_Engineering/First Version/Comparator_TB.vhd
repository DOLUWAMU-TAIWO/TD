
library ieee;
use ieee.std_logic_1164.all;

entity Comparator_TB is
end entity Comparator_TB;

architecture Behavioral of Comparator_TB is
    component Comparator is
        port (
            A : in std_logic_vector(3 downto 0);
            B : in std_logic_vector(3 downto 0);
            Equal : out std_logic;
            Set : out std_logic;
            Reset : out std_logic;
            Clk : in std_logic;
            Reset_Input : in std_logic
        );
    end component Comparator;

    -- Inputs
    signal A : std_logic_vector(3 downto 0) := (others => '0');
    signal B : std_logic_vector(3 downto 0) := (others => '0');
    signal Clk : std_logic := '0';
    signal Reset_Input : std_logic := '0';

    -- Outputs
    signal Equal : std_logic;
    signal Set : std_logic;
    signal Reset : std_logic;

begin
    dut: Comparator
        port map (
            A => A,
            B => B,
            Equal => Equal,
            Set => Set,
            Reset => Reset,
            Clk => Clk,
            Reset_Input => Reset_Input
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
        A <= "0000";
        B <= "0000";
        Reset_Input <= '0';

        -- Apply test vectors
        wait for 10 ns; -- Wait for initial signal stability

        -- Test 1: A = B
        A <= "1010";
        B <= "1010";
        wait for 10 ns;
        assert Equal = '1' report "Test 1 failed" severity error;
        assert Set = '1' report "Test 1 failed" severity error;
        assert Reset = '0' report "Test 1 failed" severity error;

        -- Test 2: A <> B
        B <= "0101";
        wait for 10 ns;
        assert Equal = '0' report "Test 2 failed" severity error;
        assert Set = '0' report "Test 2 failed" severity error;
        assert Reset = '1' report "Test 2 failed" severity error;

        -- Test 3: A = B (again)
        B <= "1010";
        wait for 10 ns;
        assert Equal = '1' report "Test 3 failed" severity error;
        assert Set = '1' report "Test 3 failed" severity error;
        assert Reset = '0' report "Test 3 failed" severity error;

        -- Test 4: Reset_Input = '1'
        Reset_Input <= '1';
        wait for 10 ns;
        assert Equal = '0' report "Test 4 failed" severity error;
        assert Set = '0' report "Test 4 failed" severity error;
        assert Reset = '1' report "Test 4 failed" severity error;

        wait;
    end process;

end architecture Behavioral;