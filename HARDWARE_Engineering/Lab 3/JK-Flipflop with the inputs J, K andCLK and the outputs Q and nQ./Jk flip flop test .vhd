entity JK_ff_tb is
end entity JK_ff_tb;

architecture Behavioral of JK_ff_tb is
  component JK_ff is
    port (
      J, K, CLK : in bit;
      Q, Qn : out bit
    );
  end component JK_ff;

  signal J_tb, K_tb, CLK_tb : bit;
  signal Q_tb, Qn_tb : bit;

begin

  DUT: JK_ff
    port map (
      J => J_tb,
      K => K_tb,
      CLK => CLK_tb,
      Q => Q_tb,
      Qn => Qn_tb
    );

  -- Simulation process
  simulation: process
  begin
    -- Initialize inputs
    J_tb <= '0';
    K_tb <= '0';
    CLK_tb <= '0';

    -- Hold inputs for a few clock cycles
    wait for 10 ns;

    -- Apply test case 1: J = '1', K = '0'
    J_tb <= '1';
    K_tb <= '0';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;

    -- Apply test case 2: J = '0', K = '1'
    J_tb <= '0';
    K_tb <= '1';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;

    -- Apply test case 3: J = '1', K = '1'
    J_tb <= '1';
    K_tb <= '1';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;

    -- Apply test case 4: J = '0', K = '0'
    J_tb <= '0';
    K_tb <= '0';
    CLK_tb <= '0';
    wait for 10 ns;
    CLK_tb <= '1';
    wait for 10 ns;

    -- Finish simulation
    wait;
  end process simulation;

end architecture Behavioral;

