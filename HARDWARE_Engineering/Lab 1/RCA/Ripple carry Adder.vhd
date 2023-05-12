entity RCA is
    port (
        a: in bit_vector(3 downto 0);  
        b: in bit_vector(3 downto 0);  
        cin: in bit;                   
        sum: out bit_vector(3 downto 0);  
        cout: out bit                  
    );
end entity RCA;

architecture Behavioral of RCA is
    component FA is
        port (
            a: in bit;                
            b: in bit;               
            cin: in bit;              
            sum: out bit;             
            cout: out bit             
        );
    end component FA;

    signal carry: bit_vector(3 downto 0);  -- internal signal to store the carry bits

begin
    -- Connect the full adders to form a ripple carry adder
    FA0: FA port map(a => a(0), b => b(0), cin => cin, sum => sum(0), cout => carry(0));  -- instantiate the first full adder, using input bits a(0), b(0), and cin as inputs, and sum(0) and carry(0) as outputs
    FA1: FA port map(a => a(1), b => b(1), cin => carry(0), sum => sum(1), cout => carry(1));  -- instantiate the second full adder, using input bits a(1), b(1), and the carry-out from the first full adder as inputs, and sum(1) and carry(1) as outputs
    FA2: FA port map(a => a(2), b => b(2), cin => carry(1), sum => sum(2), cout => carry(2));  -- instantiate the third full adder, using input bits a(2), b(2), and the carry-out from the second full adder as inputs, and sum(2) and carry(2) as outputs
    FA3: FA port map(a => a(3), b => b(3), cin => carry(2), sum => sum(3), cout => cout);  -- instantiate the fourth full adder, using input bits a(3), b(3), and the carry-out from the third full adder as inputs, and sum(3) and cout as outputs
end architecture Behavioral;


