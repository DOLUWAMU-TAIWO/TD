entity JK_ff is
  port (
    J, K, CLK : in bit;
    Q, Qn : out bit
  );
end entity JK_ff;

architecture Behavioral of JK_ff is
  signal Q_new : bit;
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if J = '1' and K = '1' then
        Q_new <= not Q_new;  -- Toggle Q when both J and K are '1'
      elsif J = '1' then
        Q_new <= '1';       -- Set Q to '1' when J is '1'
      elsif K = '1' then
        Q_new <= '0';       -- Reset Q to '0' when K is '1'
      end if;
    end if;
  end process;

  Q <= Q_new;
  Qn <= not Q_new;
end architecture Behavioral;

