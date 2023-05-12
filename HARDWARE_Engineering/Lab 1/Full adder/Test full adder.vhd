entity test is 
end entity;

architecture bench of test is 
component FA
   port(a: in bit;
         b: in bit;
         cin: in bit;
         sum: out bit;
         cout: out bit);
end component;
signal a_tb,b_tb,cin_tb,sum_tb,cout_tb: bit;
begin 

uut: FA port map(a_tb,b_tb,cin_tb,sum_tb,cout_tb);

a_tb <='0','1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
b_tb <='0','0' after 20 ns, '1' after 40 ns, '1' after 60 ns;
cin_tb <= '0','1' after 20 ns, '0' after 40 ns, '0' after 60 ns;
end architecture;
