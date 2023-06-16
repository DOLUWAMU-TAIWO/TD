library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_final_tb is
end entity comparator_final_tb;

architecture behavioral of comparator_final_tb is
    -- Component declaration for the comparator_final module
    component comparator_final is
        port (
            match1comp : in std_logic;
            match2comp : in std_logic;
            match3comp : in std_logic;
            match4comp : in std_logic;
            clk : in std_logic;
            reset : in std_logic;
            running_state : in std_logic;
            AnyKeyPressed : in std_logic;
            s : out bit;
            r : out bit;
            processComplete : out std_logic
        );
    end component comparator_final;

    -- Signals for testbench stimulus
    signal match1comp_in, match2comp_in, match3comp_in, match4comp_in : std_logic;
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal running_state, AnyKeyPressed : std_logic;
    signal s_out, r_out : bit;
    signal comp1Complete, comp2Complete, comp3Complete, comp4Complete, processComplete : std_logic;

begin
    -- Instantiate the comparator_final module
    dut: comparator_final
    port map (
       
        match1comp => match1comp_in,
        match2comp => match2comp_in,
        match3comp => match3comp_in,
        match4comp => match4comp_in,
        clk => clk,
        reset => reset,
        running_state => running_state,
        AnyKeyPressed => AnyKeyPressed,
        s => s_out,
        r => r_out,
        processComplete => processComplete
    );

    -- Clock process with a period of 10 ns
    clk_process: process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process clk_process;

    -- Stimulus process
    stimulus: process
    begin
        -- Initial values
        match1comp_in <= '1';
        match2comp_in <= '0';
        match3comp_in <= '0';
        match4comp_in <= '1';
        running_state <= '1';
        AnyKeyPressed <= '1';
        reset <= '1';
        wait for 20 ns;

        -- Test case 1: Set s = 0, r = 0
        match1comp_in <= '1';
        match2comp_in <= '1';
        match3comp_in <= '1';
        match4comp_in <= '1';
        running_state <= '1';
        AnyKeyPressed <= '1';
        reset <= '0';
        wait for 10 ns;

        wait;
    end process stimulus;
end architecture behavioral;

