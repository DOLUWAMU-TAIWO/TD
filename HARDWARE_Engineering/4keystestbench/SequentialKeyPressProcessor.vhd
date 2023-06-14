library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SequentialKeyPressProcessor_tb is
end entity SequentialKeyPressProcessor_tb;

architecture behavioral of SequentialKeyPressProcessor_tb is
    -- Component declaration for the SequentialKeyPressProcessor module
    component SequentialKeyPressProcessor is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            running_state : in STD_LOGIC;
            DecodeOut : in STD_LOGIC_VECTOR (3 downto 0);
            Key1Assigned : out STD_LOGIC;
            Key2Assigned : out STD_LOGIC;
            Key3Assigned : out STD_LOGIC;
            Key4Assigned : out STD_LOGIC;
            Key1Value : out STD_LOGIC_VECTOR (3 downto 0);
            Key2Value : out STD_LOGIC_VECTOR (3 downto 0);
            Key3Value : out STD_LOGIC_VECTOR (3 downto 0);
            Key4Value : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component SequentialKeyPressProcessor;

    -- Signals for testbench stimulus
    signal clk : STD_LOGIC := '0';
    signal reset_in, running_state_in : STD_LOGIC;
    signal DecodeOut_in : STD_LOGIC_VECTOR (3 downto 0);
    signal Key1Assigned_out, Key2Assigned_out, Key3Assigned_out, Key4Assigned_out : STD_LOGIC;
    signal Key1Value_out, Key2Value_out, Key3Value_out, Key4Value_out : STD_LOGIC_VECTOR (3 downto 0);

begin
    -- Instantiate the SequentialKeyPressProcessor module
    dut: SequentialKeyPressProcessor
    port map (
        clk => clk,
        reset => reset_in,
        running_state => running_state_in,
        DecodeOut => DecodeOut_in,
        Key1Assigned => Key1Assigned_out,
        Key2Assigned => Key2Assigned_out,
        Key3Assigned => Key3Assigned_out,
        Key4Assigned => Key4Assigned_out,
        Key1Value => Key1Value_out,
        Key2Value => Key2Value_out,
        Key3Value => Key3Value_out,
        Key4Value => Key4Value_out
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
        reset_in <= '0';
        running_state_in <= '1';
        
        wait for 20 ns;

        -- Test case: Pass four decoded keys
        DecodeOut_in <= "0001";
        wait for 10 ns;

        DecodeOut_in <= "0010";
        wait for 10 ns;

        DecodeOut_in <= "0100";
        wait for 10 ns;

        DecodeOut_in <= "1000";
        wait for 10 ns;

        -- End of testbench
        wait;
    end process stimulus;

end behavioral;

