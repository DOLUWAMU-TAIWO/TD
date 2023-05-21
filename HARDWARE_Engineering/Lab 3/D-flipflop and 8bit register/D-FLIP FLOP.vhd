entity DFlipFlop is
  port (
    D : in bit;
    CLK : in bit;
    Q : out bit;
    QN : out bit
  );
end entity DFlipFlop;

architecture Behavioral of DFlipFlop is
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      Q <= D;
      QN <= not D;
    end if;
  end process;
end architecture Behavioral;

