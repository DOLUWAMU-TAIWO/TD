entity JKFFCOUNTER_TB is
end entity JKFFCOUNTER_TB;

architecture Behavioral of JKFFCOUNTER_TB is
  component JKFFCOUNTER is
    port (
      CLK : in bit;
      Q   : out bit_vector(2 downto 0)
    );
  end component JKFFCOUNTER;

  signal CLK_TB : bit := '0';
  signal Q_TB : bit_vector(2 downto 0) := (others => '0');

begin
  DUT: JKFFCOUNTER
    port map (
      CLK => CLK_TB,
      Q => Q_TB
    );

  CLK_TB_process: process
  begin
    wait for 10 ns;
    
    while now < 100 ns loop  -- Simulate for 100 ns
      CLK_TB <= not CLK_TB;  -- Toggle the clock every time
      wait for 10 ns;        -- Wait for 10 ns for each clock cycle
    end loop;
    wait;
  end process CLK_TB_process;

end architecture Behavioral;

