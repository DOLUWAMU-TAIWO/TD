entity FA is
    port(a: in bit;
         b: in bit;
         cin: in bit;
         sum: out bit;
         cout: out bit);
end entity FA;

architecture Behavioural of FA is

 component HA
    port (a :in bit;
          b : in bit;
          s : out bit;
          co : out bit); 
end component;
signal sumout: bit;
 signal co1, co2: bit;
begin 
  
-- Instantiate first half adder
    ha1: HA port map(a => a, b => b, s => sumout, co => co1);

    -- Instantiate second half adder
    ha2: HA port map(a => sumout, b => cin, s => sum, co => co2);
    -- Calculate carry-out bit
    cout <= co1 or co2;
end architecture Behavioural;
