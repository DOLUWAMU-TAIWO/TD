entity ShiftRegister_tb is
end entity ShiftRegister_tb;

architecture Behavioral of ShiftRegister_tb is
  component ShiftRegister is
    port (
      D : in bit;
      CLK : in bit;
      Q : out bit_vector(7 downto 0)
    );
  end component ShiftRegister;

  signal D_tb, CLK_tb : bit;
  signal Q_tb : bit_vector(7 downto 0);

begin

  DUT: entity work.ShiftRegister
    port map (
      D => D_tb,
      CLK => CLK_tb,
      Q => Q_tb
    );

  -- Stimulus process
  stimulus: process
  begin
    -- Initialize inputs
    D_tb <= '0';
    CLK_tb <= '0';

    -- Apply test case 1
    D_tb <= '1';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;

    -- Apply test case 2
    D_tb <= '0';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;

    -- Apply test case 3
    D_tb <= '1';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;


    -- Finish simulation
    wait;
  end process stimulus;

end architecture Behavioral;

