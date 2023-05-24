entity ShiftRegister is
  port (
    D : in bit;
    CLK : in bit;
    Q : out bit_vector(7 downto 0)
  );
end entity ShiftRegister;

architecture Behavioral of ShiftRegister is
  component DFlipFlop is
    port (
      D : in bit;
      CLK : in bit;
      Q : out bit;
      QN : out bit
    );
  end component DFlipFlop;

  signal Q_intermediate : bit_vector(7 downto 0);
begin
  -- Instantiate the D flip-flops and connect them 
  FF0: DFlipFlop port map (D => D, CLK => CLK, Q => Q_intermediate(0), QN => open);
  FF1: DFlipFlop port map (D => Q_intermediate(0), CLK => CLK, Q => Q_intermediate(1), QN => open);
  FF2: DFlipFlop port map (D => Q_intermediate(1), CLK => CLK, Q => Q_intermediate(2), QN => open);
  FF3: DFlipFlop port map (D => Q_intermediate(2), CLK => CLK, Q => Q_intermediate(3), QN => open);
  FF4: DFlipFlop port map (D => Q_intermediate(3), CLK => CLK, Q => Q_intermediate(4), QN => open);
  FF5: DFlipFlop port map (D => Q_intermediate(4), CLK => CLK, Q => Q_intermediate(5), QN => open);
  FF6: DFlipFlop port map (D => Q_intermediate(5), CLK => CLK, Q => Q_intermediate(6), QN => open);
  FF7: DFlipFlop port map (D => Q_intermediate(6), CLK => CLK, Q => Q_intermediate(7), QN => open);

  -- Assign the final output
  Q <= Q_intermediate;
end architecture Behavioral;
