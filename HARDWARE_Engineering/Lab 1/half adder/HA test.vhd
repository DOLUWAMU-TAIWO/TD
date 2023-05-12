entity test is 
end entity;

architecture bench of test is 

  component HA
    port (
      a: in bit;    -- declaration of a input
      b: in bit;    -- declaration of b input
      s: out bit;   -- declaration of s output
      co: out bit   -- declaration of co output (missing semicolon)
    );
  end component;

  -- declaration of test signals 
  signal a_tb, b_tb, co_tb, s_tb: bit;

begin 

  uut: HA port map(a_tb, b_tb, s_tb, co_tb); -- map signals to real input and output 

  a_tb <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns; -- assign test signal values to run through the real half-circuit 
  b_tb <= '0', '0' after 20 ns, '1' after 40 ns, '1' after 60 ns;

end architecture;


