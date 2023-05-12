
entity test is 
end entity;

architecture bench of test is 

Component RCA is 
port (
    a: in bit_vector(3 downto 0);  
    b: in bit_vector(3 downto 0);  
    cin: in bit;                   
    sum: out bit_vector(3 downto 0); 
    cout: out bit                  
);
end component;



-- Declare the input and output signals
    signal a_tb: bit_vector(3 downto 0);
    signal b_tb: bit_vector(3 downto 0);
    signal cin_tb: bit;
    signal sum_tb: bit_vector(3 downto 0);
    signal cout_tb: bit;
Begin

uut: RCA port map(a => a_tb, b => b_tb, cin => cin_tb, sum => sum_tb, cout => cout_tb);

a_tb <="0000","1000" after 20 ns, "0001" after 40 ns, "1111" after 60 ns;
b_tb <="0000","0001" after 20 ns, "1010" after 40 ns, "1110" after 60 ns;
cin_tb <= '0','0' after 20 ns, '1' after 40 ns, '0' after 60 ns;
end architecture;

