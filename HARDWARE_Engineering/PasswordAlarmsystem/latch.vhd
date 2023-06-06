----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2023 02:25:16
-- Design Name: 
-- Module Name: Latch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch is
    port (
        s : in bit;               -- Signal to set the latch
        r : in bit;               -- Signal to reset the latch
        clk : in std_logic;       -- Clock signal
        reset : in std_logic;     -- Reset signal
        correct : out bit;        -- Signal representing correct input
        wrong : out bit           -- Signal representing wrong input
    );
end entity latch;

architecture behavioral of latch is
begin
    process (clk, reset)
    begin
        if reset = '1' then
            correct <= '0';
            wrong <= '0';
        elsif rising_edge(clk) then
            if (s = '1') and (r = '0') then
                correct <= '1';     -- Set correct when s = '1' and r = '0'
                wrong <= '0';       -- Clear wrong
            else
                correct <= '0';     -- Clear correct for all other cases
                wrong <= '1';       -- Set wrong
            end if;
        end if;
    end process;
end architecture behavioral;
