library ieee;
use ieee.std_logic_1164.all;

entity comparator_tb is
end entity comparator_tb;

architecture behavioral of comparator_tb is
    component comparator is
        port (
            firstKeyPressed : in std_logic_vector(3 downto 0);
            clk : in std_logic;
            reset : in std_logic;
            running_state : in std_logic;
            AnyKeyPressed : in std_logic;
            match1comp : out std_logic;
            nokey : out std_logic;
            comp1Complete : out std_logic
        );
    end component comparator;

    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal running_state : std_logic := '0';
    signal AnyKeyPressed : std_logic := '0';
    signal firstKeyPressed : std_logic_vector(3 downto 0) := "0000";
    signal match1comp : std_logic;
    signal nokey : std_logic;
    signal comp1Complete : std_logic;
begin
    dut: comparator
        port map (
            firstKeyPressed => firstKeyPressed,
            clk => clk,
            reset => reset,
            running_state => running_state,
            AnyKeyPressed => AnyKeyPressed,
            match1comp => match1comp,
            nokey => nokey,
            comp1Complete => comp1Complete
        );

    -- Clock process
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
    stimulus_process: process
    begin
        -- Test case 1: No key is pressed
        reset <= '1';
        running_state <= '1';
        AnyKeyPressed <= '0';
        
        wait for 10 ns;

        -- Test case 2: Key is pressed but does not match
        reset <= '0';
        AnyKeyPressed <= '1';
        firstKeyPressed <= "0101";
        wait for 10 ns;

        -- Test case 3: Key matches
        firstKeyPressed <= "1000";
        wait for 10 ns;

        -- Test case 10: No key is pressed again, running state is '0'
        firstKeyPressed <= "0000";
        wait;

    end process stimulus_process;
end architecture behavioral;

