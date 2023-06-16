library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DisplayController_tb is
end entity DisplayController_tb;

architecture behavioral of DisplayController_tb is
    -- Component declaration for the DisplayController module
    component DisplayController is
        Port ( 
            clk         : in  std_logic;                     -- Clock signal
            correct     : in  bit;                            -- Signal representing correct input
            wrong       : in  bit;                            -- Signal representing wrong input
            reset       : in  std_logic;                      -- Reset signal
            idle_state  : in std_logic;                       -- Signal representing idle state
            nokey       : in std_logic;                        -- Signal representing no key pressed
            anode       : out std_logic_vector(7 downto 0);   -- Controls the display digits
            segOut      : out std_logic_vector(6 downto 0);   -- Seven-segment display output
            buzzer      : out std_logic;                      -- Buzzer output for main code
            buzzergreen : out std_logic;                      -- Buzzer output for "no key" condition
            buzzerblue  : out std_logic                       -- Buzzer output for wrong input
        );
    end component DisplayController;

    -- Signals for testbench stimulus
    signal clk : std_logic := '0';
    signal correct_in, wrong_in : bit;
    signal reset_in, idle_state_in, nokey_in : std_logic;
    signal anode_out : std_logic_vector(7 downto 0);
    signal segOut_out : std_logic_vector(6 downto 0);
    signal buzzer_out, buzzergreen_out, buzzerblue_out : std_logic;

begin
    -- Instantiate the DisplayController module
    dut: DisplayController
    port map (
        clk => clk,
        correct => correct_in,
        wrong => wrong_in,
        reset => reset_in,
        idle_state => idle_state_in,
        nokey => nokey_in,
        anode => anode_out,
        segOut => segOut_out,
        buzzer => buzzer_out,
        buzzergreen => buzzergreen_out,
        buzzerblue => buzzerblue_out
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
        correct_in <= '1';
        wrong_in <= '1';
        reset_in <= '1';
        idle_state_in <= '1';
        
        wait for 20 ns;

        nokey_in <= '1';
        wait for 10 ns;

        -- Test case 1: Set correct = 1, wrong = 0
        nokey_in <= '0';
        idle_state_in <= '0';
        correct_in <= '1';
        wrong_in <= '0';
        wait for 10 ns;

        -- Test case 2: Set correct = 0, wrong = 1
        correct_in <= '0';
        wrong_in <= '1';
        wait for 10 ns;

        -- Test case 3: Set correct = 1, wrong = 1
        nokey_in <= '0';
        idle_state_in <= '0';
        correct_in <= '1';
        wrong_in <= '1';
        wait for 10 ns;

        -- Test case 4: Set correct = 0, wrong = 0
        nokey_in <= '0';
        idle_state_in <= '0';
        correct_in <= '0';
        wrong_in <= '0';
        wait for 10 ns;

        -- End of testbench
        wait;
    end process stimulus;

end behavioral;

