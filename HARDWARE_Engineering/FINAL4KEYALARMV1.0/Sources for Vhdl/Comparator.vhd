----------------------------------------------------------------------------------
-- Company: HSHL
-- Engineer: Doluwamu Kuye  
-- Create Date:    17:05:39 07/06/2023 
--
-- Module Name:   Comparator - Behavioural
-- Project Name:  Alarm system
-- Target Devices: Nexys A7
-- Tool versions: Xilinx ISE 13.2 
-- Description: 
--	This file defines a comparator module that checks a key pressed value against a set password.
--
-- Revision: 1.4
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        firstKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match1comp : out std_logic;                          -- Signal indicating a match with the first password
        nokey : out std_logic;                              -- Signal indicating no key is pressed
        comp1Complete : out std_logic                        -- Signal indicating completion of the comparison process for comp1
    );
end entity comparator;
architecture behavioral of comparator is
    signal password : std_logic_vector(3 downto 0) := "1000";  -- Set password to "1000" (binary)
begin
    process (clk, reset, firstKeyPressed, running_state, AnyKeyPressed)
    begin
        if reset = '1' then
            nokey <= '0';
            match1comp <= '0';
            comp1Complete <= '0';
        elsif rising_edge(clk) then
            if AnyKeyPressed = '0' then
                nokey <= '1';   -- Set nokey to '1' if no key is pressed
                match1comp <= '0';
                comp1Complete <= '0'; -- Set comp1Complete to '1' to indicate completion of the comparison process for comp1
            elsif running_state = '1' then
                nokey <= '0';
                if firstKeyPressed = password then
                    match1comp <= '1';   -- Set match1comp to '1' if the firstKeyPressed matches the password
                else
                    match1comp <= '0';   -- Set match1comp to '0' if the firstKeyPressed does not match the password
                end if;
                comp1Complete <= '1';  -- Set comp1Complete to '1' to indicate completion of the comparison process for comp1
            else
                nokey <= '0';
                match1comp <= '0';   -- No operation when not in the running state
                comp1Complete <= '0';  -- Set comp1Complete to '0' as process for comp1 is not complete
            end if;
        end if;
    end process;
end architecture behavioral;
