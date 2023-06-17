----------------------------------------------------------------------------------
-- Company: HSHL
-- Engineer: Doluwamu Kuye  
-- Create Date:    17:05:39 07/06/2023 
--
-- Module Name:   Comparator2 - Behavioural
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

entity comparator2 is
    port (
        secondKeyPressed : in std_logic_vector(3 downto 0);  -- Input for the first key pressed
        clk : in std_logic;                                 -- Clock signal
        reset : in std_logic;                               -- Reset signal
        running_state : in std_logic;                        -- Running state signal from FSM
        AnyKeyPressed : in std_logic;                       -- Signal indicating if any key is pressed
        match2comp : out std_logic;                          -- Signal indicating a match with the second password
        nokey : out std_logic;                               -- Signal indicating no key is pressed
        comp2Complete : out std_logic                        -- Signal indicating completion of the comparison process for comp2
    );
end entity comparator2;

architecture behavioral of comparator2 is
    signal password : std_logic_vector(3 downto 0) := "0110";  -- Set password to "0110" (binary)
begin
    process (clk, reset, secondKeyPressed, running_state, AnyKeyPressed)
    begin
        if reset = '1' then
            nokey <= '0';
            match2comp <= '0';
            comp2Complete <= '0';
        elsif rising_edge(clk) then
            if AnyKeyPressed = '0' then
                nokey <= '1';   -- Set nokey to '1' if no key is pressed
                match2comp <= '0';
               comp2Complete <= '0';
            elsif running_state = '1' then
                nokey <= '0';
                if secondKeyPressed = password then
                    match2comp <= '1';   -- Set match2comp to '1' if the secondKeyPressed matches the password
                else
                    match2comp <= '0';   -- Set match2comp to '0' if the secondKeyPressed does not match the password
                end if;
                comp2Complete <= '1';  -- Set comp2Complete to '1' to indicate completion of the comparison process for comp2
            else
                nokey <= '0';
                match2comp <= '0';   -- No operation when not in the running state
                comp2Complete <= '0';  -- Set comp2Complete to '0' as process for comp2 is not complete
            end if;
        end if;
    end process;
end architecture behavioral;
