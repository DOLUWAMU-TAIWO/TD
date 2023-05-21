entity BCD_Decoder_TB is
end entity BCD_Decoder_TB;

architecture Behavioral of BCD_Decoder_TB is
    signal bcd_in : bit_vector(3 downto 0);
    signal seg_out : bit_vector(6 downto 0);
    
    component BCD_Decoder is
        port (
            bcd : in bit_vector(3 downto 0);
            segment : out bit_vector(6 downto 0)
        );
    end component BCD_Decoder;

begin
    DUT: BCD_Decoder port map(bcd => bcd_in, segment => seg_out);
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Testcase 1: Input '0'
        bcd_in <= "0000";
        wait for 10 ns;
        
        -- Testcase 2: Input '3'
        bcd_in <= "0011";
        wait for 10 ns;
        
        -- Testcase 3: Input '7'
        bcd_in <= "0111";
        wait for 10 ns;
        
        -- Testcase 4: Input '9'
        bcd_in <= "1001";
        wait for 10 ns;
        
        -- Testcase 5: Invalid Input
        bcd_in <= "1010";
        wait for 10 ns;
        
        -- Add more testcases if needed
        
        wait;
    end process stim_proc;
end architecture Behavioral;

