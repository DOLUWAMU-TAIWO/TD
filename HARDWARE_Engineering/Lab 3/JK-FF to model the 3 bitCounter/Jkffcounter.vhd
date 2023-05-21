entity JKFFCOUNTER is
  port (
   CLK : in bit;
    Q   : out bit_vector(2 downto 0)
  );
end entity JKFFCOUNTER;

architecture Behavioral of JKFFCOUNTER is
  component JK_ff is
    port (
      J, K, CLK : in bit;
      Q, Qn     : out bit
    );
  end component JK_ff;

  signal Q2, Q1, Q0 : bit;
  signal K_intermediate: bit;
  signal k_intermediate2: bit;

begin

  FF0: JK_ff
    port map (
      J => '1',
      K => '0',
      CLK => CLK,
      Q => Q0,
      Qn => open
    );
 
  k_intermediate2 <= not Q0;
  FF1: JK_ff
    port map (
      J => Q0,
     K => k_intermediate2 ,
    CLK => CLK,
      Q => Q1,
      Qn => open
    );

  K_intermediate <= not (Q1 and Q0); -- Assign intermediate result to a signal

  FF2: JK_ff
    port map (
      J => Q1,
      K => K_intermediate, -- Use the intermediate signal
      CLK => CLK,
      Q => Q2,
      Qn => open
    );

  Q <= Q2 & Q1 & Q0;

end architecture Behavioral;
