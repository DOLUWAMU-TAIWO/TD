library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SequentialKeyPressProcessor is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        running_state : in STD_LOGIC;
        DecodeOut : in STD_LOGIC_VECTOR (3 downto 0);
        Key1Assigned : out STD_LOGIC;
        Key2Assigned : out STD_LOGIC;
        Key1Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key2Value : out STD_LOGIC_VECTOR (3 downto 0)
    );
end SequentialKeyPressProcessor;

architecture Behavioral of SequentialKeyPressProcessor is
    signal prev_key : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal key1_value : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal key2_value : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal key1_assigned : STD_LOGIC := '0';
    signal key2_assigned : STD_LOGIC := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                prev_key <= "0000";
                key1_value <= "0000";
                key2_value <= "0000";
                key1_assigned <= '0';
                key2_assigned <= '0';
            elsif running_state = '1' then
                if DecodeOut /= prev_key then
                    if key1_assigned = '0' then
                        key1_value <= DecodeOut;
                        key1_assigned <= '1';
                    elsif key2_assigned = '0' then
                        key2_value <= DecodeOut;
                        key2_assigned <= '1';
                    end if;
                end if;
                prev_key <= DecodeOut;
            end if;
        end if;
    end process;

    
    Key1Assigned <= key1_assigned;
    Key2Assigned <= key2_assigned;
    Key1Value <= key1_value;
    Key2Value <= key2_value;
end Behavioral;
