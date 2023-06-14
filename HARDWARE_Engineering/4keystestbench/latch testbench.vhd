library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch_tb is
end entity latch_tb;

architecture testbench of latch_tb is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;  -- Clock period

    -- Signals
    signal s : bit;
    signal r : bit;
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal process_complete : std_logic := '0';
    signal correct : bit;
    signal wrong : bit;

begin

    -- Clock process
    process
    begin
        while now < 100 ns loop  -- Run for 100 ns
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Initialize inputs
        s <= '0';
        r <= '0';
        reset <= '1';
        process_complete <= '0';
        wait for 20 ns;

        reset <= '0';  -- Deassert reset
        wait for 10 ns;

        process_complete <= '1';
        wait for 10 ns;
        s <= '0';  -- Pass inputs when latch_active = '0'
        r <= '0';
        wait for 10 ns;

        process_complete <= '1';
        wait for 10 ns;
        s <= '1';  -- Pass inputs when latch_active = '1'
        r <= '0';
        wait for 10 ns;

        process_complete <= '1';
        wait for 10 ns;
        s <= '0';  -- Pass different inputs when latch_active = '1'
        r <= '1';
        wait for 10 ns;

        process_complete <= '1';
        wait for 10 ns;
        s <= '1';  -- Pass different inputs when latch_active = '1'
        r <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;
end architecture testbench;

