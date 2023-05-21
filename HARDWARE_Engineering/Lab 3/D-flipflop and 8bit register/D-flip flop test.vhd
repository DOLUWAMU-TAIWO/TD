entity DFlipFlop_TB is
end entity DFlipFlop_TB;

architecture Behavioral of DFlipFlop_TB is
  component DFlipFlop is
    port (
      D : in bit;
      CLK : in bit;
      Q : out bit;
      QN : out bit
    );
  end component;

  signal D_tb, CLK_tb : bit;
  signal Q_tb, QN_tb : bit;
begin
  uut: DFlipFlop port map (D_tb, CLK_tb, Q_tb, QN_tb);

  CLK_tb <= '0', '1'  after 5 ns;  -- Clock signal generation

  process
  begin
    D_tb <= '0';
    wait for 2 ns;

    D_tb <= '1';
    wait for 4 ns;

    D_tb <= '0';
    wait for 3 ns;

    D_tb <= '1';
    wait;
  end process;
end architecture Behavioral;

